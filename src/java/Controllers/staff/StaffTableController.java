package Controllers.staff;

import DAO.TableDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/staff/tables")
public class StaffTableController extends HttpServlet {

    private final TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "history":
                showHistory(req, resp);
                break;
            default:
                showList(req, resp);
        }
    }

    // ==================== HIỂN THỊ DANH SÁCH BÀN ====================
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 8;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception ignored) {}

        String statusParam = req.getParameter("status");
        Boolean isActive = null;
        if ("active".equalsIgnoreCase(statusParam)) {
            isActive = true;
        } else if ("inactive".equalsIgnoreCase(statusParam)) {
            isActive = false;
        }

        List<Map<String, Object>> tables;
        int totalTables;

        if (isActive == null) {
            tables = tableDAO.getTablesPaginated(page, pageSize);
            totalTables = tableDAO.getTotalTables();
        } else {
            tables = tableDAO.getTablesByStatus(isActive, page, pageSize);
            totalTables = tableDAO.getTotalTablesByStatus(isActive);
        }

        int totalPages = (int) Math.ceil((double) totalTables / pageSize);

        req.setAttribute("tables", tables);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentStatus", statusParam);

        req.getRequestDispatcher("/Views/staff/table_list.jsp").forward(req, resp);
    }

    // ==================== TRANG LỊCH SỬ ĐẶT BÀN ====================
    private void showHistory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/staff/tables");
            return;
        }

        try {
            int tableId = Integer.parseInt(idParam);
            List<Map<String, Object>> history = tableDAO.getReservationHistoryByTable(tableId);

            req.setAttribute("history", history);
            req.setAttribute("tableId", tableId);

            req.getRequestDispatcher("/Views/staff/table_history_page.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/staff/tables");
        }
    }

    // ==================== CẬP NHẬT TRẠNG THÁI BÀN ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

        if ("changeStatus".equalsIgnoreCase(action)) {
            try {
                int tableId = Integer.parseInt(req.getParameter("id"));
                boolean isActive = Boolean.parseBoolean(req.getParameter("is_active"));
                tableDAO.updateTableStatus(tableId, isActive);
            } catch (Exception e) {
                System.out.println("[StaffTableController] ❌ Lỗi changeStatus: " + e.getMessage());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/staff/tables");
    }
}
