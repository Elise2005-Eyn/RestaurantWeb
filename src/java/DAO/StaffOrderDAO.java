package DAO;

import Models.OrderItem;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffOrderDAO extends DBContext {

    /**
     * 🔹 Lấy hoặc tạo đơn đang mở (IN_PROGRESS) cho bàn cụ thể.
     * Không yêu cầu customer_id (dành cho khách vãng lai)
     */
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
                System.out.println("[StaffDAO] ✅ Found active order: " + existingId);
                return existingId;
            }

            try (PreparedStatement ins = connection.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, tableId);
                ins.executeUpdate();
                ResultSet keys = ins.getGeneratedKeys();
                if (keys.next()) {
                    long newId = keys.getLong(1);
                    System.out.println("[StaffDAO] ✅ Created new active order: " + newId);
                    return newId;
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] ❌ createOrGetActiveOrderForTable() failed: " + e.getMessage());
        }

        return -1;
    }

    /**
     * 🔹 Thêm món ăn vào order
     */
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

            int rows = ps.executeUpdate();
            System.out.println("[StaffDAO] ➕ addItemToOrder(): " + rows + " row(s) inserted");
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("[StaffDAO] ❌ addItemToOrder() failed: " + e.getMessage());
        }
        return false;
    }

    /**
     * 🔹 Lấy lịch sử order của bàn
     */
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
                item.setNote(rs.getString("menu_name"));
                item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(item);
            }

        } catch (SQLException e) {
            System.out.println("[StaffDAO] ❌ getOrderHistoryByTable() failed: " + e.getMessage());
        }

        return list;
    }

    /**
     * 🔹 Lấy danh sách món từ bảng MenuItem
     */
    public List<String[]> getAllMenuItems() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT id, name, price
            FROM MenuItem
            WHERE is_active = 1
            ORDER BY category_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String[] item = new String[3];
                item[0] = rs.getString("id");
                item[1] = rs.getString("name");
                item[2] = rs.getString("price");
                list.add(item);
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] ❌ getAllMenuItems() failed: " + e.getMessage());
        }
        return list;
    }
}
