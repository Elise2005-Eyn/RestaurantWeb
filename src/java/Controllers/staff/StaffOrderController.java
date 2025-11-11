package Controllers.staff;

import DAO.OrderDAO;
import Models.Order;
import Models.OrderItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/staff/orders")
public class StaffOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                // ✅ Gọi thêm dữ liệu cho dropdown
                req.setAttribute("tables", orderDAO.getAvailableTables());
                req.setAttribute("menuItems", orderDAO.getAllMenuItems());
                req.setAttribute("reservations", orderDAO.getReservationsWithCustomer());
                req.getRequestDispatcher("/Views/staff/order_add.jsp").forward(req, resp);
                break;

            case "changeStatus":
                handleChangeStatus(req, resp);
                break;

            case "detail":
                handleDetail(req, resp);
                break;

            default:
                handleList(req, resp);
        }
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            long orderId = Long.parseLong(req.getParameter("id"));
            Map<String, Object> order = orderDAO.getOrderDetail(orderId);
            List<Map<String, Object>> items = orderDAO.getOrderItemsByOrderId(orderId);

            req.setAttribute("order", order);
            req.setAttribute("items", items);
            req.getRequestDispatcher("/Views/staff/order_detail.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("errorMsg", "Không thể xem chi tiết đơn hàng!");
            resp.sendRedirect(req.getContextPath() + "/staff/orders");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception ignored) {
        }

        String status = req.getParameter("status");
        List<Order> orders;
        int totalOrders;

        if (status != null && !status.isBlank()) {
            orders = orderDAO.getOrdersByStatus(status, page, pageSize);
            totalOrders = orderDAO.getTotalOrdersByStatus(status);
            req.setAttribute("currentStatus", status);
        } else {
            orders = orderDAO.getOrdersPaginated(page, pageSize);
            totalOrders = orderDAO.getTotalOrders();
        }

        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/Views/staff/order_list.jsp").forward(req, resp);
    }

    private void handleChangeStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            long orderId = Long.parseLong(req.getParameter("id"));
            String newStatus = req.getParameter("status");

            // ✅ Chỉ cho phép 4 giá trị hợp lệ (đồng bộ với constraint)
            if (!newStatus.matches("PENDING|IN_PROGRESS|COMPLETED|CANCELLED")) {
                req.getSession().setAttribute("errorMsg", "Trạng thái không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/staff/orders");
                return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
            if (success) {
                req.getSession().setAttribute("successMsg", "Cập nhật trạng thái thành công!");
            } else {
                req.getSession().setAttribute("errorMsg", "Không thể cập nhật trạng thái!");
            }

        } catch (Exception e) {
            req.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }
        resp.sendRedirect(req.getContextPath() + "/staff/orders");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // ==========================
            // 1️⃣ LẤY DỮ LIỆU CHUNG
            // ==========================
            Order order = new Order();

            String reservationParam = req.getParameter("reservationId");
            if (reservationParam != null && !reservationParam.isBlank()) {
                order.setReservationId(Long.parseLong(reservationParam));
            }

            String customerParam = req.getParameter("customerId");
            if (customerParam != null && !customerParam.isBlank()) {
                order.setCustomerId(java.util.UUID.fromString(customerParam));
            }

            order.setTableId(Integer.parseInt(req.getParameter("tableId")));
            order.setStatus(req.getParameter("status"));
            order.setOrderType(req.getParameter("orderType"));
            order.setNote(req.getParameter("note"));

            // ==========================
            // 2️⃣ LẤY DANH SÁCH MÓN ĂN
            // ==========================
            String[] menuItemIds = req.getParameterValues("menuItemId");
            String[] quantities = req.getParameterValues("quantity");
            String[] prices = req.getParameterValues("price");

            List<OrderItem> items = new ArrayList<>();
            double totalAmount = 0;

            if (menuItemIds != null) {
                for (int i = 0; i < menuItemIds.length; i++) {
                    int itemId = Integer.parseInt(menuItemIds[i]);
                    int qty = Integer.parseInt(quantities[i]);
                    double price = Double.parseDouble(prices[i]);
                    double subtotal = qty * price;
                    totalAmount += subtotal;

                    OrderItem item = new OrderItem();
                    item.setMenuItemId(itemId);
                    item.setQuantity(qty);
                    item.setPrice(price);
                    item.setNote(null);
                    items.add(item);
                }
            }

            order.setAmount(totalAmount);

            // ==========================
            // 3️⃣ GỌI DAO THÊM ĐƠN HÀNG
            // ==========================
            boolean added = orderDAO.addOrderWithItems(order, items);

            if (added) {
                req.getSession().setAttribute("successMsg", "✅ Thêm đơn hàng cùng món ăn thành công!");
            } else {
                req.getSession().setAttribute("errorMsg", "❌ Không thể thêm đơn hàng!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Lỗi khi thêm đơn hàng: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/orders");
    }
}
