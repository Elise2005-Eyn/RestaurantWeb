package DAO;

import Utils.DBContext;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class StaffDAO extends DBContext {



    /** Tổng số bàn */
    public int getTotalTables() {
        String sql = "SELECT COUNT(*) AS total FROM RestaurantTable";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm bàn: " + e.getMessage());
        }
        return 0;
    }

    /** Tổng số đặt bàn */
    public int getTotalReservations() {
        String sql = "SELECT COUNT(*) AS total FROM Reservation";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đặt bàn: " + e.getMessage());
        }
        return 0;
    }

    /** Tổng số đơn hàng */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS total FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đơn hàng: " + e.getMessage());
        }
        return 0;
    }

    /** Tổng số khách hàng */
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS total FROM Customer";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm khách hàng: " + e.getMessage());
        }
        return 0;
    }

    /** Tổng doanh thu (chỉ tính các Payment đã thanh toán) */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) AS total FROM Payment WHERE status = 'PAID'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi tính tổng doanh thu: " + e.getMessage());
        }
        return 0.0;
    }

    /** Đếm đặt bàn đang hoạt động (qua view v_CurrentBookings) */
    public int getActiveBookingsCount() {
        String sql = "SELECT COUNT(*) AS total FROM v_CurrentBookings";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đặt bàn đang hoạt động: " + e.getMessage());
        }
        return 0;
    }

    /**
     * ==========================
     *  THỐNG KÊ THEO TRẠNG THÁI
     * ==========================
     */

    /** Thống kê chi tiết Reservation theo status */
    public Map<String, Integer> getDetailedReservationCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS total FROM Reservation GROUP BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy thống kê chi tiết Reservation: " + e.getMessage());
        }
        return map;
    }

    /** Hàm chung để lấy thống kê theo trạng thái */
    private Map<String, Integer> getStatusCount(String table, String col) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT " + col + ", COUNT(*) AS total FROM " + table + " GROUP BY " + col;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(col), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi getStatusCount(" + table + "): " + e.getMessage());
        }
        return map;
    }

    /** Thống kê trạng thái Reservation */
    public Map<String, Integer> getReservationStatusCount() {
        return getStatusCount("Reservation", "status");
    }

    /** Thống kê trạng thái Orders */
    public Map<String, Integer> getOrderStatusCount() {
        return getStatusCount("Orders", "status");
    }

    /** Thống kê trạng thái Payment */
    public Map<String, Integer> getPaymentStatusCount() {
        return getStatusCount("Payment", "status");
    }

    /** Đếm số bàn theo trạng thái hoạt động */
    public Map<String, Integer> getTableAvailabilityCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
            SELECT 
                CASE WHEN is_active = 1 THEN 'Còn bàn' ELSE 'Không khả dụng' END AS status,
                COUNT(*) AS total
            FROM RestaurantTable
            GROUP BY is_active
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi getTableAvailabilityCount: " + e.getMessage());
        }
        return map;
    }

    /**
     * ==========================
     *  THỐNG KÊ CHUYÊN SÂU
     * ==========================
     */

    /** Thống kê món bán chạy (Top N) */
    public Map<String, Integer> getTopSellingMenuItems(int limit) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
            SELECT TOP (?) mi.name, SUM(oi.quantity) AS total_sold
            FROM OrderItems oi
            JOIN MenuItem mi ON mi.id = oi.menu_item_id
            GROUP BY mi.name
            ORDER BY total_sold DESC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("name"), rs.getInt("total_sold"));
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy món bán chạy: " + e.getMessage());
        }
        return map;
    }

    /** Thống kê số bàn theo khu vực */
    public Map<String, Integer> getTableCountByArea() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
            SELECT a.name AS area_name, COUNT(t.table_id) AS total
            FROM TableArea a
            LEFT JOIN RestaurantTable t ON a.area_id = t.area_id
            GROUP BY a.name
            ORDER BY a.name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("area_name"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy thống kê bàn theo khu vực: " + e.getMessage());
        }
        return map;
    }
}
