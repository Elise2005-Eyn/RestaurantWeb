package DAO;

import Models.Reservation;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;


public class ReservationDAO extends DBContext {

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservation ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getString("reservation_id"));
                r.setCustomerId(rs.getString("customer_id"));
                r.setReservedAt(rs.getTimestamp("reserved_at"));
                r.setReservedDuration(rs.getInt("reserved_duration"));
                r.setGuestCount(rs.getInt("guest_count"));
                r.setStatus(rs.getString("status"));
                r.setNote(rs.getString("note"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách đặt bàn: " + e.getMessage());
        }

        return list;
    }

    public List<Reservation> getReservationsPaginated(int page, int pageSize) {
        List<Reservation> list = new ArrayList<>();
        String sql = """
                    SELECT r.*, c.full_name AS customer_name
                    FROM Reservation r
                    LEFT JOIN Customer c ON r.customer_id = c.customer_id
                    ORDER BY r.updated_at DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getString("reservation_id"));
                    r.setCustomerName(rs.getString("customer_name"));
                    Timestamp reservedAt = rs.getTimestamp("reserved_at");
                    r.setReservedAt(reservedAt);
                    r.setReservedAtFormatted(reservedAt.toLocalDateTime().format(
                            DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                    ));
                    r.setReservedDuration(rs.getInt("reserved_duration"));
                    r.setGuestCount(rs.getInt("guest_count"));
                    r.setStatus(rs.getString("status"));
                    r.setNote(rs.getString("note"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] Lỗi getReservationsPaginated: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO Reservation (customer_id, reserved_at, reserved_duration, guest_count, status, note, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getCustomerId());
            ps.setTimestamp(2, r.getReservedAt());
            ps.setInt(3, r.getReservedDuration());
            ps.setInt(4, r.getGuestCount());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("❌ Lỗi SQL khi thêm Reservation: " + e.getMessage());
            return false;
        }
    }

    public List<Reservation> getReservationsByUserId(int userId) {
        List<Reservation> list = new ArrayList<>();
        String sql = """
        SELECT r.*
        FROM Reservation r
        JOIN Customer c ON r.customer_id = c.customer_id
        WHERE c.user_id = ?
        ORDER BY r.created_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getString("reservation_id"));
                r.setCustomerId(rs.getString("customer_id"));
                r.setReservedAt(rs.getTimestamp("reserved_at"));
                r.setReservedDuration(rs.getInt("reserved_duration"));
                r.setGuestCount(rs.getInt("guest_count"));
                r.setStatus(rs.getString("status"));
                r.setNote(rs.getString("note"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách đặt bàn: " + e.getMessage());
        }

        return list;
    }

    public List<Reservation> getReservationsByStatus(String status, int page, int pageSize) {
        List<Reservation> list = new ArrayList<>();
        String sql = """
            SELECT r.*, c.full_name AS customer_name
            FROM Reservation r
            LEFT JOIN Customer c ON r.customer_id = c.customer_id
            WHERE r.status = ?
            ORDER BY r.updated_at DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getString("reservation_id"));
                    r.setCustomerName(rs.getString("customer_name"));
                    r.setReservedAt(rs.getTimestamp("reserved_at"));
                    r.setReservedDuration(rs.getInt("reserved_duration"));
                    r.setGuestCount(rs.getInt("guest_count"));
                    r.setStatus(rs.getString("status"));
                    r.setNote(rs.getString("note"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] Lỗi getReservationsPaginated: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalReservations() {
        String sql = "SELECT COUNT(*) AS total FROM Reservation";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] Lỗi đếm đặt bàn: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalReservationsByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM Reservation WHERE status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] Lỗi đếm đặt bàn: " + e.getMessage());
        }
        return 0;
    }

    public Map<String, Integer> getReservationStatusCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS total FROM Reservation GROUP BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] Lỗi getReservationStatusCount: " + e.getMessage());
        }
        return map;
    }

    public boolean overlapsForCustomer(String customerId, Timestamp newStart, Timestamp newEnd) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM Reservation r
        WHERE r.customer_id = ?
          AND CAST(r.reserved_at AS date) = CAST(? AS date)
          AND r.status IN ('PENDING','CONFIRMED')
          AND r.reserved_at < ?  -- existing.start < newEnd
          AND DATEADD(minute, r.reserved_duration, r.reserved_at) > ? -- existing.end > newStart
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ps.setTimestamp(2, newStart);
            ps.setTimestamp(3, newEnd);
            ps.setTimestamp(4, newStart);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi overlap (customer): " + e.getMessage());
            return true; // phòng thủ: coi như trùng
        }
    }

    public boolean updateReservationStatus(long reservationId, String newStatus) {
        String sql = "UPDATE Reservation SET status = ?, updated_at = SYSDATETIME() WHERE reservation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[ReservationDAO] ❌ Lỗi updateOrderStatus: " + e.getMessage());
        }
        return false;
    }

    /**
     * Kiểm tra xem đơn đặt bàn này đã được gán bàn chưa (trong BookingTable)
     */
    public boolean isReservationAssigned(long reservationId) {
        String sql = """
        SELECT COUNT(*) 
        FROM BookingTable         
        WHERE reservation_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("[TableDAO] ❌ Lỗi isTableCurrentlyAssigned: " + e.getMessage());
        }
        return false;
    }

    public Reservation getReservationsByReservationId(long reservationId) {
        Reservation reservation = new Reservation();
        String sql = """
        SELECT r.*, c.full_name AS customer_name
        FROM Reservation r
        JOIN Customer c ON r.customer_id = c.customer_id
        WHERE r.reservation_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getString("reservation_id"));
                r.setCustomerId(rs.getString("customer_id"));
                r.setCustomerName(rs.getString("customer_name"));
                //r.setReservedAt(rs.getTimestamp("reserved_at"));

                Timestamp reservedAt = rs.getTimestamp("reserved_at");
                r.setReservedAt(reservedAt);
                r.setReservedAtFormatted(reservedAt.toLocalDateTime().format(
                        DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                ));

                r.setReservedDuration(rs.getInt("reserved_duration"));
                r.setGuestCount(rs.getInt("guest_count"));
                r.setStatus(rs.getString("status"));
                r.setNote(rs.getString("note"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                return r;
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách đặt bàn: " + e.getMessage());
        }

        return null;
    }

    public List<Map<String, Object>> getTodayReservations(String status, Timestamp fromDate, Timestamp toDate, int page, int pageSize) {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """

            SELECT * 

            FROM [dbo].[Reservation] 

            WHERE [status] = ?

              AND [reserved_at] >= ? AND [reserved_at] <= ?

            ORDER BY [reserved_at] ASC

                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY

        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, status);

            ps.setTimestamp(2, fromDate);

            ps.setTimestamp(3, toDate);

            ps.setInt(4, (page - 1) * pageSize);

            ps.setInt(5, pageSize);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> r = new HashMap<>();

                    r.put("reservation_id", rs.getLong("reservation_id"));

                    //r.put("customer_name", rs.getString("customer_name"));
                    r.put("reserved_at", rs.getTimestamp("reserved_at"));

                    r.put("reserved_duration", rs.getInt("reserved_duration"));

                    r.put("guest_count", rs.getInt("guest_count"));

                    r.put("status", rs.getString("status"));

                    r.put("note", rs.getString("note"));

                    r.put("created_at", rs.getTimestamp("created_at"));

                    list.add(r);

                }

            }

        } catch (SQLException e) {

            System.out.println("[ReservationDAO] Lỗi getReservationsPaginated: " + e.getMessage());

            e.printStackTrace();

        }

        return list;

    }

    public int getTotalTodayReservations(String status, Timestamp fromDate, Timestamp toDate, int page, int pageSize) {

        String sql = """

            SELECT * 

            FROM [dbo].[Reservation] 

            WHERE [status] = ?

              AND [reserved_at] >= ? AND [reserved_at] <= ?

            ORDER BY [reserved_at] ASC

                     OFFSET ? ROWS FETCH NEXT ? ROWS ONLY

        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            ps.setString(1, status);

            ps.setTimestamp(2, fromDate);

            ps.setTimestamp(3, toDate);

            ps.setInt(4, (page - 1) * pageSize);

            ps.setInt(5, pageSize);

            if (rs.next()) {

                return rs.getInt("total");

            }

        } catch (SQLException e) {

            System.out.println("[ReservationDAO] Lỗi đếm đặt bàn: " + e.getMessage());

        }

        return 0;

    }
    
    public List<Map<String, Object>> getSeatedReservationWithTable() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT 
                                    r.reservation_id,
                                    c.full_name AS customer_name,
                                    r.customer_id,
                                    r.reserved_at,
                                    r.guest_count,
                                    r.status AS reservation_status,
                                    t.code AS table_code
                                FROM Reservation r
                                JOIN Customer c ON r.customer_id = c.customer_id
                                JOIN BookingTable bt ON r.reservation_id = bt.reservation_id
                                JOIN RestaurantTable t ON bt.table_id = t.table_id
                                WHERE r.status = 'SEATED'
                                GROUP BY r.reservation_id, c.full_name, r.customer_id, r.reserved_at, r.guest_count, r.status, t.code
                                ORDER BY r.reserved_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> r = new HashMap<>();
                //r.setReservationId(rs.getString("reservation_id"));
                //r.setCustomerId(rs.getString("customer_id"));
                //r.setCustomerName(rs.getString("customer_name"));
                r.put("reservation_id", rs.getLong("reservation_id"));
                //r.put("customer_id", rs.getString("customer_id"));                
                r.put("customer_name", rs.getString("customer_name"));
                Timestamp reservedAt = rs.getTimestamp("reserved_at");
                r.put("reserved_at", reservedAt);
                r.put("reserved_at_Formatted", reservedAt.toLocalDateTime().format(
                        DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy")
                ));
                r.put("guest_count", rs.getInt("guest_count"));
                r.put("table_code", rs.getString("table_code"));
                //r.setStatus(rs.getString("status"));
                //r.setNote(rs.getString("note"));
                //r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách đặt bàn: " + e.getMessage());
        }

        return list;
    }
    
    
 public Reservation getReservationDetail(long reservationId) {
    String sql = "SELECT r.reservation_id, r.reserved_at, r.guest_count, r.note, " +
                 "c.full_name AS customer_name, c.email AS customer_email " +
                 "FROM Reservation r " +
                 "JOIN Customer c ON r.customer_id = c.customer_id " +
                 "WHERE r.reservation_id = ?";

    try {
        DBContext db = new DBContext();
        Connection conn = db.connection;

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setLong(1, reservationId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Reservation r = new Reservation();

            // reservationId trong model đang là String → convert
            r.setReservationId(String.valueOf(rs.getLong("reservation_id")));

            Timestamp ts = rs.getTimestamp("reserved_at");
            r.setReservedAt(ts);   // dùng đúng kiểu Timestamp trong model

            // đồng thời set luôn dạng đã format để dùng cho JSP / email
            if (ts != null) {
                String formatted = new SimpleDateFormat("HH:mm dd/MM/yyyy").format(ts);
                r.setReservedAtFormatted(formatted);
            }

            r.setGuestCount(rs.getInt("guest_count"));
            r.setNote(rs.getString("note"));

            r.setCustomerName(rs.getString("customer_name"));
            r.setCustomerEmail(rs.getString("customer_email"));

            rs.close();
            ps.close();
            db.close();

            return r;
        }

        rs.close();
        ps.close();
        db.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

  public String getCustomerIdByReservationId(long reservationId) {
        String cId = null;
        String sql = """
        SELECT customer_id
        FROM Reservation
        WHERE reservation_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cId = rs.getString(1);
                return cId;
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy customer ID: " + e.getMessage());
        }

        return cId;
    }
}
