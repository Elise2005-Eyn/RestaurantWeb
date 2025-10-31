package Controllers.staff;

import DAO.TableDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;

@WebServlet("/staff/tables/assign")
public class StaffTableAssignController extends HttpServlet {

    private final TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/staff/tables");
            return;
        }

        try {
            int tableId = Integer.parseInt(idParam);

            // Lấy danh sách khách hàng từ DB (demo có thể sửa theo DAO riêng)
            List<Map<String, Object>> customers = tableDAO.getAllCustomers();

            req.setAttribute("tableId", tableId);
            req.setAttribute("customers", customers);

            req.getRequestDispatcher("/Views/staff/table_assign.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/tables");
        }
    }

    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws IOException {
    try {
        int tableId = Integer.parseInt(req.getParameter("table_id"));
        String customerIdStr = req.getParameter("customer_id");
        String rawDate = req.getParameter("reserved_at");
        int duration = Integer.parseInt(req.getParameter("reserved_duration"));
        int guestCount = Integer.parseInt(req.getParameter("guest_count"));
        String note = req.getParameter("note");

        // ✅ Chuyển String -> UUID
        java.util.UUID customerId = java.util.UUID.fromString(customerIdStr);

        // ✅ Chuyển định dạng datetime-local -> Timestamp
        Timestamp reservedAt = Timestamp.valueOf(rawDate.replace("T", " ") + ":00");

        boolean success = tableDAO.assignTableToCustomer(customerId, tableId, reservedAt, duration, guestCount, note);

        HttpSession session = req.getSession();
        if (success) {
            session.setAttribute("successMsg", "✅ Gán bàn cho khách hàng thành công!");
        } else {
            session.setAttribute("errorMsg", "❌ Không thể gán bàn. Hãy kiểm tra lại dữ liệu!");
        }
    } catch (Exception e) {
        e.printStackTrace();
        HttpSession session = req.getSession();
        session.setAttribute("errorMsg", "❌ Lỗi xử lý: " + e.getMessage());
    }

    resp.sendRedirect(req.getContextPath() + "/staff/tables");
}

}
