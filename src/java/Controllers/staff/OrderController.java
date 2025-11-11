package Controllers.staff;

import DAO.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "OrderController", urlPatterns = {"/staff/order"})
public class OrderController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "create";

        switch (action) {
            case "create":
                showOrderForm(request, response);
                break;
            default:
                response.sendRedirect("manager-table?action=list");
                break;
        }
    }

    // 🟢 Hiển thị form đặt món ăn
    private void showOrderForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tableId = Integer.parseInt(request.getParameter("tableId"));

            // Gọi hàm có sẵn trong DAO
            List<Map<String, Object>> menuItems = orderDAO.getAllMenuItems();

            request.setAttribute("menuItems", menuItems);
            request.setAttribute("tableId", tableId);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/staff/order_form.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Lỗi tải menu: " + e.getMessage());
            response.sendRedirect("manager-table?action=list");
        }
    }

    // 🟣 Xử lý đặt món ăn (submit form)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            String[] itemIdsStr = request.getParameterValues("itemId");
            String[] qtyStr = request.getParameterValues("quantity");

            if (itemIdsStr == null || itemIdsStr.length == 0) {
                request.getSession().setAttribute("flash", "Vui lòng chọn ít nhất một món ăn!");
                response.sendRedirect("manager-table?action=list");
                return;
            }

            // Convert sang int[]
            int[] itemIds = Arrays.stream(itemIdsStr).mapToInt(Integer::parseInt).toArray();
            int[] quantities = Arrays.stream(qtyStr).mapToInt(Integer::parseInt).toArray();

            boolean success = orderDAO.createOrderForTable(tableId, itemIds, quantities);

            if (success)
                request.getSession().setAttribute("flash", "Đặt món thành công!");
            else
                request.getSession().setAttribute("flash", "Đặt món thất bại!");

            response.sendRedirect("manager-table?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Lỗi xử lý đặt món: " + e.getMessage());
            response.sendRedirect("manager-table?action=list");
        }
    }
}
