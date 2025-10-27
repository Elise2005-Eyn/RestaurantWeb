package DAO;

import Utils.DBContext;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class StaffDAO extends DBContext {

    /**
     * Tổng số bàn
     */
    public int getTotalTables() {
        String sql = "SELECT COUNT(*) AS total FROM RestaurantTable";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm bàn: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng số đặt bàn
     */
    public int getTotalReservations() {
        String sql = "SELECT COUNT(*) AS total FROM Reservation";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đặt bàn: " + e.getMessage());
        }
        return 0;
    }

    public Map<String, Integer> getDetailedReservationCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS total FROM Reservation GROUP BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy thống kê chi tiết Reservation: " + e.getMessage());
        }
        return map;
    }

    /**
     * Tổng số đơn hàng
     */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS total FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đơn hàng: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Hàm chung để lấy thống kê theo trạng thái
     */
    private Map<String, Integer> getStatusCount(String table, String col) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT " + col + ", COUNT(*) AS total FROM " + table + " GROUP BY " + col;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(col), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi getStatusCount(" + table + "): " + e.getMessage());
        }
        return map;
    }

    public Map<String, Integer> getReservationStatusCount() {
        return getStatusCount("Reservation", "status");
    }

    public Map<String, Integer> getOrderStatusCount() {
        return getStatusCount("Orders", "status");
    }

    public Map<String, Integer> getPaymentStatusCount() {
        return getStatusCount("Payment", "status");
    }

    // Đếm số bàn theo trạng thái hoạt động
    public Map<String, Integer> getTableAvailabilityCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
        SELECT 
            CASE WHEN is_active = 1 THEN 'Còn bàn' ELSE 'Không khả dụng' END AS status,
            COUNT(*) AS total
        FROM RestaurantTable
        GROUP BY is_active
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi getTableAvailabilityCount: " + e.getMessage());
        }
        return map;
    }

}
