package Controllers.admin;

import DAO.AccountDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/accounts")
public class AdminAccountController extends HttpServlet {

    private final AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                req.getRequestDispatcher("/Views/admin/account-add.jsp").forward(req, resp);
                break;

            case "edit":
                try {
                int id = Integer.parseInt(req.getParameter("id"));
                User acc = dao.getAccountById(id);
                req.setAttribute("account", acc);
                req.getRequestDispatcher("/Views/admin/account-edit.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            }
            break;

            case "ban":
                try {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.banAccount(id);
            } catch (Exception e) {
                System.out.println("[AdminAccountController] Lỗi ban account: " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            break;

            case "delete":
                try {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deleteAccount(id);
            } catch (Exception e) {
                System.out.println("[AdminAccountController] Lỗi delete account: " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            break;

            default:
                handleList(req, resp);
                break;
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1, pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+")) {
            page = Integer.parseInt(pageParam);
        }

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String roleFilter = req.getParameter("roleFilter");
        String statusFilter = req.getParameter("statusFilter");

        List<User> list = dao.searchAccounts(username, email, roleFilter, statusFilter, page, pageSize);
        int total = dao.countFilteredAccounts(username, email, roleFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        req.setAttribute("accounts", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("roleFilter", roleFilter);
        req.setAttribute("statusFilter", statusFilter);

        req.getRequestDispatcher("/Views/admin/account-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        switch (action) {
            case "saveAdd":
                User add = new User();
                add.setUsername(req.getParameter("username"));
                add.setEmail(req.getParameter("email"));
                add.setPassword(req.getParameter("password"));
                add.setTelephone(req.getParameter("phone"));
                add.setRoleId(Integer.parseInt(req.getParameter("role")));
                add.setActived(true);
                add.setPhotoUrl("uploads/default-avatar.png");

                if (dao.addAccount(add)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/accounts");
                } else {
                    req.setAttribute("error", "⚠️ Email đã tồn tại hoặc lỗi khi thêm!");
                    req.getRequestDispatcher("/Views/admin/account-add.jsp").forward(req, resp);
                }
                break;

            case "saveEdit":
                User edit = new User();
                edit.setId(Integer.parseInt(req.getParameter("id")));
                edit.setUsername(req.getParameter("username"));
                edit.setEmail(req.getParameter("email"));
                edit.setTelephone(req.getParameter("phone"));
                edit.setRoleId(Integer.parseInt(req.getParameter("role")));
                edit.setActived(req.getParameter("active") != null);

                if (dao.updateAccount(edit)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/accounts");
                } else {
                    req.setAttribute("error", "❌ Cập nhật thất bại!");
                    req.setAttribute("account", edit);
                    req.getRequestDispatcher("/Views/admin/account-edit.jsp").forward(req, resp);
                }
                break;
        }
    }
}
