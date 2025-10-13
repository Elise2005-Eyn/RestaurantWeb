package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            // Dùng bản plain để test nhanh
            var user = userDao.authenticatePlain(username, password);
            if (user == null) {
                req.setAttribute("error", "Invalid username or password.");
                req.setAttribute("v_username", username);
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            HttpSession s = req.getSession(true);
            s.setAttribute("userId", user.getId());
            s.setAttribute("username", user.getUsername());
            s.setAttribute("role", user.getRole()); // "admin"/"customer"

            resp.sendRedirect(req.getContextPath() + "/admin/dishes");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
