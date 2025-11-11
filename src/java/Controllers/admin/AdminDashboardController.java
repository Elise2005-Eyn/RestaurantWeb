package Controllers.admin;

import DAO.MenuDAO;
import DAO.OrderDAO;
import DAO.CustomerDAO;
import DAO.ReservationDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

<<<<<<< HEAD
        // 🔒 Kiểm tra đăng nhập và quyền admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            // ❗ Nếu chưa đăng nhập hoặc không phải admin → chuyển hướng về trang login
=======
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
>>>>>>> LeThuUyen-Staff
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "overview";

        switch (action) {
            case "overview":
            default:
                loadDashboardData(req, resp);
                break;
        }
    }

    private void loadDashboardData(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
<<<<<<< HEAD
            // 📦 Khởi tạo DAO
=======
>>>>>>> LeThuUyen-Staff
            MenuDAO menuDAO = new MenuDAO();
            OrderDAO orderDAO = new OrderDAO();
            CustomerDAO customerDAO = new CustomerDAO();
            ReservationDAO reservationDAO = new ReservationDAO();

<<<<<<< HEAD
            // 🧮 Lấy dữ liệu tổng hợp
=======
>>>>>>> LeThuUyen-Staff
            int totalMenuItems = menuDAO.getTotalActiveMenuItems();
            int totalOrders = orderDAO.getTotalOrders();
            int totalCustomers = customerDAO.getTotalCustomers();
            int totalReservations = reservationDAO.getTotalReservations();

<<<<<<< HEAD
            // 💰 Lấy doanh thu theo tháng
=======
>>>>>>> LeThuUyen-Staff
            Map<String, Double> revenueByMonth = orderDAO.getMonthlyRevenue();

            List<String> labels = new ArrayList<>(revenueByMonth.keySet());
            List<Double> values = new ArrayList<>(revenueByMonth.values());

            if (labels.isEmpty()) {
                labels = Arrays.asList("Không có dữ liệu");
                values = Arrays.asList(0.0);
            }

<<<<<<< HEAD
            // 🧩 Lấy dữ liệu trạng thái (cho biểu đồ tròn)
=======
>>>>>>> LeThuUyen-Staff
            Map<String, Integer> menuStatus = safeMap(menuDAO.getMenuStatusCount());
            Map<String, Integer> orderStatus = safeMap(orderDAO.getOrderStatusCount());
            Map<String, Integer> customerStatus = safeMap(customerDAO.getCustomerStatusCount());
            Map<String, Integer> reservationStatus = safeMap(reservationDAO.getReservationStatusCount());

<<<<<<< HEAD
            // 🧾 Convert sang JSON để vẽ biểu đồ
=======
>>>>>>> LeThuUyen-Staff
            req.setAttribute("revenueLabelsJSON", listToJson(labels));
            req.setAttribute("revenueValuesJSON", listToJson(values));

            req.setAttribute("menuStatusLabels", listToJson(new ArrayList<>(menuStatus.keySet())));
            req.setAttribute("menuStatusValues", listToJson(new ArrayList<>(menuStatus.values())));

            req.setAttribute("orderStatusLabels", listToJson(new ArrayList<>(orderStatus.keySet())));
            req.setAttribute("orderStatusValues", listToJson(new ArrayList<>(orderStatus.values())));

            req.setAttribute("customerStatusLabels", listToJson(new ArrayList<>(customerStatus.keySet())));
            req.setAttribute("customerStatusValues", listToJson(new ArrayList<>(customerStatus.values())));

            req.setAttribute("reservationStatusLabels", listToJson(new ArrayList<>(reservationStatus.keySet())));
            req.setAttribute("reservationStatusValues", listToJson(new ArrayList<>(reservationStatus.values())));

<<<<<<< HEAD
            // 📤 Gửi dữ liệu tổng số sang JSP
=======
>>>>>>> LeThuUyen-Staff
            req.setAttribute("totalMenuItems", totalMenuItems);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("totalCustomers", totalCustomers);
            req.setAttribute("totalReservations", totalReservations);

<<<<<<< HEAD
            // 🔽 Chuyển sang trang dashboard.jsp
=======
>>>>>>> LeThuUyen-Staff
            req.getRequestDispatcher("/Views/admin/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            System.out.println("[AdminDashboardController] ❌ Lỗi khi load dashboard: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/Views/error.jsp");
        }
    }

    /**
     * 🔧 Chuyển List<String> hoặc List<Double> sang chuỗi JSON đơn giản
     */
    private String listToJson(List<?> list) {
        if (list == null || list.isEmpty()) return "[]";
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Object val = list.get(i);
            if (val instanceof String) {
                sb.append("\"").append(val.toString().replace("\"", "\\\"")).append("\"");
            } else {
                sb.append(val);
            }
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * ✅ Đảm bảo Map không null, tránh lỗi NullPointer khi DAO chưa có dữ liệu
     */
    private Map<String, Integer> safeMap(Map<String, Integer> map) {
        return (map != null) ? map : new LinkedHashMap<>();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
