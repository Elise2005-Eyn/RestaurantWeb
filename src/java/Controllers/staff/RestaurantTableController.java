package Controllers.staff;

import DAO.OrderDAO;
import DAO.RestaurantTableDAO;
import Models.OrderItem;
import Models.RestaurantTable;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantTableController", urlPatterns = {"/staff/manager-table"})
public class RestaurantTableController extends HttpServlet {

    private RestaurantTableDAO tableDAO;

    @Override
    public void init() throws ServletException {
        tableDAO = new RestaurantTableDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listTables(request, response);
                break;

            case "updateStatus":
                updateStatus(request, response);
                break;

            case "view":
                viewTableDetail(request, response);
                break;

            case "orderHistory":
                showOrderHistory(request, response);
                break;

            case "addItem":
                addItem(request, response);
                break;

            default:
                listTables(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 📜 Hiển thị lịch sử order của bàn + danh sách menu
    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tableId = Integer.parseInt(request.getParameter("id"));
            OrderDAO dao = new OrderDAO();

            // ✅ Gọi hàm mới cho staff (không cần customer)
            long orderId = dao.createOrGetActiveOrderForTable(tableId);

            List<OrderItem> list = dao.getOrderHistoryByTable(tableId);
            List<String[]> menuList = dao.getAllMenuItems2();

            request.setAttribute("tableId", tableId);
            request.setAttribute("orderId", orderId);
            request.setAttribute("orderHistory", list);
            request.setAttribute("menuList", menuList);

            RequestDispatcher rd = request.getRequestDispatcher("/Views/staff/table_order_history.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manager-table?action=list");
        }
    }

    // ➕ Thêm món vào order cho bàn (staff thao tác)
    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            int menuItemId = Integer.parseInt(request.getParameter("menuItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            OrderDAO dao = new OrderDAO();
            long orderId = dao.createOrGetActiveOrderForTable(tableId);
            boolean added = dao.addItemToOrder(orderId, menuItemId, quantity);

            if (added) {
                request.getSession().setAttribute("flash", "✅ Đã thêm món thành công!");
            } else {
                request.getSession().setAttribute("flash", "❌ Không thể thêm món!");
            }
            response.sendRedirect("manager-table?action=orderHistory&id=" + tableId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manager-table?action=list");
        }
    }

    // 📋 Hiển thị danh sách bàn cho staff
    private void listTables(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<RestaurantTable> tables = tableDAO.getAllTablesForStaff();
            request.setAttribute("tables", tables);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/staff/table_list_staff.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách bàn: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/Views/staff/table_list_staff.jsp");
            rd.forward(request, response);
        }
    }

    // 🔄 Cập nhật trạng thái bàn
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            boolean success = false;

            if ("OCCUPIED".equalsIgnoreCase(status)) {
                success = tableDAO.seatWalkInCustomer(id);
            } else if ("AVAILABLE".equalsIgnoreCase(status)) {
                success = tableDAO.releaseTable(id);
            } else {
                success = tableDAO.updateStatus(id, status);
            }

            if (success) {
                request.getSession().setAttribute("flash", "✅ Cập nhật trạng thái bàn thành công!");
            } else {
                request.getSession().setAttribute("flash", "❌ Cập nhật trạng thái bàn thất bại!");
            }

            response.sendRedirect("manager-table?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect("manager-table?action=list");
        }
    }

    // 🔍 Xem chi tiết 1 bàn
    private void viewTableDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            RestaurantTable table = tableDAO.getTableById(id);
            request.setAttribute("table", table);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/staff/table_detail.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manager-table?action=list");
        }
    }
}
