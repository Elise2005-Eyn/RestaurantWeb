package Controllers.admin;

import DAO.MenuDAO;
import DAO.MenuCategoryDAO;
import Models.MenuItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminMenuController", urlPatterns = {"/admin/menu"})
public class AdminMenuController extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private final MenuCategoryDAO categoryDAO = new MenuCategoryDAO();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null
                || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {

            // ================== DANH SÁCH ==================
            case "list": {
                int page = 1;
                try {
                    if (req.getParameter("page") != null) {
                        page = Integer.parseInt(req.getParameter("page"));
                        if (page < 1) {
                            page = 1;
                        }
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }

                List<MenuItem> menuList = menuDAO.getMenuItemsByPage(page, PAGE_SIZE);
                int totalItems = menuDAO.getTotalActiveMenuItems();
                int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

                // ✅ Lấy Map<categoryId, categoryName> từ MenuCategoryDAO
                Map<Integer, String> categoryMap = categoryDAO.getCategoryMap();

                req.setAttribute("menuList", menuList);
                req.setAttribute("categoryMap", categoryMap);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);

                req.getRequestDispatcher("/Views/admin/menu-list.jsp").forward(req, resp);
                break;
            }

            // ================== TÌM KIẾM ==================
            case "search": {
                String keyword = req.getParameter("keyword");
                String min = req.getParameter("minPrice");
                String max = req.getParameter("maxPrice");
                String category = req.getParameter("categoryId");

                BigDecimal minPrice = (min != null && !min.isEmpty()) ? new BigDecimal(min) : null;
                BigDecimal maxPrice = (max != null && !max.isEmpty()) ? new BigDecimal(max) : null;
                Integer categoryId = (category != null && !category.isEmpty()) ? Integer.parseInt(category) : null;

                List<MenuItem> menuList = menuDAO.searchMenuItems(keyword, minPrice, maxPrice, categoryId);
                Map<Integer, String> categoryMap = categoryDAO.getCategoryMap();

                req.setAttribute("menuList", menuList);
                req.setAttribute("categoryMap", categoryMap);
                req.setAttribute("keyword", keyword);
                req.setAttribute("minPrice", min);
                req.setAttribute("maxPrice", max);
                req.setAttribute("selectedCategory", categoryId);

                req.getRequestDispatcher("/Views/admin/menu-list.jsp").forward(req, resp);
                break;
            }

            // ================== THÊM MÓN ==================
            case "add": {
                Map<Integer, String> categoryMap = categoryDAO.getCategoryMap();
                req.setAttribute("categoryMap", categoryMap);
                req.getRequestDispatcher("/Views/admin/menu-add.jsp").forward(req, resp);
                break;
            }

            // ================== CHỈNH SỬA MÓN ==================
            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    MenuItem item = menuDAO.getMenuItemById(id);
                    if (item != null) {
                        // ✅ Truyền categoryMap để dropdown danh mục hiển thị đúng
                        Map<Integer, String> categoryMap = categoryDAO.getCategoryMap();
                        req.setAttribute("categoryMap", categoryMap);
                        req.setAttribute("item", item);

                        req.getRequestDispatcher("/Views/admin/menu-edit.jsp").forward(req, resp);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                    }
                } catch (Exception e) {
                    System.out.println("[AdminMenuController] Lỗi khi mở form edit: " + e.getMessage());
                    resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                }
                break;
            }

            // ================== XÓA MÓN ==================
            case "delete": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    menuDAO.deleteMenuItem(id);
                } catch (Exception e) {
                    System.out.println("[AdminMenuController] Lỗi khi xóa: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            // ================== MẶC ĐỊNH ==================
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {

            // ================== THÊM MÓN ==================
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

                menuDAO.addMenuItem(item);
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            // ================== CẬP NHẬT MÓN ==================
            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    MenuItem item = menuDAO.getMenuItemById(id);
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
                        menuDAO.updateMenuItem(item);
                    }
                } catch (Exception e) {
                    System.out.println("[AdminMenuController] Lỗi khi cập nhật: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            // ================== MẶC ĐỊNH ==================
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
        }
    }
}
