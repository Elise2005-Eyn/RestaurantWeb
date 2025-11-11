package Controllers.staff;

<<<<<<< HEAD
import DAO.TableDAO;
=======
import DAO.ReservationDAO;
import DAO.TableDAO;
import Models.Reservation;
import Models.RestaurantTable;
>>>>>>> LeThuUyen-Staff
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

<<<<<<< HEAD
        String action = req.getParameter("action");
        if (action == null) action = "list";
=======
        ReservationDAO reservationDAO = new ReservationDAO();
        
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }
>>>>>>> LeThuUyen-Staff

        switch (action) {
            case "history":
                showHistory(req, resp);
                break;
<<<<<<< HEAD
            default:
                showList(req, resp);
        }
    }

    // ==================== HIỂN THỊ DANH SÁCH BÀN ====================
    private void showList(HttpServletRequest req, HttpServletResponse resp)
=======
            //case "list":
//                List<Reservation> reservations = reservationDAO.getReservationsByStatus("CONFIRMED", 1, 8);
//                req.setAttribute("reservations", reservations);
//                //showListTables(req, resp);                
//                List<Map<String, Object>> tables = tableDAO.getALLActiveTables();
//                req.setAttribute("tables", tables);
//                //showListReservation(req, resp);
//                req.getRequestDispatcher("/Views/staff/table_list_demo.jsp").forward(req, resp);
//                showListTables(req, resp); 
                  //showListReservation(req, resp);
                //showListTables(req, resp);
                //break;
            default:
                showListTables(req, resp);
        }
    }

    // ==================== HIỂN THỊ DANH SÁCH ĐƠN ĐẶT BÀN ====================
    private void showListReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        ReservationDAO reservationDAO = new ReservationDAO();

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }
        String status = request.getParameter("CONFIRMED");
        List<Reservation> reservations;
        int totalReservations;
        reservations = reservationDAO.getReservationsByStatus(status, page, pageSize);
        totalReservations = reservationDAO.getTotalReservationsByStatus(status);
        request.setAttribute("currentStatus", status);

        int totalPages = (int) Math.ceil((double) totalReservations / pageSize);
        request.setAttribute("reservations", reservations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/Views/staff/table_list_demo.jsp").forward(request, response);
    }

    // ==================== HIỂN THỊ DANH SÁCH BÀN ====================
    private void showListTables(HttpServletRequest req, HttpServletResponse resp)
>>>>>>> LeThuUyen-Staff
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 8;
        try {
            page = Integer.parseInt(req.getParameter("page"));
<<<<<<< HEAD
        } catch (Exception ignored) {}
=======
        } catch (Exception ignored) {
        }
>>>>>>> LeThuUyen-Staff

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
<<<<<<< HEAD
            tables = tableDAO.getTablesPaginated(page, pageSize);
=======
            tables = tableDAO.getALLActiveTables();
>>>>>>> LeThuUyen-Staff
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
