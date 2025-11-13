package Controllers.admin;

import DAO.VoucherDAO;
import Models.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/voucher"})
public class AdminVoucherController extends HttpServlet {

    private final VoucherDAO dao = new VoucherDAO();
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
        if (action == null) action = "list";

        switch (action) {

            // ================== DANH SÁCH + PHÂN TRANG ==================
            case "list": {
                int page = 1;
                try {
                    if (req.getParameter("page") != null) {
                        page = Integer.parseInt(req.getParameter("page"));
                        if (page < 1) page = 1;
                    }
                } catch (NumberFormatException ignored) {}

                List<Voucher> voucherList = dao.getVouchersByPage(page, PAGE_SIZE);
                int totalItems = dao.getTotalVouchers();
                int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

                req.setAttribute("vouchers", voucherList);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("/Views/admin/voucher-list.jsp").forward(req, resp);
                break;
            }

            // ================== TÌM KIẾM ==================
            case "search": {
                String keyword = req.getParameter("keyword");
                String min = req.getParameter("minDiscount");
                String max = req.getParameter("maxDiscount");
                String activeStr = req.getParameter("isActive");

                Double minDiscount = (min != null && !min.isEmpty()) ? Double.parseDouble(min) : null;
                Double maxDiscount = (max != null && !max.isEmpty()) ? Double.parseDouble(max) : null;
                Boolean isActive = null;
                if (activeStr != null && !activeStr.isEmpty()) {
                    isActive = activeStr.equals("1");
                }

                List<Voucher> result = dao.searchVouchers(keyword, minDiscount, maxDiscount, isActive);

                req.setAttribute("vouchers", result);
                req.setAttribute("keyword", keyword);
                req.setAttribute("minDiscount", min);
                req.setAttribute("maxDiscount", max);
                req.setAttribute("selectedStatus", activeStr);

                req.getRequestDispatcher("/Views/admin/voucher-list.jsp").forward(req, resp);
                break;
            }

            // ================== THÊM ==================
            case "add": {
                req.getRequestDispatcher("/Views/admin/voucher-add.jsp").forward(req, resp);
                break;
            }

            // ================== SỬA ==================
            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Voucher v = dao.getVoucherById(id);
                    if (v != null) {
                        req.setAttribute("voucher", v);
                        req.getRequestDispatcher("/Views/admin/voucher-edit.jsp").forward(req, resp);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                    }
                } catch (Exception e) {
                    System.out.println("[AdminVoucherController] Lỗi mở form edit: " + e.getMessage());
                    resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                }
                break;
            }

            // ================== XÓA ==================
            case "delete": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.deleteVoucher(id);
                } catch (Exception e) {
                    System.out.println("[AdminVoucherController] Lỗi xóa: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
        }
    }

    // ================== POST HANDLER ==================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            // ===== THÊM VOUCHER =====
            case "add": {
                try {
                    Voucher v = new Voucher();
                    v.setCode(req.getParameter("code"));
                    v.setDescription(req.getParameter("description"));
                    v.setDiscountPercent(new BigDecimal(req.getParameter("discount_percent")));
                    v.setStartDate(LocalDateTime.parse(req.getParameter("start_date")));
                    v.setEndDate(LocalDateTime.parse(req.getParameter("end_date")));
                    v.setActive(Boolean.parseBoolean(req.getParameter("is_active")));
                    dao.addVoucher(v);
                } catch (Exception e) {
                    System.out.println("[AdminVoucherController] Lỗi thêm: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
            }

            // ===== CẬP NHẬT VOUCHER =====
            case "edit": {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Voucher v = dao.getVoucherById(id);
                    if (v != null) {
                        v.setCode(req.getParameter("code"));
                        v.setDescription(req.getParameter("description"));
                        v.setDiscountPercent(new BigDecimal(req.getParameter("discount_percent")));
                        v.setStartDate(LocalDateTime.parse(req.getParameter("start_date")));
                        v.setEndDate(LocalDateTime.parse(req.getParameter("end_date")));
                        v.setActive(Boolean.parseBoolean(req.getParameter("is_active")));
                        dao.updateVoucher(v);
                    }
                } catch (Exception e) {
                    System.out.println("[AdminVoucherController] Lỗi cập nhật: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
        }
    }
}
