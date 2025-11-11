package DAO;

import Models.CartItem;
import Models.Order;
import Models.OrderItem;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class OrderDAO extends DBContext {

    public void saveOrder(List<CartItem> cart, String transactionCode, int userId) {
        String insertOrderSql = """
        INSERT INTO Orders (customer_id, created_at, amount, status, order_type, note)
        VALUES (?, SYSDATETIME(), ?, ?, ?, ?)
    """;

        String insertItemSql = """
        INSERT INTO OrderItems (order_id, menu_item_id, quantity, price)
        VALUES (?, ?, ?, ?)
    """;

        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement itemPs = null;
        ResultSet rs = null;

        try {
            conn = connection;
            conn.setAutoCommit(false);

            // ✅ Lấy customer_id theo user_id
            UUID customerId = getCustomerIdByUserId(userId);
            if (customerId == null) {
                throw new SQLException("Không tìm thấy customer_id cho user_id = " + userId);
            }

            // ✅ Tính tổng tiền
            double total = 0;
            for (CartItem item : cart) {
                total += item.getPrice() * item.getQuantity();
            }

            // ✅ Thêm order mới
            orderPs = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setObject(1, customerId);
            orderPs.setDouble(2, total);
            orderPs.setString(3, "PENDING");
            orderPs.setString(4, "DELIVERY"); // ✅ Phải khớp constraint trong DB
            orderPs.setString(5, "Thanh toán qua VNPAY (" + transactionCode + ")");
            orderPs.executeUpdate();

            rs = orderPs.getGeneratedKeys();
            long orderId = 0;
            if (rs.next()) {
                orderId = rs.getLong(1);
            }

            // ✅ Thêm chi tiết đơn hàng
            itemPs = conn.prepareStatement(insertItemSql);
            for (CartItem item : cart) {
                itemPs.setLong(1, orderId);
                itemPs.setInt(2, item.getId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getPrice());
                itemPs.addBatch();
            }
            itemPs.executeBatch();

            conn.commit();
            System.out.println("✅ Lưu đơn hàng thành công! OrderID: " + orderId);

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ignore) {
            }
            System.err.println("❌ Lỗi khi lưu đơn hàng: " + e.getMessage());
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
                if (orderPs != null) {
                    orderPs.close();
                }
                if (itemPs != null) {
                    itemPs.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ignore) {
            }
        }
    }

