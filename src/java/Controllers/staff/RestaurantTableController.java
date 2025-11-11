package Controllers.staff;

import DAO.RestaurantTableDAO;
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

            // Nếu khách mới ngồi xuống → tạo Reservation vãng lai
            if ("OCCUPIED".equalsIgnoreCase(status)) {
                success = tableDAO.seatWalkInCustomer(id);

            // Nếu khách rời đi → đóng Reservation đang hoạt động
            } else if ("AVAILABLE".equalsIgnoreCase(status)) {
                success = tableDAO.releaseTable(id);

            // Các trạng thái khác (BOOKED, INACTIVE, ...)
            } else {
                success = tableDAO.updateStatus(id, status);
            }

            if (success) {
                request.getSession().setAttribute("flash", "Cập nhật trạng thái bàn thành công!");
            } else {
                request.getSession().setAttribute("flash", "Cập nhật trạng thái bàn thất bại!");
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
