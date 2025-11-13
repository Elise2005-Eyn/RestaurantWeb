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

// ================== THÊM MÓN (Đã tối ưu) ==================
            case "add": {
                try {
                    MenuItem item = new MenuItem();
                    item.setName(req.getParameter("name"));
                    item.setDescription(req.getParameter("description"));

                    // Xử lý giá (Price) an toàn hơn
                    String priceStr = req.getParameter("price");
                    item.setPrice((priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : BigDecimal.ZERO);

                    // Xử lý giảm giá
                    String discountStr = req.getParameter("discount_percent");
                    item.setDiscountPercent((discountStr != null && !discountStr.isEmpty()) ? new BigDecimal(discountStr) : BigDecimal.ZERO);

                    item.setCategoryId(Integer.parseInt(req.getParameter("category_id")));

                    // Xử lý tồn kho (Inventory) - Fix lỗi NumberFormatException
                    String invStr = req.getParameter("inventory");
                    if (invStr != null && !invStr.trim().isEmpty()) {
                        item.setInventory(Integer.parseInt(invStr));
                    } else {
                        item.setInventory(null);
                    }

                    item.setImage(req.getParameter("image"));

                    // Xử lý trạng thái (Active) - Tôn trọng lựa chọn từ Form
                    String activeStr = req.getParameter("is_active");
                    item.setActive(activeStr == null || Boolean.parseBoolean(activeStr));

                    item.setCode(req.getParameter("code"));

                    menuDAO.addMenuItem(item);

                } catch (Exception e) {
                    System.out.println("Lỗi khi thêm món: " + e.getMessage());
                    e.printStackTrace();
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu?action=list");
                break;
            }

            // ================== CẬP NHẬT MÓN ==================
            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    MenuItem item = menuDAO.getMenuItemById(id);

                    if (item != null) {
                        // 1. Lấy tên và mô tả
                        item.setName(req.getParameter("name"));
                        item.setDescription(req.getParameter("description"));

                        // 2. Xử lý Giá (Price) an toàn
                        String priceStr = req.getParameter("price");
                        if (priceStr != null && !priceStr.isEmpty()) {
                            item.setPrice(new java.math.BigDecimal(priceStr));
                        }

                        // 3. Xử lý Giảm giá (Discount) an toàn
                        String discountStr = req.getParameter("discount_percent");
                        if (discountStr != null && !discountStr.isEmpty()) {
                            item.setDiscountPercent(new java.math.BigDecimal(discountStr));
                        } else {
                            item.setDiscountPercent(java.math.BigDecimal.ZERO);
                        }

                        // 4. Xử lý Danh mục
                        item.setCategoryId(Integer.parseInt(req.getParameter("category_id")));

                        // 5. XỬ LÝ QUAN TRỌNG: Tồn kho (Inventory)
                        // Kiểm tra null trước khi parse để tránh lỗi
                        String invStr = req.getParameter("inventory");
                        if (invStr != null && !invStr.trim().isEmpty()) {
                            item.setInventory(Integer.parseInt(invStr));
                        } else {
                            // Nếu form không gửi inventory lên, giữ nguyên giá trị cũ hoặc set null tùy logic
                            // Ở đây ta giữ nguyên logic cũ nếu không muốn thay đổi
                            // item.setInventory(null); 
                        }

                        // 6. Ảnh và Mã
                        item.setImage(req.getParameter("image"));
                        item.setCode(req.getParameter("code"));

                        // 7. Trạng thái Active
                        String activeStr = req.getParameter("is_active");
                        if (activeStr != null) {
                            item.setActive(Boolean.parseBoolean(activeStr));
                        }

                        // 8. Gọi DAO để update
                        menuDAO.updateMenuItem(item);

                        // Log để kiểm tra
                        System.out.println("Đã cập nhật món ID: " + id);
                    }
                } catch (Exception e) {
                    System.out.println("[AdminMenuController - Edit] Lỗi: " + e.getMessage());
                    e.printStackTrace();
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
