package Controllers;

import DAO.UserDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "login";
        }

        switch (action) {
            case "register":
                req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
                break;

            case "logout":
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                resp.sendRedirect(req.getContextPath() + "/home");
                break;

            default:
                req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else if ("login".equals(action)) {
            handleLogin(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String agree = req.getParameter("agree");

        if (username == null || username.isBlank()
                || email == null || email.isBlank()
                || password == null || password.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()
                || phone == null || phone.isBlank()) {

            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!email.matches(".+@.+\\..+")) {
            req.setAttribute("error", "Email không hợp lệ!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.isEmailExists(email)) {
            req.setAttribute("error", "Email này đã được đăng ký, vui lòng dùng email khác!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!phone.matches("^(0[1-9][0-9]{8})$")) {
            req.setAttribute("error", "Số điện thoại không hợp lệ (phải là 10 số, bắt đầu bằng 0)!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (agree == null) {
            req.setAttribute("error", "Vui lòng đồng ý với điều khoản sử dụng!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setTelephone(phone);
        user.setRoleId(3); // 3 = customer
        user.setActived(true);
        user.setPhotoUrl("uploads/default-avatar.png"); 

        boolean success = userDAO.register(user);

        if (success) {
            req.setAttribute("success", "🎉 Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "❌ Đăng ký thất bại, vui lòng thử lại!");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userDAO.login(email, password);

        if (user != null) {
            User fullUser = userDAO.getUserById(user.getId());

            HttpSession session = req.getSession();
            session.setAttribute("user", fullUser);
            session.setAttribute("USER_ID", fullUser.getId());
            session.setAttribute("role", getRoleName(fullUser.getRoleId()));

            switch (fullUser.getRoleId()) {
                case 1: // Admin
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
                case 2: // Staff
                    resp.sendRedirect(req.getContextPath() + "/staff/dashboard");
                    break;
                case 3: // Customer
                    resp.sendRedirect(req.getContextPath() + "/home");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/home");
                    break;
            }

        } else {
            req.setAttribute("error", "Sai email hoặc mật khẩu!");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
        }
    }

    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1:
                return "admin";
            case 2:
                return "staff";
            case 3:
                return "customer";
            default:
                return "guest";
        }
    }
}