//    public void saveOrder(List<CartItem> cart, String transactionCode, int userId) {
//        String orderSql = "INSERT INTO Orders (transaction_code, user_id, total_amount, created_at) VALUES (?, ?, ?, GETDATE())";
//        String itemSql = "INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
//
//        Connection conn = null;
//        PreparedStatement orderPs = null;
//        PreparedStatement itemPs = null;
//        ResultSet rs = null;
//
//        try {
//            conn = connection;
//            conn.setAutoCommit(false); // Bắt đầu transaction
//
//            // 1️⃣ Tính tổng tiền
//            double totalAmount = 0;
//            for (CartItem item : cart) {
//                totalAmount += item.getPrice() * item.getQuantity();
//            }
//
//            // 2️⃣ Tạo đơn hàng
//            orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
//            orderPs.setString(1, transactionCode);
//            orderPs.setInt(2, userId);
//            orderPs.setDouble(3, totalAmount);
//            orderPs.executeUpdate();
//
//            rs = orderPs.getGeneratedKeys();
//            if (!rs.next()) {
//                throw new SQLException("Không thể tạo đơn hàng (không có order_id trả về)");
//            }
//
//            int orderId = rs.getInt(1);
//
//            // 3️⃣ Thêm sản phẩm vào OrderItems
//            itemPs = conn.prepareStatement(itemSql);
//            for (CartItem item : cart) {
//                itemPs.setInt(1, orderId);
//                itemPs.setInt(2, item.getId());       // hoặc getProductId() tuỳ model bạn
//                itemPs.setInt(3, item.getQuantity());
//                itemPs.setDouble(4, item.getPrice());
//                itemPs.addBatch();
//            }
//            itemPs.executeBatch();
//
//            // 4️⃣ Commit giao dịch
//            conn.commit();
//            System.out.println("✅ Lưu đơn hàng thành công (OrderID=" + orderId + ")");
//        } catch (SQLException e) {
//            try {
//                if (conn != null) {
//                    conn.rollback();
//                }
//                System.err.println("❌ Lỗi khi lưu đơn hàng: " + e.getMessage());
//            } catch (SQLException rollbackEx) {
//                System.err.println("❌ Rollback thất bại: " + rollbackEx.getMessage());
//            }
//        } finally {
//            try {
//                if (rs != null) {
//                    rs.close();
//                }
//            } catch (Exception ignore) {
//            }
//            try {
//                if (orderPs != null) {
//                    orderPs.close();
//                }
//            } catch (Exception ignore) {
//            }
//            try {
//                if (itemPs != null) {
//                    itemPs.close();
//                }
//            } catch (Exception ignore) {
//            }
//            try {
//                if (conn != null) {
//                    conn.setAutoCommit(true);
//                }
//            } catch (Exception ignore) {
//            }
//        }
//    }
//    public void saveOrder(List<CartItem> cart, String transactionCode) {
//        String sql = "INSERT INTO Orders (transaction_code, created_at) VALUES (?, GETDATE());";
//        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            ps.setString(1, transactionCode);
//            ps.executeUpdate();
//            ResultSet rs = ps.getGeneratedKeys();
//            if (rs.next()) {
//                int orderId = rs.getInt(1);
//                String itemSql = "INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
//                try (PreparedStatement itemPs = connection.prepareStatement(itemSql)) {
//                    for (CartItem item : cart) {
//                        itemPs.setInt(1, orderId);
//                        itemPs.setInt(2, item.getProductId());
//                        itemPs.setInt(3, item.getQuantity());
//                        itemPs.setDouble(4, item.getPrice());
//                        itemPs.addBatch();
//                    }
//                    itemPs.executeBatch();
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
    // Hàm đếm tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS total FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi đếm đơn hàng: " + e.getMessage());
        }
        return 0;
    }

    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> data = new LinkedHashMap<>();

        String sql = """
       SELECT 
                FORMAT(created_at, 'MM-yyyy') AS month_year,
                SUM(amount) AS total_revenue
            FROM Orders
            WHERE amount > 0 AND status = 'COMPLETED'
            GROUP BY FORMAT(created_at, 'MM-yyyy')
            ORDER BY MIN(created_at);
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String month = rs.getString("month_year");
                double revenue = rs.getDouble("total_revenue");
                data.put(month, revenue);
                System.out.println("📊 Tháng " + month + " → " + revenue + " VND");
            }

        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi lấy doanh thu theo tháng: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("✅ Tổng số tháng có dữ liệu: " + data.size());
        return data;
    }

    public Map<String, Integer> getOrderStatusCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
        SELECT status, COUNT(*) AS total
        FROM Orders
        GROUP BY status
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }

        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getOrderStatusCount: " + e.getMessage());
        }
        return map;
    }

    public List<Order> getOrdersPaginated(int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT o.*, c.full_name AS customer_name
        FROM Orders o
        LEFT JOIN Customer c ON o.customer_id = c.customer_id
        ORDER BY o.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setReservationId(rs.getLong("reservation_id"));
                    o.setTableId(rs.getInt("table_id"));
                    o.setCustomerName(rs.getString("customer_name")); // ✅ thêm trường mới
                    //o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    o.setCreatedAt(createdAt);
                    o.setCreatedAtFormatted(createdAt.format(
                            DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                    ));
                    o.setAmount(rs.getDouble("amount"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setNote(rs.getString("note"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi getOrdersPaginated: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByStatus(String status, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT o.*, c.full_name AS customer_name
        FROM Orders o
        LEFT JOIN Customer c ON o.customer_id = c.customer_id
        WHERE o.status = ?
        ORDER BY o.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setReservationId(rs.getLong("reservation_id"));
                    o.setTableId(rs.getInt("table_id"));
                    o.setCustomerName(rs.getString("customer_name")); // ✅
                    //o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    o.setCreatedAt(createdAt);
                    o.setCreatedAtFormatted(createdAt.format(
                            DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                    ));
                    o.setAmount(rs.getDouble("amount"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setNote(rs.getString("note"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi getOrdersByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số đơn hàng theo trạng thái (phục vụ phân trang khi lọc)
     */
    public int getTotalOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM Orders WHERE status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getTotalOrdersByStatus: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy chi tiết 1 đơn hàng theo ID
     */
    public Models.Order getOrderById(long orderId) {
        String sql = "SELECT * FROM Orders WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Models.Order o = new Models.Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setReservationId(rs.getObject("reservation_id", Long.class));
                    o.setTableId(rs.getObject("table_id", Integer.class));
                    o.setCustomerId((UUID) rs.getObject("customer_id"));
                    o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    o.setAmount(rs.getDouble("amount"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setNote(rs.getString("note"));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getOrderById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(long orderId, String newStatus) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi updateOrderStatus: " + e.getMessage());
        }
        return false;
    }

    /**
     * Thêm đơn hàng mới
     */
    public boolean addOrder(Models.Order o) {
        String sql = """
            INSERT INTO Orders (reservation_id, table_id, customer_id, created_at, amount, status, order_type, note)
            VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, o.getReservationId(), Types.BIGINT);
            ps.setObject(2, o.getTableId(), Types.INTEGER);
            ps.setObject(3, o.getCustomerId());
            ps.setDouble(4, o.getAmount());
            ps.setString(5, o.getStatus());
            ps.setString(6, o.getOrderType());
            ps.setString(7, o.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi addOrder: " + e.getMessage());
        }
        return false;
    }

    public boolean addOrderWithItems(Order order, List<OrderItem> items) {
        String insertOrderSql = """
        INSERT INTO Orders (reservation_id, table_id, customer_id, created_at, amount, status, order_type, note)
        VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?)
    """;

        String insertItemSql = """
        INSERT INTO OrderItems (order_id, menu_item_id, quantity, price, note, created_at)
        VALUES (?, ?, ?, ?, ?, GETDATE())
    """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psOrder = connection.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setObject(1, order.getReservationId());
                psOrder.setInt(2, order.getTableId());
                psOrder.setObject(3, order.getCustomerId());
                psOrder.setDouble(4, order.getAmount());
                psOrder.setString(5, order.getStatus());
                psOrder.setString(6, order.getOrderType());
                psOrder.setString(7, order.getNote());
                psOrder.executeUpdate();

                ResultSet rs = psOrder.getGeneratedKeys();
                long orderId = 0;
                if (rs.next()) {
                    orderId = rs.getLong(1);
                }

                try (PreparedStatement psItem = connection.prepareStatement(insertItemSql)) {
                    for (OrderItem item : items) {
                        psItem.setLong(1, orderId);
                        psItem.setInt(2, item.getMenuItemId());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setDouble(4, item.getPrice());
                        psItem.setString(5, item.getNote());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("[OrderDAO] ❌ Lỗi addOrderWithItems: " + e.getMessage());
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // ==================== LẤY DANH SÁCH BÀN ====================
    public List<Map<String, Object>> getAvailableTables() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT table_id, code, note
        FROM RestaurantTable
        WHERE is_active = 1
        ORDER BY area_id, table_id
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("id", rs.getInt("table_id"));
                t.put("label", rs.getString("code") + " (" + rs.getString("note") + ")");
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi getAvailableTables: " + e.getMessage());
        }
        return list;
    }

// ==================== LẤY DANH SÁCH MÓN ĂN ====================
    public List<Map<String, Object>> getAllMenuItems() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT id, name, price 
        FROM MenuItem
        WHERE is_active = 1
        ORDER BY category_id
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getInt("id"));
                m.put("name", rs.getString("name"));
                m.put("price", rs.getDouble("price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi getAllMenuItems: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getReservationsWithCustomer() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT 
            r.reservation_id AS reservation_id,
            c.full_name AS customer_name,
            r.customer_id,
            r.status,
            r.note
        FROM Reservation r
        JOIN Customer c ON r.customer_id = c.customer_id
        WHERE r.status = 'CONFIRMED'
        ORDER BY r.reservation_id DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("reservation_id", rs.getLong("reservation_id"));
                row.put("customer_name", rs.getString("customer_name"));
                row.put("customer_id", rs.getString("customer_id"));
                row.put("status", rs.getString("status"));
                row.put("note", rs.getString("note"));
                list.add(row);
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getReservationsWithCustomer: " + e.getMessage());
        }
        return list;
    }

