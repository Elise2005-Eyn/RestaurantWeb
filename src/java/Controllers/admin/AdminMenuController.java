package Controllers.admin;

import DAO.MenuDAO;
import Models.MenuItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;


@WebServlet(name = "AdminMenuController", urlPatterns = {"/admin/menu"})
public class AdminMenuController extends HttpServlet {

    private final MenuDAO dao = new MenuDAO();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
            !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "list": {
                int page = 1;
                try {
                    if (req.getParameter("page") != null) {
                        page = Integer.parseInt(req.getParameter("page"));
                        if (page < 1) page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }

                List<MenuItem> menuList = dao.getMenuItemsByPage(page, PAGE_SIZE);
                int totalItems = dao.getTotalActiveMenuItems();
                int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

                req.setAttribute("menuList", menuList);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("/Views/admin/menu-list.jsp").forward(req, resp);
                break;
            }

            case "add": {
                req.getRequestDispatcher("/Views/admin/menu-add.jsp").forward(req, resp);
                break;
            }

            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    MenuItem item = dao.getMenuItemById(id);
                    req.setAttribute("item", item);
                    req.getRequestDispatcher("/Views/admin/menu-edit.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                }
                break;
            }

            case "delete": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.deleteMenuItem(id);
                } catch (Exception e) {
                    System.out.println("[AdminMenuController] Lỗi khi xóa: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "add": {
                MenuItem item = new MenuItem();
                item.setName(req.getParameter("name"));
                item.setDescription(req.getParameter("description"));
                item.setPrice(new BigDecimal(req.getParameter("price")));
                item.setDiscountPercent(new BigDecimal(req.getParameter("discount_percent")));
                item.setCategoryId(Integer.parseInt(req.getParameter("category_id")));
                item.setInventory(Integer.parseInt(req.getParameter("inventory")));
                item.setImage(req.getParameter("image"));
                item.setActive(true);
                item.setCode(req.getParameter("code"));
                dao.addMenuItem(item);
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    MenuItem item = dao.getMenuItemById(id);
                    if (item != null) {
                        item.setName(req.getParameter("name"));
                        item.setDescription(req.getParameter("description"));
                        item.setPrice(new BigDecimal(req.getParameter("price")));
                        item.setDiscountPercent(new BigDecimal(req.getParameter("discount_percent")));
                        item.setCategoryId(Integer.parseInt(req.getParameter("category_id")));
                        item.setInventory(Integer.parseInt(req.getParameter("inventory")));
                        item.setImage(req.getParameter("image"));
                        item.setActive(Boolean.parseBoolean(req.getParameter("is_active")));
                        item.setCode(req.getParameter("code"));
                        dao.updateMenuItem(item);
                    }
                } catch (Exception e) {
                    System.out.println("[AdminMenuController] Lỗi khi cập nhật: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
        }
    }
}
