package Controllers;

import DAO.MenuDAO;
import DAO.ReservationDAO;
import DAO.CustomerDAO;
import DAO.ReservationSessionDAO;
import Models.MenuItem;
import Models.Reservation;
import Models.ReservationSession;
import Models.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@WebServlet("/book-table")
public class BookTableController extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationSessionDAO sessionDAO = new ReservationSessionDAO();     // NEW
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
        // đổ sessions cho dropdown (FK bắt buộc)
        List<ReservationSession> sessions = sessionDAO.findActive();
        List<MenuItem> menuList = menuDAO.getAllMenuItems();
        req.setAttribute("sessions", sessions);
        req.setAttribute("menuList", menuList);
        req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession sessionHttp = req.getSession(false);
        User user = (sessionHttp != null) ? (User) sessionHttp.getAttribute("user") : null;
        if (user == null) {
            req.setAttribute("error", "Vui lòng đăng nhập trước khi đặt bàn.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        String dateStr     = req.getParameter("date");          // yyyy-MM-dd
        String sessionCode = req.getParameter("sessionCode");   // MORNING/LUNCH/...
        String guestStr    = req.getParameter("guestCount");
        String note        = req.getParameter("note");
        String orderType   = req.getParameter("orderType");

        try {
            if (isBlank(dateStr) || isBlank(sessionCode) || isBlank(guestStr)) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ Ngày, Ca và Số khách.");
                returnToForm(req, resp);
                return;
            }

            LocalDate today = LocalDate.now();
            LocalDate reservedLocalDate = LocalDate.parse(dateStr);
            if (reservedLocalDate.isBefore(today)) {
                req.setAttribute("error", "Ngày đặt không được ở quá khứ.");
                returnToForm(req, resp);
                return;
            }
            if (reservedLocalDate.isAfter(today.plusDays(30))) {
                req.setAttribute("error", "Bạn chỉ có thể đặt trước tối đa 30 ngày.");
                returnToForm(req, resp);
                return;
            }

            int guestCount;
            try { guestCount = Integer.parseInt(guestStr); }
            catch (NumberFormatException e) {
                req.setAttribute("error", "Số khách không hợp lệ.");
                returnToForm(req, resp);
                return;
            }
            if (guestCount < 1 || guestCount > 10) {
                req.setAttribute("error", "Số khách phải từ 1 đến 10.");
                returnToForm(req, resp);
                return;
            }

            // Kiểm tra sessionCode có tồn tại & active (để qua FK)
            ReservationSession ses = sessionDAO.findByCode(sessionCode);
            if (ses == null || !ses.isActive()) {
                req.setAttribute("error", "Ca đặt không hợp lệ hoặc tạm ngưng.");
                returnToForm(req, resp);
                return;
            }

            // Lấy customer_id theo user
            String customerIdStr = customerDAO.getCustomerIdByUserId(user.getId());
            if (isBlank(customerIdStr)) {
                req.setAttribute("error", "Không tìm thấy thông tin khách hàng.");
                returnToForm(req, resp);
                return;
            }
            UUID customerId = UUID.fromString(customerIdStr);

            // Chống đặt trùng
            boolean exists = reservationDAO.existsCustomerBookingSameSession(
                    customerId, Date.valueOf(reservedLocalDate), sessionCode);
            if (exists) {
                req.setAttribute("error", "Bạn đã có một đặt bàn khác trong cùng ca của ngày này.");
                returnToForm(req, resp);
                return;
            }

            // Gộp note đặt món trước (nếu có)
            String[] selectedMenuItems = req.getParameterValues("menuItem");
            if (selectedMenuItems != null && selectedMenuItems.length > 0) {
                StringBuilder orderedMenu = new StringBuilder("Đặt trước: ");
                for (String menuId : selectedMenuItems) {
                    String qty = req.getParameter("qty_" + menuId);
                    if (isBlank(qty)) qty = "1";
                    orderedMenu.append("[Món #").append(menuId).append(": SL ").append(qty).append("] ");
                }
                note = (isBlank(note) ? "" : note + " | ") + orderedMenu.toString().trim();
            }
            if (!isBlank(orderType)) note = (orderType + " - " + (note == null ? "" : note)).trim();

            // Tạo reservation (không có reserved_at)
            Reservation r = new Reservation();
            r.setCustomerId(customerId);
            r.setReservedDate(Date.valueOf(reservedLocalDate));
            r.setSessionCode(sessionCode);
            r.setGuestCount(guestCount);
            r.setStatus("PENDING");
            r.setNote(note);

            boolean success = reservationDAO.addReservationSessionBased(r);
            req.setAttribute(success ? "success" : "error",
                    success ? "🎉 Đặt bàn thành công! Chúng tôi sẽ liên hệ xác nhận sớm."
                            : "❌ Không thể đặt bàn, vui lòng thử lại!");
            returnToForm(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            returnToForm(req, resp);
        }
    }

    private void returnToForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<ReservationSession> sessions = sessionDAO.findActive();
        List<MenuItem> menuList = menuDAO.getAllMenuItems();
        req.setAttribute("sessions", sessions);
        req.setAttribute("menuList", menuList);
        req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
    }

    private boolean isBlank(String s){ return s == null || s.trim().isEmpty(); }
}