// ==================== LẤY CHI TIẾT ĐƠN HÀNG ====================
    public Map<String, Object> getOrderDetail(long orderId) {
        String sql = """
        SELECT o.order_id, o.amount, o.status, o.order_type, o.note, o.created_at,
               c.full_name AS customer_name, t.code AS table_code
        FROM Orders o
        LEFT JOIN Customer c ON o.customer_id = c.customer_id
        LEFT JOIN RestaurantTable t ON o.table_id = t.table_id
        WHERE o.order_id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("order_id", rs.getLong("order_id"));
                    map.put("amount", rs.getDouble("amount"));
                    map.put("status", rs.getString("status"));
                    map.put("order_type", rs.getString("order_type"));
                    map.put("note", rs.getString("note"));
                    //map.put("created_at", rs.getTimestamp("created_at"));

                    Timestamp ts = rs.getTimestamp("created_at");
                    map.put("created_at", ts);

                    if (ts != null) {
                        LocalDateTime createdAt = ts.toLocalDateTime();
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
                        map.put("created_at_formatted", createdAt.format(formatter));
                    } else {
                        map.put("created_at_formatted", "Không xác định");
                    }

                    map.put("customer_name", rs.getString("customer_name"));
                    map.put("table_code", rs.getString("table_code"));
                    return map;
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getOrderDetail: " + e.getMessage());
        }
        return null;
    }

// ==================== LẤY DANH SÁCH MÓN ĂN THEO ĐƠN ====================
    public List<Map<String, Object>> getOrderItemsByOrderId(long orderId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT m.name, oi.quantity, oi.price, (oi.quantity * oi.price) AS subtotal
        FROM OrderItems oi
        JOIN MenuItem m ON oi.menu_item_id = m.id
        WHERE oi.order_id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", rs.getString("name"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("price", rs.getDouble("price"));
                    item.put("subtotal", rs.getDouble("subtotal"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getOrderItemsByOrderId: " + e.getMessage());
        }
        return list;
    }

    public List<Order> getOrdersByCustomer(UUID customerId) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT order_id, created_at, amount, status, order_type, note
        FROM Orders
        WHERE customer_id = ?
        ORDER BY created_at DESC
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    o.setAmount(rs.getDouble("amount"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setNote(rs.getString("note"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getOrdersByCustomer: " + e.getMessage());
        }
        return list;
    }

    public UUID getCustomerIdByUserId(int userId) {
        String sql = "SELECT customer_id FROM Customer WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return UUID.fromString(rs.getString("customer_id"));
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi getCustomerIdByUserId: " + e.getMessage());
        }
        return null;
    }

    public List<Order> getOrdersByCustomerUUID(UUID customerId) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT o.*, c.full_name AS customer_name
        FROM Orders o
        JOIN Customer c ON o.customer_id = c.customer_id
        WHERE o.customer_id = ?
        ORDER BY o.created_at DESC
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getLong("order_id"));
                o.setReservationId(rs.getLong("reservation_id"));
                o.setTableId(rs.getInt("table_id"));
                o.setCustomerId(UUID.fromString(rs.getString("customer_id")));
                o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                o.setAmount(rs.getDouble("amount"));
                o.setStatus(rs.getString("status"));
                o.setOrderType(rs.getString("order_type"));
                o.setNote(rs.getString("note"));
                o.setCustomerName(rs.getString("customer_name"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy chi tiết 1 đơn hàng (bao gồm tên khách hàng)
    public Order getOrderById2(long orderId) {
        String sql = """
            SELECT o.order_id, o.created_at, o.amount, o.status, o.order_type, o.note,
                   c.full_name AS customer_name
            FROM Orders o
            JOIN Customer c ON o.customer_id = c.customer_id
            WHERE o.order_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getLong("order_id"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    order.setCreatedAt(ts.toLocalDateTime());
                }
                order.setAmount(rs.getDouble("amount"));
                order.setStatus(rs.getString("status"));
                order.setOrderType(rs.getString("order_type"));
                order.setNote(rs.getString("note"));
                order.setCustomerName(rs.getString("customer_name"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId2(long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = """
        SELECT oi.id AS item_id, oi.menu_item_id, m.name AS menu_name,
               oi.quantity, oi.price, oi.note, oi.created_at
        FROM OrderItems oi
        JOIN MenuItem m ON oi.menu_item_id = m.id
        WHERE oi.order_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getLong("item_id"));
                item.setOrderId(orderId);
                item.setMenuItemId(rs.getInt("menu_item_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setNote(rs.getString("menu_name")); // dùng để hiển thị tên món
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    item.setCreatedAt(ts.toLocalDateTime());
                }
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();

        // 🧪 Nhập ID đơn hàng bạn muốn test
        long testOrderId = 9; // 👉 Thay bằng ID thật trong bảng Orders

        System.out.println("=== 🔍 TEST getOrderById2() ===");
        Order order = dao.getOrderById2(testOrderId);
        if (order != null) {
            System.out.println("🧾 Mã đơn hàng: " + order.getOrderId());
            System.out.println("👤 Khách hàng: " + order.getCustomerName());
            System.out.println("📅 Ngày tạo: " + order.getCreatedAt());
            System.out.println("💰 Tổng tiền: " + order.getAmount());
            System.out.println("🚚 Loại đơn: " + order.getOrderType());
            System.out.println("📦 Trạng thái: " + order.getStatus());
            System.out.println("📝 Ghi chú: " + order.getNote());
        } else {
            System.out.println("❌ Không tìm thấy đơn hàng ID = " + testOrderId);
        }

        System.out.println("\n=== 🍽️ TEST getOrderItemsByOrderId2() ===");
        List<OrderItem> items = dao.getOrderItemsByOrderId2(testOrderId);
        if (items.isEmpty()) {
            System.out.println("❌ Không có món nào trong đơn hàng này!");
        } else {
            double total = 0;
            for (OrderItem item : items) {
                double subTotal = item.getPrice() * item.getQuantity();
                total += subTotal;
                System.out.printf("• %s | SL: %d | Giá: %.0f | Thành tiền: %.0f%n",
                        item.getNote(), item.getQuantity(), item.getPrice(), subTotal);
            }
            System.out.println("--------------------------------------");
            System.out.printf("✅ Tổng cộng tính lại: %.0f%n", total);
        }
    }
<<<<<<< HEAD
=======
    
    public long createOrGetActiveOrder(int tableId, String customerId) {
        String find = "SELECT order_id FROM Orders WHERE table_id = ? AND status = 'IN_PROGRESS'";
        String insert = """
            INSERT INTO Orders (table_id, customer_id, created_at, amount, status, order_type)
            VALUES (?, ?, SYSDATETIME(), 0, 'IN_PROGRESS', 'DINE_IN')
        """;
        try (PreparedStatement ps = connection.prepareStatement(find)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong("order_id");
            }
            try (PreparedStatement ins = connection.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, tableId);
                ins.setString(2, customerId);
                ins.executeUpdate();
                ResultSet keys = ins.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("[DB] createOrGetActiveOrder() failed: " + e.getMessage());
        }
        return -1;
    }

    public boolean addItemToOrder(long orderId, int menuItemId, int quantity) {
        String sql = """
            INSERT INTO OrderItems (order_id, menu_item_id, quantity, price, created_at)
            SELECT ?, ?, ?, price, SYSDATETIME()
            FROM MenuItem WHERE id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setInt(2, menuItemId);
            ps.setInt(3, quantity);
            ps.setInt(4, menuItemId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("[DB] addItemToOrder() failed: " + e.getMessage());
        }
        return false;
    }

    public List<OrderItem> getOrderHistoryByTable(int tableId) {
        List<OrderItem> list = new ArrayList<>();

        String sql = """
            SELECT 
                oi.id AS item_id,
                oi.order_id,
                oi.menu_item_id,
                mi.name AS menu_name,
                oi.quantity,
                oi.price,
                oi.note,
                oi.created_at
            FROM OrderItems oi
            JOIN Orders o ON oi.order_id = o.order_id
            JOIN MenuItem mi ON oi.menu_item_id = mi.id
            WHERE o.table_id = ?
            ORDER BY oi.created_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getLong("item_id"));
                item.setOrderId(rs.getLong("order_id"));
                item.setMenuItemId(rs.getInt("menu_item_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setNote(rs.getString("menu_name")); // 🟢 Ghi tên món vào note
                item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(item);
            }

        } catch (SQLException e) {
            System.out.println("[DB] getOrderHistoryByTable() failed: " + e.getMessage());
        }

        return list;
    }

    // 🔵 Tạo order mới cho bàn (walk-in)
    public boolean createOrderForTable(int tableId, int[] itemIds, int[] quantities) {
        String findReservation
                = "SELECT TOP 1 r.reservation_id FROM BookingTable bt JOIN Reservation r ON bt.reservation_id = r.reservation_id "
                + "WHERE bt.table_id = ? AND r.status = 'SEATED' ORDER BY r.reserved_at DESC";

        String insertOrder
                = "INSERT INTO Orders (reservation_id, table_id, customer_id, amount, status, created_at, order_type) "
                + "VALUES (?, ?, NULL, 0, 'IN_PROGRESS', GETDATE(), 'DINE_IN')";

        String insertItem
                = "INSERT INTO OrderItems (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            // 1️⃣ Tìm reservation hiện tại
            int reservationId = 0;
            PreparedStatement ps1 = connection.prepareStatement(findReservation);
            ps1.setInt(1, tableId);
            ResultSet rs = ps1.executeQuery();
            if (rs.next()) {
                reservationId = rs.getInt("reservation_id");
            }
            rs.close();
            ps1.close();

            if (reservationId == 0) {
                throw new SQLException("Không tìm thấy Reservation đang phục vụ cho bàn " + tableId);
            }

            // 2️⃣ Tạo đơn hàng mới
            PreparedStatement ps2 = connection.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            ps2.setInt(1, reservationId);
            ps2.setInt(2, tableId);
            ps2.executeUpdate();
            ResultSet keys = ps2.getGeneratedKeys();
            int orderId = 0;
            if (keys.next()) {
                orderId = keys.getInt(1);
            }
            keys.close();
            ps2.close();

            if (orderId == 0) {
                throw new SQLException("Không lấy được order_id");
            }

            // 3️⃣ Thêm từng món
            PreparedStatement ps3 = connection.prepareStatement(insertItem);
            double total = 0;
            for (int i = 0; i < itemIds.length; i++) {
                int itemId = itemIds[i];
                int qty = quantities[i];
                double price = getItemPrice(itemId);
                ps3.setInt(1, orderId);
                ps3.setInt(2, itemId);
                ps3.setInt(3, qty);
                ps3.setDouble(4, price);
                ps3.addBatch();
                total += price * qty;
            }
            ps3.executeBatch();
            ps3.close();

            PreparedStatement ps4 = connection.prepareStatement("UPDATE Orders SET amount = ? WHERE order_id = ?");
            ps4.setDouble(1, total);
            ps4.setInt(2, orderId);
            ps4.executeUpdate();
            ps4.close();

            connection.commit();
            connection.setAutoCommit(true);
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("[DB] createOrderForTable() failed: " + e.getMessage());
            return false;
        }
    }

    private double getItemPrice(int menuItemId) throws SQLException {
        String sql = "SELECT price - (price * discount / 100.0) AS price FROM MenuItem WHERE menu_item_id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, menuItemId);
        ResultSet rs = ps.executeQuery();
        double price = 0;
        if (rs.next()) {
            price = rs.getDouble("price");
        }
        rs.close();
        ps.close();
        return price;
    }

// 🔵 Tạo hoặc lấy order đang hoạt động cho bàn (staff - khách vãng lai)
    public long createOrGetActiveOrderForTable(int tableId) {
        String find = "SELECT order_id FROM Orders WHERE table_id = ? AND status = 'IN_PROGRESS'";
        String insert = """
        INSERT INTO Orders (table_id, created_at, amount, status, order_type)
        VALUES (?, SYSDATETIME(), 0, 'IN_PROGRESS', 'DINE_IN')
    """;

        try (PreparedStatement ps = connection.prepareStatement(find)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                long existingId = rs.getLong("order_id");
                System.out.println("[DB] ✅ Found existing IN_PROGRESS order for tableId=" + tableId + ", orderId=" + existingId);
                return existingId;
            }

            try (PreparedStatement ins = connection.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, tableId);
                ins.executeUpdate();
                ResultSet keys = ins.getGeneratedKeys();
                if (keys.next()) {
                    long newId = keys.getLong(1);
                    System.out.println("[DB] ✅ Created new IN_PROGRESS order for tableId=" + tableId + ", orderId=" + newId);
                    return newId;
                }
            }
        } catch (SQLException e) {
            System.out.println("[DB] ❌ createOrGetActiveOrderForTable() failed: " + e.getMessage());
        }

        return -1;
    }
    
    public List<String[]> getAllMenuItems2() {
        List<String[]> list = new ArrayList<>();
        String sql = """
        SELECT id, name, price
        FROM MenuItem
        WHERE is_active = 1
        ORDER BY category_id
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String[] item = new String[3];
                item[0] = rs.getString("id");     // id món
                item[1] = rs.getString("name");   // tên món
                item[2] = rs.getString("price");  // giá món
                list.add(item);
            }

        } catch (SQLException e) {
            System.out.println("[DB] getAllMenuItems() failed: " + e.getMessage());
        }

        return list;
    }
>>>>>>> LeThuUyen-Staff
}
