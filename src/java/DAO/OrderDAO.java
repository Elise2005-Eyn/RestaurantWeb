package DAO;

import Models.Order;
import Models.OrderItem;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class OrderDAO extends DBContext {

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
            WHERE amount > 0
            GROUP BY FORMAT(created_at, 'MM-yyyy')
            ORDER BY MIN(created_at)
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
        LEFT JOIN Customer c ON o.customer_id = c.customer_idpublic List<Order> getOrdersPaginated(int page, int pageSize) {
                List<Order> list = new ArrayList<>();
                String sql = \"""
                SELECT o.*, c.full_name AS customer_name
                FROM Orders o
                LEFT JOIN Customer c ON o.customer_id = c.customer_id
                ORDER BY o.created_at DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            \""";
        
                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    ps.setInt(1, (page - 1) * pageSize);
                    ps.setInt(2, pageSize);
                    //DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
        
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Order o = new Order();
                            o.setOrderId(rs.getLong("order_id"));
                            o.setReservationId(rs.getLong("reservation_id"));
                            o.setTableId(rs.getInt("table_id"));
                            o.setCustomerName(rs.getString("customer_name")); // ✅ thêm trường mới
                            LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                            o.setCreatedAt(createdAt);
                            o.setCreatedAtFormatted(createdAt.format(
                                    DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                            ));
                            //o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
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
                    o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
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
                    map.put("created_at", rs.getTimestamp("created_at"));
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

}
