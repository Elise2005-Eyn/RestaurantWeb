package Controllers.customer;

import DAO.OrderDAO;
import Models.Order;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/customer/my-orders")
public class MyOrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // ✅ 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        // ✅ 2. Lấy thông tin user từ session
        User user = (User) session.getAttribute("user");

        // ✅ 3. Tìm customer_id tương ứng với user_id
        UUID customerId = orderDAO.getCustomerIdByUserId(user.getId());
        if (customerId == null) {
            System.out.println("[MyOrdersServlet] ❌ Không tìm thấy customer_id cho user_id = " + user.getId());
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        // ✅ 4. Lấy danh sách đơn hàng của khách
        List<Order> orders = orderDAO.getOrdersByCustomerUUID(customerId);

        // ✅ 5. Truyền dữ liệu ra view
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/Views/customer/my-orders.jsp").forward(request, response);
    }
}
