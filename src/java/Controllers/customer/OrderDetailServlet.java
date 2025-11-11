package Controllers.customer;

import DAO.OrderDAO;
import Models.Order;
import Models.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/order-detail")
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String orderIdParam = request.getParameter("orderId");

        // ✅ Kiểm tra null hoặc rỗng
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.getWriter().println("<h3 style='color:red;'>❌ Thiếu mã đơn hàng (orderId)!</h3>");
            return;
        }

        try {
            long orderId = Long.parseLong(orderIdParam.trim());
            OrderDAO dao = new OrderDAO();

            Order order = dao.getOrderById2(orderId);
            List<OrderItem> items = dao.getOrderItemsByOrderId2(orderId);

            if (order == null) {
                response.getWriter().println("<h3 style='color:red;'>❌ Không tìm thấy đơn hàng #" + orderId + "</h3>");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("items", items);

            request.getRequestDispatcher("/Views/customer/order_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.getWriter().println("<h3 style='color:red;'>❌ orderId không hợp lệ: " + e.getMessage() + "</h3>");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color:red;'>❌ Lỗi khi tải chi tiết đơn hàng: "
                    + e.getMessage() + "</h3>");
        }
    }
}