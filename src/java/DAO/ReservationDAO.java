package DAO;

import Models.Reservation;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ReservationDAO extends DBContext {

    // CHUẨN CỘT (không có reserved_at)
    private static final String COLS_BASE =
        " reservation_id, customer_id, reserved_date, session_code, " +
        " guest_count, status, note, created_at, updated_at ";

    /** PENDING mới nhất */
    public List<Reservation> findPending() {
        final String sql = "SELECT " + COLS_BASE +
                "FROM dbo.Reservation WHERE status = 'PENDING' ORDER BY created_at DESC";
        List<Reservation> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapSafe(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Reservation findById(long id) {
        final String sql = "SELECT " + COLS_BASE +
                "FROM dbo.Reservation WHERE reservation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSafe(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Xác nhận & gán bàn */
    public boolean approve(long reservationId, List<Integer> tableIds, String note) {
        final String sqlUpdate =
                "UPDATE dbo.Reservation " +
                "SET status='CONFIRMED', note=?, updated_at=SYSUTCDATETIME() " + // dùng UTC cho đồng bộ
                "WHERE reservation_id=? AND status='PENDING'";
        final String sqlInsertTable =
                "INSERT INTO dbo.BookingTable(reservation_id, table_id) VALUES(?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(sqlUpdate)) {
                ps.setString(1, note);
                ps.setLong(2, reservationId);
                ps.executeUpdate();
            }

            if (tableIds != null && !tableIds.isEmpty()) {
                try (PreparedStatement ps = connection.prepareStatement(sqlInsertTable)) {
                    for (Integer t : tableIds) {
                        ps.setLong(1, reservationId);
                        ps.setInt(2, t);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ignored) {}
        }
    }

    /** Hủy (không có rejection_reason trong DB) */
    public boolean cancel(long reservationId, String reasonNote) {
        final String sql =
                "UPDATE dbo.Reservation " +
                "SET status='CANCELLED', note=CONCAT(COALESCE(note,N''),' | CANCEL: ', ?), updated_at=SYSUTCDATETIME() " +
                "WHERE reservation_id=? AND status='PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reasonNote);
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /** Lấy danh sách theo userId (join Customer) */
    public List<Reservation> getReservationsByUserId(int userId) {
        final String sql = """
            SELECT r.reservation_id, r.customer_id, r.reserved_date, r.session_code,
                   r.guest_count, r.status, r.note, r.created_at, r.updated_at
            FROM dbo.Reservation r
            JOIN dbo.Customer c ON c.customer_id = r.customer_id
            WHERE c.user_id = ?
            ORDER BY r.created_at DESC
        """;
        List<Reservation> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSafe(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Tránh đặt trùng (cùng ngày + ca) */
    public boolean existsCustomerBookingSameSession(UUID customerId, Date reservedDate, String sessionCode) {
        final String sql = """
            SELECT 1
            FROM dbo.Reservation
            WHERE customer_id = ?
              AND reserved_date = ?
              AND session_code = ?
              AND status IN ('PENDING','CONFIRMED','SEATED')
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customerId.toString());
            ps.setDate(2, reservedDate);
            ps.setString(3, sessionCode);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { e.printStackTrace(); return true; }
    }

    /** Thêm mới (theo session_code) */
    public boolean addReservationSessionBased(Reservation r) {
        final String sql = """
            INSERT INTO dbo.Reservation
                (customer_id, reserved_date, session_code,
                 guest_count, status, note, created_at)
            VALUES (?, ?, ?, ?, ?, ?, SYSUTCDATETIME())
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getCustomerId() != null ? r.getCustomerId().toString() : null);
            ps.setDate(2, r.getReservedDate());
            ps.setString(3, r.getSessionCode());
            ps.setInt(4, r.getGuestCount());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countPending() {
        final String sql = "SELECT COUNT(*) FROM dbo.Reservation WHERE status='PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) { e.printStackTrace(); return -1; }
    }

    public String getCurrentDbName() {
        try (PreparedStatement ps = connection.prepareStatement("SELECT DB_NAME()");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getString(1) : "unknown";
        } catch (SQLException e) { e.printStackTrace(); return "unknown"; }
    }

    private Reservation mapSafe(ResultSet rs) {
        Reservation r = new Reservation();
        try { r.setReservationId(rs.getLong("reservation_id")); } catch (Exception ignore) {}
        try { 
            String cid = rs.getString("customer_id");
            r.setCustomerId(cid != null ? UUID.fromString(cid) : null);
        } catch (Exception ignore) {}
        try { r.setReservedDate(rs.getDate("reserved_date")); } catch (Exception ignore) {}
        try { r.setSessionCode(rs.getString("session_code")); } catch (Exception ignore) {}
        try { r.setGuestCount(rs.getInt("guest_count")); } catch (Exception ignore) {}
        try { r.setStatus(rs.getString("status")); } catch (Exception ignore) {}
        try { r.setNote(rs.getString("note")); } catch (Exception ignore) {}
        try { r.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception ignore) {}
        try { r.setUpdatedAt(rs.getTimestamp("updated_at")); } catch (Exception ignore) {}
        return r;
    }
}
