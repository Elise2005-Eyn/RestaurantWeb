package Controllers;

import DAO.MenuDAO;
import DAO.ReservationDAO;
import DAO.CustomerDAO;
import Models.MenuItem;
import Models.Reservation;
import Models.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/book-table")
public class BookTableController extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final MenuDAO menuDAO = new MenuDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    // ====== Cấu hình ca cố định (UI & BE phải đồng bộ) ======
    private static final LocalTime[][] SLOTS = new LocalTime[][]{
        {LocalTime.of(8, 0),  LocalTime.of(10, 0)},
        {LocalTime.of(10, 0), LocalTime.of(12, 0)},
        {LocalTime.of(12, 0), LocalTime.of(14, 0)},
        {LocalTime.of(18, 0), LocalTime.of(20, 0)},
        {LocalTime.of(20, 0), LocalTime.of(22, 0)}
    };

    private static boolean isValidSlot(LocalTime start, int durationMinutes) {
        for (LocalTime[] s : SLOTS) {
            if (start.equals(s[0]) &&
                durationMinutes == Duration.between(s[0], s[1]).toMinutes()) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            req.setAttribute("error", "Vui lòng đăng nhập trước khi đặt bàn.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        List<MenuItem> menuList = menuDAO.getAllMenuItems();
        req.setAttribute("menuList", menuList);
        req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            req.setAttribute("error", "Vui lòng đăng nhập trước khi đặt bàn.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        String date = trim(req.getParameter("date"));       // yyyy-MM-dd
        String time = trim(req.getParameter("time"));       // HH:mm (giờ BẮT ĐẦU ca)
        String duration = trim(req.getParameter("duration")); // phút (thường 120)
        String guestCount = trim(req.getParameter("guestCount"));
        String note = req.getParameter("note");
        String orderType = trim(req.getParameter("orderType")); // "Đặt món trước"/"Gọi món tại nơi"...

        try {
            // --- Validate cơ bản ---
            if (date == null || time == null || duration == null || guestCount == null
                    || date.isEmpty() || time.isEmpty() || duration.isEmpty() || guestCount.isEmpty()) {
                fail(req, resp, "Vui lòng nhập đầy đủ thông tin đặt bàn.");
                return;
            }

            LocalDate bookingDate = LocalDate.parse(date);
            if (bookingDate.isBefore(LocalDate.now())) {
                fail(req, resp, "⛔ Không thể đặt bàn vào ngày trong quá khứ.");
                return;
            }

            int durationMinutes = Integer.parseInt(duration);
            if (durationMinutes <= 0) {
                fail(req, resp, "⚠️ Thời lượng đặt bàn phải lớn hơn 0 phút.");
                return;
            }

            int guest = Integer.parseInt(guestCount);
            if (guest < 1) {
                fail(req, resp, "⚠️ Số khách phải từ 1 trở lên.");
                return;
            }

            LocalTime start = LocalTime.parse(time); // giờ BẮT ĐẦU ca
            LocalTime end = start.plusMinutes(durationMinutes);

            // Chỉ nhận giờ bắt đầu thuộc danh sách slot cố định
            if (!isValidSlot(start, durationMinutes)) {
                fail(req, resp, "Khung giờ không hợp lệ. Vui lòng chọn một ca cố định.");
                return;
            }

            // Không vượt quá 22:00 (đã đảm bảo bởi slot, check thêm cho chắc)
            if (end.isAfter(LocalTime.of(22, 0))) {
                fail(req, resp, "⛔ Ca vượt quá giờ đóng cửa (22:00).");
                return;
            }

            // Lấy customer_id theo user_id
            String customerId = customerDAO.getCustomerIdByUserId(user.getId());
            if (customerId == null) {
                fail(req, resp, "Không tìm thấy thông tin khách hàng.");
                return;
            }
            Timestamp startTs = Timestamp.valueOf(date + " " + start + ":00");
            Timestamp endTs   = Timestamp.valueOf(date + " " + end + ":00");
            // Chống trùng lịch theo DAO hiện tại (theo khách)
            if (reservationDAO.overlapsForCustomer(customerId, startTs, endTs)) {
                fail(req, resp, "⚠️ Bạn đã có một đặt bàn trùng thời gian trong ngày này. Vui lòng chọn ca khác.");
                return;
            }

            // Gộp phần đặt món trước vào note (giới hạn 200 ký tự để khớp UI)
            String mergedNote = buildNote(orderType, note, req.getParameterValues("menuItem"), req);
            if (mergedNote.length() > 200) mergedNote = mergedNote.substring(0, 200);

            // Lưu đặt bàn
            Timestamp reservedAt = Timestamp.valueOf(LocalDateTime.of(bookingDate, start));
            Reservation r = new Reservation();
            r.setCustomerId(customerId);
            r.setReservedAt(reservedAt);
            r.setReservedDuration(durationMinutes);
            r.setGuestCount(guest);
            r.setStatus("PENDING");
            r.setNote(mergedNote);

            boolean success = reservationDAO.addReservation(r);
            req.setAttribute(success ? "success" : "error",
                    success ? "🎉 Đặt bàn thành công! Chúng tôi sẽ liên hệ xác nhận sớm."
                            : "❌ Không thể đặt bàn, vui lòng thử lại!");
            reloadForm(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            fail(req, resp, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    // ===== Helpers =====
    private void reloadForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<MenuItem> menuList = menuDAO.getAllMenuItems();
        req.setAttribute("menuList", menuList);
        req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        reloadForm(req, resp);
    }

    private static String trim(String s) {
        return s == null ? null : s.trim();
    }

    /**
     * Gộp ghi chú & danh sách món đặt trước thành note hiển thị/duyệt.
     * - orderType: "Đặt món trước" / "Gọi món tại nơi" (có thể null/empty)
     * - noteText: ghi chú người dùng nhập (có thể null)
     * - menuItems: id các món đã tick (có thể null)
     * - req: để lấy số lượng theo key "qty_{id}"
     */
    private static String buildNote(String orderType, String noteText, String[] menuItems, HttpServletRequest req) {
        StringBuilder sb = new StringBuilder();

        // prefix order type
        if (orderType != null && !orderType.isEmpty()) {
            sb.append(orderType).append(" - ");
        }

        // user note
        if (noteText != null && !noteText.trim().isEmpty()) {
            sb.append(noteText.trim());
        }

        // menu list
        if (menuItems != null && menuItems.length > 0) {
            if (sb.length() > 0) sb.append(" | ");
            sb.append("Đặt trước: ");
            for (String menuId : menuItems) {
                String qty = trim(req.getParameter("qty_" + menuId));
                if (qty == null || qty.isEmpty()) qty = "1";
                sb.append("#").append(menuId).append("x").append(qty).append(" ");
            }
        }

        return sb.toString().trim();
    }
}
