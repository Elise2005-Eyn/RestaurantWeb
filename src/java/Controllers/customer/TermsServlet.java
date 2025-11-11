package Controller.Customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TermsServlet", urlPatterns = {"/terms"})
public class TermsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang Điều lệ trước khi đặt bàn
        request.getRequestDispatcher("/Views/customer/terms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý khi khách tick đồng ý Điều lệ
        String agree = request.getParameter("agree");
        if ("on".equals(agree)) {
            // Chuyển sang trang đặt bàn
            response.sendRedirect(request.getContextPath() + "/reservationForm"); // đường dẫn form đặt bàn hiện tại
        } else {
            // Nếu chưa tick, vẫn ở lại trang terms với thông báo
            request.setAttribute("msg", "❌ Bạn cần đồng ý Điều lệ trước khi đặt bàn!");
            request.getRequestDispatcher("/Views/customer/terms.jsp").forward(request, response);
        }
    }
}
