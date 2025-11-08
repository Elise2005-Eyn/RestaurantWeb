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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/book-table")
public class BookTableController extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final MenuDAO menuDAO = new MenuDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

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

        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String duration = req.getParameter("duration");
        String guestCount = req.getParameter("guestCount");
        String note = req.getParameter("note");
        String orderType = req.getParameter("orderType");

        try {
            // 🔹 Kiểm tra dữ liệu nhập hợp lệ
            if (date == null || time == null || duration == null || guestCount == null) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đặt bàn.");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Kiểm tra không được đặt bàn trong quá khứ
            LocalDate bookingDate = LocalDate.parse(date);
            LocalDate today = LocalDate.now();
            if (bookingDate.isBefore(today)) {
                req.setAttribute("error", "⛔ Không thể đặt bàn vào ngày trong quá khứ. Vui lòng chọn ngày từ hôm nay trở đi.");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Giờ mở cửa - đóng cửa
            LocalTime bookingTime = LocalTime.parse(time);
            LocalTime openTime = LocalTime.of(8, 0);
            LocalTime closeTime = LocalTime.of(22, 0);
            int durationMinutes = Integer.parseInt(duration);

            // 🔹 Kiểm tra giờ hợp lệ
            if (bookingTime.isBefore(openTime) || bookingTime.isAfter(closeTime)) {
                req.setAttribute("error", "⏰ Giờ đặt bàn phải nằm trong khung hoạt động (08:00 - 22:00).");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Tính thời điểm kết thúc
            LocalTime endTime = bookingTime.plusMinutes(durationMinutes);
            if (endTime.isAfter(closeTime)) {
                req.setAttribute("error", "⛔ Không cho phép đặt bàn nếu thời điểm kết thúc vượt quá giờ đóng cửa (22:00).");
                reloadForm(req, resp);
                return;
            }

            if (durationMinutes <= 0) {
                req.setAttribute("error", "⚠️ Thời lượng đặt bàn phải lớn hơn 0 phút.");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Lấy customer_id theo user_id
            String customerId = customerDAO.getCustomerIdByUserId(user.getId());
            if (customerId == null) {
                req.setAttribute("error", "Không tìm thấy thông tin khách hàng.");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Kiểm tra trùng thời gian đặt bàn
            if (reservationDAO.hasDuplicateBooking(customerId, date, bookingTime, endTime)) {
                req.setAttribute("error", "⚠️ Bạn đã có một đặt bàn trùng thời gian trong ngày này. Vui lòng chọn khung giờ khác.");
                reloadForm(req, resp);
                return;
            }

            // 🔹 Nếu đặt món trước
            String[] selectedMenuItems = req.getParameterValues("menuItem");
            if (selectedMenuItems != null && selectedMenuItems.length > 0) {
                StringBuilder orderedMenu = new StringBuilder("Đặt trước các món: ");
                for (String menuId : selectedMenuItems) {
                    String qty = req.getParameter("qty_" + menuId);
                    orderedMenu.append("[Món #").append(menuId)
                            .append(": SL ").append(qty).append("] ");
                }
                note = (note == null ? "" : note) + " | " + orderedMenu;
            }

            // 🔹 Lưu đặt bàn
            Reservation r = new Reservation();
            r.setCustomerId(customerId);
            r.setReservedAt(Timestamp.valueOf(date + " " + time + ":00"));
            r.setReservedDuration(durationMinutes);
            r.setGuestCount(Integer.parseInt(guestCount));
            r.setStatus("PENDING");
            r.setNote(orderType + " - " + note);

            boolean success = reservationDAO.addReservation(r);

            req.setAttribute(success ? "success" : "error",
                    success ? "🎉 Đặt bàn thành công! Chúng tôi sẽ liên hệ xác nhận sớm."
                            : "❌ Không thể đặt bàn, vui lòng thử lại!");

            reloadForm(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            reloadForm(req, resp);
        }
    }

    private void reloadForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<MenuItem> menuList = menuDAO.getAllMenuItems();
        req.setAttribute("menuList", menuList);
        req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
    }
}
