package Controllers;

import DAO.UserDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/auth")
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ====== Regex dùng chung ======
    // Tên chỉ chữ (có dấu) + khoảng trắng, 2–50.
    private static final String NAME_REGEX = "^[A-Za-zÀ-Ỹà-ỹĐđ\\s]{2,50}$";
    // Email đơn giản
    private static final String EMAIL_REGEX = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
    // SĐT: 0 + 9 số
    private static final String PHONE_REGEX = "^0\\d{9}$";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "login";

        switch (action) {
            case "register":
                req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
                break;

            case "logout":
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
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

        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(req, resp);
        } else if ("login".equals(action)) {
            handleLogin(req, resp);
        }
    }

    // ====================== XỬ LÝ ĐĂNG KÝ ======================
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy & chuẩn hoá dữ liệu
        String username = trimOrEmpty(req.getParameter("username"));
        String email = trimOrEmpty(req.getParameter("email")).toLowerCase();
        String password = safe(req.getParameter("password"));
        String confirmPassword = safe(req.getParameter("confirmPassword"));
        String phone = trimOrEmpty(req.getParameter("phone"));
        String agree = req.getParameter("agree");

        // Giữ lại dữ liệu cho form
        keepFormData(req, username, email, phone);

        // ---- Validate bắt buộc ----
        if (username.isEmpty() || email.isEmpty() || password.isEmpty()
                || confirmPassword.isEmpty() || phone.isEmpty()) {
            fail(req, resp, "Vui lòng điền đầy đủ thông tin!");
            return;
        }

        // ---- Validate tên: chỉ chữ & khoảng trắng, không số/ký tự đặc biệt ----
        if (!username.matches(NAME_REGEX)) {
            fail(req, resp, "Họ và tên chỉ được chứa chữ cái (có dấu) và khoảng trắng, 2–50 ký tự; không chứa số hoặc ký tự đặc biệt.");
            return;
        }

        // ---- Validate email ----
        if (!email.matches(EMAIL_REGEX)) {
            fail(req, resp, "Email không hợp lệ!");
            return;
        }

        // ---- Validate tồn tại email ----
        if (userDAO.emailExists(email)) {
            fail(req, resp, "Email đã tồn tại, vui lòng thử email khác.");
            return;
        }

        // ---- Validate SĐT ----
        if (!phone.matches(PHONE_REGEX)) {
            fail(req, resp, "Số điện thoại không hợp lệ (phải gồm 10 số và bắt đầu bằng 0).");
            return;
        }

        // ---- Validate mật khẩu độ dài 6–20 ----
        if (password.length() < 6 || password.length() > 20) {
            fail(req, resp, "Mật khẩu phải từ 6 đến 20 ký tự.");
            return;
        }

        // ---- So khớp mật khẩu ----
        if (!password.equals(confirmPassword)) {
            fail(req, resp, "Mật khẩu nhập lại không khớp!");
            return;
        }

        // ---- Đồng ý điều khoản ----
        if (agree == null) {
            fail(req, resp, "Vui lòng đồng ý với điều khoản sử dụng!");
            return;
        }

        // ✅ Tạo user mới
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        // Lưu ý: Nên băm mật khẩu (BCrypt/Argon2). Ở đây giữ nguyên theo project gốc.
        user.setPassword(password);
        user.setTelephone(phone);
        user.setRoleId(3);            // 3 = customer
        user.setActived(true);
        user.setPhotoUrl("uploads/default-avatar.png");

        boolean success = userDAO.register(user);

        if (success) {
            req.setAttribute("success", "🎉 Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
        } else {
            fail(req, resp, "❌ Đăng ký thất bại, vui lòng thử lại!");
        }
    }

    // ====================== XỬ LÝ ĐĂNG NHẬP ======================
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = trimOrEmpty(req.getParameter("email")).toLowerCase();
        String password = safe(req.getParameter("password"));

        User user = userDAO.login(email, password);

        if (user != null) {
            User fullUser = userDAO.getUserById(user.getId());

            HttpSession session = req.getSession();
            session.setAttribute("user", fullUser);
            session.setAttribute("USER_ID", fullUser.getId());
            session.setAttribute("role", getRoleName(fullUser.getRoleId()));

            switch (fullUser.getRoleId()) {
                case 1: resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); break;
                case 2: resp.sendRedirect(req.getContextPath() + "/staff/dashboard"); break;
                case 3: resp.sendRedirect(req.getContextPath() + "/home"); break;
                default: resp.sendRedirect(req.getContextPath() + "/home"); break;
            }

        } else {
            req.setAttribute("error", "Sai email hoặc mật khẩu!");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
        }
    }

    // ====================== Helpers ======================
    private static String trimOrEmpty(String s) {
        return s == null ? "" : s.trim();
    }
    private static String safe(String s) {
        return s == null ? "" : s;
    }
    private static void keepFormData(HttpServletRequest req, String username, String email, String phone) {
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
    }
    private void fail(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
    }
    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1: return "admin";
            case 2: return "staff";
            case 3: return "customer";
            default: return "guest";
        }
    }
}
