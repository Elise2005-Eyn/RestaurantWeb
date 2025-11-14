package DAO;

import Models.BookingTable;
import Models.RestaurantTable;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class TableDAO extends DBContext {

    public List<Map<String, Object>> getALLActiveTables() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT table_id, code, area_id, capacity, is_active, note, status
            FROM RestaurantTable 
            WHERE is_active = ? 
            ORDER BY table_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 1);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("id", rs.getInt("table_id"));
                t.put("code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                t.put("status", rs.getString("status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesPaginated: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getTablesPaginated(int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT table_id, code, area_id, capacity, is_active, note, status
            FROM RestaurantTable 
            WHERE is_active = ? 
            ORDER BY table_id
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 1);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("id", rs.getInt("table_id"));
                t.put("code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                t.put("status", rs.getString("status"));
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

    public boolean updateTableStatus(int tableId, String newStatus) {
        String sql = "UPDATE RestaurantTable SET status = ? WHERE table_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, tableId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi updateTableStatus: " + e.getMessage());
            return false;
        }
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
            if (rs.next()) {
                reservationId = rs.getInt(1);
            }

            // 2️⃣ Gán bàn cho đặt chỗ vừa tạo
            PreparedStatement ps2 = connection.prepareStatement(sqlLink);
            ps2.setInt(1, reservationId);
            ps2.setInt(2, tableId);
            ps2.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ assignTableToCustomer error: " + e.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
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

    public List<BookingTable> getAllBookingTables() {
        List<BookingTable> list = new ArrayList<>();
        String sql = """
        SELECT r.reservation_id, r.reserved_at, b.table_id
        FROM Reservation r
        INNER JOIN BookingTable b 
        ON r.reservation_id = b.reservation_id
        WHERE r.status IN ('CONFIRMED', 'SEATED');
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingTable b = new BookingTable();
                b.setReservationId(rs.getInt("reservation_id"));
                b.setTableId(rs.getInt("table_id"));
                b.setReservedAt(rs.getTimestamp("reserved_at"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesByStatus: " + e.getMessage());
        }
        return list;
    }

    public RestaurantTable getTablesById(int id) {
        String sql = "SELECT * FROM RestaurantTable WHERE table_id = ? ";

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaId(rs.getInt("area_id"));
                t.setCapacity(rs.getInt("capacity"));
                t.setIsActive(rs.getBoolean("is_active"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("status"));
                return t;
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesById: " + e.getMessage());
        }
        return null;
    }

    public List<RestaurantTable> getListActiveTables() {
        List<RestaurantTable> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM RestaurantTable 
            WHERE is_active = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 1);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaId(rs.getInt("area_id"));
                t.setCapacity(rs.getInt("capacity"));
                t.setIsActive(rs.getBoolean("is_active"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesPaginated: " + e.getMessage());
        }
        return list;
    }

    public List<RestaurantTable> getListTableByStatus(String status) {
        List<RestaurantTable> list = new ArrayList<>();
        String sql = """
            
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 1);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaId(rs.getInt("area_id"));
                t.setCapacity(rs.getInt("capacity"));
                t.setIsActive(rs.getBoolean("is_active"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesPaginated: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getTablesByStatus(String status) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
            SELECT table_id, code, area_id, capacity, is_active, note, status
            FROM RestaurantTable
            WHERE is_active = ? and status = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 1);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> t = new HashMap<>();
                    t.put("id", rs.getInt("table_id"));
                    t.put("code", rs.getString("code"));
                    t.put("area_id", rs.getInt("area_id"));
                    t.put("capacity", rs.getInt("capacity"));
                    t.put("is_active", rs.getBoolean("is_active"));
                    t.put("note", rs.getString("note"));
                    t.put("status", rs.getString("status"));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getReservationHistoryByTable: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getTablesByReservationId(long reservationId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT b.reservation_id, t.* FROM BookingTable b
            INNER JOIN RestaurantTable t 
            ON b.table_id = t.table_id
            WHERE reservation_id = ? 
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("table_id", rs.getInt("table_id"));
                t.put("table_code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                t.put("table_status", rs.getString("status"));
                t.put("reservation_id", rs.getString("reservation_id"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesById: " + e.getMessage());
        }
        return null;
    }

    public List<Map<String, Object>> getAvailableTables(long reservationId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
                     WITH reservation_info AS (
                             SELECT reserved_at, reserved_duration
                             FROM [dbo].[Reservation]
                             WHERE reservation_id = ?
                         )
                         SELECT 
                             rt.table_id,
                             rt.code,
                             rt.area_id,
                             rt.capacity,
                             rt.note,
                             rt.status
                         FROM [dbo].[RestaurantTable] rt
                         CROSS JOIN reservation_info ri
                         WHERE rt.is_active = 1
                             AND NOT EXISTS (
                                 SELECT 1 
                                 FROM [dbo].[BookingTable] bt
                                 INNER JOIN [dbo].[Reservation] res ON bt.reservation_id = res.reservation_id
                                 WHERE bt.table_id = rt.table_id
                                     AND res.status = 'confirmed'  -- Chỉ tính đặt chỗ confirmed; chỉnh sửa nếu cần
                                     -- Kiểm tra chồng chéo thời gian với khoảng cấm
                                     AND res.reserved_at < DATEADD(HOUR, 2, DATEADD(MINUTE, ri.reserved_duration, ri.reserved_at))
                                     AND DATEADD(MINUTE, res.reserved_duration, res.reserved_at) > DATEADD(HOUR, -2, ri.reserved_at)
                             )
                         ORDER BY rt.capacity ASC, rt.area_id ASC
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("table_id", rs.getInt("table_id"));
                t.put("table_code", rs.getString("code"));
                t.put("area_id", rs.getInt("area_id"));
                t.put("capacity", rs.getInt("capacity"));
                //t.put("is_active", rs.getBoolean("is_active"));
                t.put("note", rs.getString("note"));
                t.put("table_status", rs.getString("status"));
                //t.put("reservation_id", rs.getString("reservation_id"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesById: " + e.getMessage());
        }

        return list;
    }
 // ==================== METHOD MỚI: CHO MÀN TÌNH TRẠNG BÀN ====================

    /**
     * Lấy danh sách bàn với trạng thái computed tại thời điểm checkTime (null = hiện tại).
     * Status: 'AVAILABLE' nếu không có booking chồng chéo ±2h, 'RESERVED' nếu có.
     * Chỉ bàn is_active = 1.
     * Ngày hiện tại: November 13, 2025.
     */
    public List<Map<String, Object>> getTablesStatusAtTime(Timestamp checkTime) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (checkTime == null) {
            checkTime = new Timestamp(System.currentTimeMillis());  // Default hiện tại
        }

        String sql = """
            WITH time_info AS (
                SELECT ? AS check_time
            ),
            forbidden AS (
                SELECT DATEADD(HOUR, -2, check_time) AS start_check,
                       DATEADD(HOUR, 2, check_time) AS end_check
                FROM time_info
            )
            SELECT rt.table_id, rt.code, rt.area_id, rt.capacity, rt.note, rt.[status] AS original_status,
                   CASE 
                       WHEN EXISTS (
                           SELECT 1 FROM [dbo].[BookingTable] bt
                           INNER JOIN [dbo].[Reservation] res ON bt.reservation_id = res.reservation_id
                           CROSS JOIN forbidden f
                           WHERE bt.table_id = rt.table_id
                               AND res.[status] IN ('CONFIRMED', 'PENDING')
                               AND res.reserved_at < f.end_check
                               AND DATEADD(MINUTE, res.reserved_duration, res.reserved_at) > f.start_check
                       ) THEN 'RESERVED'
                       ELSE 'AVAILABLE'
                   END AS computed_status
            FROM [dbo].[RestaurantTable] rt
            CROSS JOIN forbidden f
            WHERE rt.is_active = 1
            ORDER BY rt.area_id ASC, rt.capacity ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, checkTime);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> t = new HashMap<>();
                    t.put("tableId", rs.getInt("table_id"));  // JSP dùng tableId
                    t.put("code", rs.getString("code"));
                    t.put("area_id", rs.getInt("area_id"));
                    t.put("capacity", rs.getInt("capacity"));
                    t.put("note", rs.getString("note"));
                    t.put("original_status", rs.getString("original_status"));
                    t.put("status", rs.getString("computed_status"));  // Dùng computed cho JSP
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getTablesStatusAtTime: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy reservation_id được gán cho bàn tại thời điểm checkTime (nếu có, ưu tiên gần nhất).
     * Dùng cho "Bắt đầu bữa" để update status SEATED.
     * Return null nếu không có.
     */
    public Long getReservationIdForTableAtTime(int tableId, Timestamp checkTime) {
        if (checkTime == null) {
            checkTime = new Timestamp(System.currentTimeMillis());
        }

        String sql = """
            SELECT TOP 1 res.reservation_id
            FROM [dbo].[BookingTable] bt
            INNER JOIN [dbo].[Reservation] res ON bt.reservation_id = res.reservation_id
            CROSS JOIN (SELECT ? AS check_time) t
            WHERE bt.table_id = ?
                AND res.[status] IN ('CONFIRMED', 'PENDING')
                AND res.reserved_at < DATEADD(HOUR, 2, t.check_time)
                AND DATEADD(MINUTE, res.reserved_duration, res.reserved_at) > DATEADD(HOUR, -2, t.check_time)
            ORDER BY res.reserved_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, checkTime);
            ps.setInt(2, tableId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("reservation_id");
                }
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi getReservationIdForTableAtTime: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateTableStatusByReservationId(String newStatus, long reservationId) {
        String sql = """
                     UPDATE t
                     SET t.status = ?
                     FROM RestaurantTable t
                     JOIN BookingTable bt ON t.table_id = bt.table_id
                     WHERE bt.reservation_id = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi updateTableStatusByReservationId: " + e.getMessage());
            return false;
        }
    }
    
}
