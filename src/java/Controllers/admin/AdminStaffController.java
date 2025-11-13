package Controllers.admin;

import DAO.StaffDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/staff")
public class AdminStaffController extends HttpServlet {

    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                req.getRequestDispatcher("/Views/admin/staff-add.jsp").forward(req, resp);
                break;

            case "edit":
                showEditForm(req, resp);
                break;

            case "ban":
                banStaff(req, resp);
                break;

            case "delete":
                deleteStaff(req, resp);
                break;

            default:
                listStaff(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("saveAdd".equals(action)) {
            addStaff(req, resp);
        } else if ("saveEdit".equals(action)) {
            updateStaff(req, resp);
        } else {
            listStaff(req, resp);
        }
    }

    // =============================
    // LIST
    // =============================
    private void listStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1, pageSize = 8;
        String pageParam = req.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+"))
            page = Integer.parseInt(pageParam);

        List<User> staffs = staffDAO.getStaffByPage(page, pageSize);
        int totalStaff = staffDAO.getTotalStaffCount();
        int totalPages = (int) Math.ceil((double) totalStaff / pageSize);

        req.setAttribute("staffs", staffs);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/Views/admin/staff-list.jsp").forward(req, resp);
    }

    // =============================
    // ADD STAFF
    // =============================
    private void addStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User staff = new User();
        staff.setUsername(req.getParameter("username"));
        staff.setEmail(req.getParameter("email"));
        staff.setTelephone(req.getParameter("phone"));
        staff.setPassword("123456");
        staff.setActived(true);
        staff.setPhotoUrl("uploads/default-avatar.png");

        boolean success = staffDAO.addStaff(staff);

        if (success) resp.sendRedirect(req.getContextPath() + "/admin/staff");
        else {
            req.setAttribute("error", "⚠️ Email đã tồn tại hoặc lỗi khi thêm!");
            req.getRequestDispatcher("/Views/admin/staff-add.jsp").forward(req, resp);
        }
    }

    // =============================
    // EDIT STAFF
    // =============================
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            User staff = staffDAO.getStaffById(id);
            if (staff == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/staff");
                return;
            }
            req.setAttribute("staff", staff);
            req.getRequestDispatcher("/Views/admin/staff-edit.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/staff");
        }
    }

    private void updateStaff(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(req.getParameter("id"));

        User staff = new User();
        staff.setId(id);
        staff.setUsername(req.getParameter("username"));
        staff.setEmail(req.getParameter("email"));
        staff.setTelephone(req.getParameter("phone"));
        staff.setActived(req.getParameter("active") != null);

        boolean success = staffDAO.updateStaff(staff);

        if (success) resp.sendRedirect(req.getContextPath() + "/admin/staff");
        else {
            req.setAttribute("error", "❌ Cập nhật thất bại!");
            req.setAttribute("staff", staff);
            req.getRequestDispatcher("/Views/admin/staff-edit.jsp").forward(req, resp);
        }
    }

    // =============================
    // BAN STAFF
    // =============================
    private void banStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            staffDAO.banStaff(id);
        } catch (Exception e) {
            System.out.println("[AdminStaffController] Lỗi banStaff: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/staff");
    }

    // =============================
    // DELETE STAFF
    // =============================
    private void deleteStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            staffDAO.deleteStaff(id);
        } catch (Exception e) {
            System.out.println("[AdminStaffController] Lỗi deleteStaff: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/staff");
    }
}
