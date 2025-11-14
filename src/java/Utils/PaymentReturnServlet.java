package Utils;

import DAO.OrderDAO;
import Models.CartItem;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/payment-return")
public class PaymentReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        Map<String, String> fields = new HashMap<>();
        for (String key : request.getParameterMap().keySet()) {
            String value = request.getParameter(key);
            if (value != null && !value.isEmpty()) {
                fields.put(key, value);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // ✅ Tạo chữ ký để kiểm tra tính toàn vẹn
        String signValue = VNPayConfig.hmacSHA512(
                VNPayConfig.vnp_HashSecret,
                VNPayConfig.hashAllFields(fields)
        );

        // ✅ Nếu hash hợp lệ
        if (signValue.equals(vnp_SecureHash)) {
            String txnStatus = request.getParameter("vnp_TransactionStatus");
            String txnRef = request.getParameter("vnp_TxnRef");

            if ("00".equals(txnStatus)) {
                HttpSession session = request.getSession();
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

                if (cart != null && !cart.isEmpty()) {
                    try {
                        User user = (User) session.getAttribute("user");
                        int userId = (user != null) ? user.getId() : 0; // Nếu chưa đăng nhập
                        new OrderDAO().saveOrder(cart, txnRef, userId);
                        session.removeAttribute("cart");
                        System.out.println("✅ Đơn hàng đã được lưu thành công, mã giao dịch: " + txnRef);
                    } catch (Exception e) {
                        System.err.println("❌ Lỗi khi lưu đơn hàng: " + e.getMessage());
                    }
                }

                request.setAttribute("vnp_Params", fields);
request.getRequestDispatcher("/Views/payment_success.jsp").forward(request, response);

            } else {
                request.setAttribute("vnp_Params", fields);
request.getRequestDispatcher("/Views/payment_failure.jsp").forward(request, response);

            }
        } else {
            // ❌ Sai chữ ký
            response.getWriter().println("<html><body><h3 style='color:red;'>❌ Lỗi: Chữ ký không hợp lệ!</h3></body></html>");
        }
    }
}
