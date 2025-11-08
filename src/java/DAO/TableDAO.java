package DAO;

import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class TableDAO extends DBContext {

    public List<Map<String, Object>> getTablesPaginated(int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT table_id, code, area_id, capacity, is_active, note
            FROM RestaurantTable
            ORDER BY table_id
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("id", rs.getInt("table_id"));
                t.put("code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesPaginated: " + e.getMessage());
        }
        return list;
    }

    public int getTotalTables() {
        String sql = "SELECT COUNT(*) FROM RestaurantTable";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTotalTables: " + e.getMessage());
        }
        return 0;
    }

    public boolean updateTableStatus(int tableId, boolean isActive) {
        String sql = "UPDATE RestaurantTable SET is_active = ? WHERE table_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, tableId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi updateTableStatus: " + e.getMessage());
            return false;
        }
    }

    public List<Map<String, Object>> getTablesByStatus(Boolean isActive, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT table_id, code, area_id, capacity, is_active, note
        FROM RestaurantTable
    """);

        if (isActive != null) {
            sql.append(" WHERE is_active = ? ");
        }
        sql.append(" ORDER BY table_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (isActive != null) {
                ps.setBoolean(index++, isActive);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("id", rs.getInt("table_id"));
                t.put("code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesByStatus: " + e.getMessage());
        }
        return list;
    }

    public int getTotalTablesByStatus(Boolean isActive) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM RestaurantTable");
        if (isActive != null) {
            sql.append(" WHERE is_active = ?");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (isActive != null) {
                ps.setBoolean(1, isActive);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTotalTablesByStatus: " + e.getMessage());
        }
        return 0;
    }

    public List<Map<String, Object>> getReservationHistoryByTable(int tableId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
            SELECT 
                r.reservation_id,
                c.full_name AS customer_name,
                r.customer_id,
                r.reserved_at,
                r.reserved_duration,
                r.guest_count,
                r.status,
                r.note,
                rt.code AS table_code
            FROM Reservation r
            JOIN Customer c ON r.customer_id = c.customer_id
            JOIN BookingTable b ON r.reservation_id = b.reservation_id
            JOIN RestaurantTable rt ON b.table_id = rt.table_id
            WHERE b.table_id = ?
            ORDER BY r.reserved_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("reservation_id", rs.getInt("reservation_id"));
                    row.put("customer_name", rs.getString("customer_name"));
                    row.put("customer_id", rs.getString("customer_id"));
                    row.put("reserved_at", rs.getTimestamp("reserved_at"));
                    row.put("reserved_duration", rs.getInt("reserved_duration"));
                    row.put("guest_count", rs.getInt("guest_count"));
                    row.put("status", rs.getString("status"));
                    row.put("note", rs.getString("note"));
                    row.put("table_code", rs.getString("table_code"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getReservationHistoryByTable: " + e.getMessage());
        }

        return list;
    }

    // ==================== GÁN BÀN CHO KHÁCH HÀNG ====================
    /**
     * Gán một bàn cho một khách hàng (thông qua Reservation). Bước 1: Tạo
     * reservation mới cho khách hàng. Bước 2: Gán bàn tương ứng vào bảng
     * BookingTable.
     */
   public boolean assignTableToCustomer(UUID customerId, int tableId, Timestamp reservedAt, 
                                     int duration, int guestCount, String note) {
    String sqlInsertReservation = """
        INSERT INTO Reservation (customer_id, reserved_at, reserved_duration, guest_count, status, note)
        VALUES (?, ?, ?, ?, 'CONFIRMED', ?)
    """;

    String sqlLink = """
        INSERT INTO BookingTable (reservation_id, table_id)
        VALUES (?, ?)
    """;

    try {
        connection.setAutoCommit(false);

        // 1️⃣ Thêm Reservation mới
        PreparedStatement ps1 = connection.prepareStatement(sqlInsertReservation, Statement.RETURN_GENERATED_KEYS);
        ps1.setObject(1, customerId); // UUID được truyền đúng kiểu
        ps1.setTimestamp(2, reservedAt);
        ps1.setInt(3, duration);
        ps1.setInt(4, guestCount);
        ps1.setString(5, note);
        ps1.executeUpdate();

        // Lấy reservation_id vừa tạo
        ResultSet rs = ps1.getGeneratedKeys();
        int reservationId = 0;
        if (rs.next()) reservationId = rs.getInt(1);

        // 2️⃣ Gán bàn cho đặt chỗ vừa tạo
        PreparedStatement ps2 = connection.prepareStatement(sqlLink);
        ps2.setInt(1, reservationId);
        ps2.setInt(2, tableId);
        ps2.executeUpdate();

        connection.commit();
        return true;
    } catch (SQLException e) {
        System.out.println("[TableDAO] ❌ assignTableToCustomer error: " + e.getMessage());
        try { connection.rollback(); } catch (SQLException ignored) {}
    } finally {
        try { connection.setAutoCommit(true); } catch (SQLException ignored) {}
    }
    return false;
}


    /**
     * Kiểm tra xem bàn hiện tại có đang được sử dụng (đã gán trong
     * BookingTable) hay chưa.
     */
    public boolean isTableCurrentlyAssigned(int tableId) {
        String sql = """
        SELECT COUNT(*) 
        FROM BookingTable b
        JOIN Reservation r ON b.reservation_id = r.reservation_id
        WHERE b.table_id = ? AND r.status IN ('CONFIRMED', 'PENDING')
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi isTableCurrentlyAssigned: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách khách hàng (để hiển thị dropdown chọn khi assign table).
     */
    public List<Map<String, Object>> getAllCustomers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT customer_id, full_name, email FROM Customer ORDER BY full_name";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> c = new HashMap<>();
                c.put("id", rs.getString("customer_id"));
                c.put("name", rs.getString("full_name"));
                c.put("email", rs.getString("email"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getAllCustomers: " + e.getMessage());
        }

        return list;
    }

}
