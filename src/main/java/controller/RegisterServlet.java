package controller;

import dto.RegistrationDTO;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.RegistrationService;
import dao.UserDao;

import java.io.IOException;

@WebServlet(urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        RegistrationDTO dto = RegistrationDTO.from(req);
        RegistrationService service = new RegistrationService(new UserDao());

        try {
            service.register(dto);
            req.getSession().setAttribute("flash_success", "Account created successfully.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (ValidationException ve) {
            req.setAttribute("error", ve.getMessage());
            dto.backfill(req);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi hệ thống, vui lòng thử lại.");
            dto.backfill(req);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
