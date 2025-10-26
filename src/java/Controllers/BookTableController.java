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
            // 🔹 Lấy customer_id theo user_id
            String customerId = customerDAO.getCustomerIdByUserId(user.getId());

            if (customerId == null) {
                req.setAttribute("error", "Không tìm thấy thông tin khách hàng.");
                req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
                return;
            }

            // 🔹 Nếu chọn đặt món trước thì lưu thêm thông tin món ăn
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

            // 🔹 Tạo đối tượng đặt bàn
            Reservation r = new Reservation();
            r.setCustomerId(customerId); // GUID lấy từ bảng Customer
            r.setReservedAt(Timestamp.valueOf(date + " " + time + ":00"));
            r.setReservedDuration(Integer.parseInt(duration));
            r.setGuestCount(Integer.parseInt(guestCount));
            r.setStatus("PENDING");
            r.setNote(orderType + " - " + note);

            boolean success = reservationDAO.addReservation(r);

            req.setAttribute(success ? "success" : "error",
                    success ? "🎉 Đặt bàn thành công! Chúng tôi sẽ liên hệ xác nhận sớm."
                            : "❌ Không thể đặt bàn, vui lòng thử lại!");

            List<MenuItem> menuList = menuDAO.getAllMenuItems();
            req.setAttribute("menuList", menuList);

            req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/Views/reservation/book-table.jsp").forward(req, resp);
        }
    }
}
