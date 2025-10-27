package DAO;

import Models.Reservation;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO extends DBContext {

    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO Reservation (customer_id, reserved_at, reserved_duration, guest_count, status, note, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
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

}
