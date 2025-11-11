package DAO;

import Models.User;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
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
     * Tổng số khách hàng
     */
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS total FROM Customer";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm khách hàng: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng doanh thu (chỉ tính các Payment đã thanh toán)
     */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) AS total FROM Payment WHERE status = 'PAID'";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi tính tổng doanh thu: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Đếm đặt bàn đang hoạt động (qua view v_CurrentBookings)
     */
    public int getActiveBookingsCount() {
        String sql = "SELECT COUNT(*) AS total FROM v_CurrentBookings";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm đặt bàn đang hoạt động: " + e.getMessage());
        }
        return 0;
    }

    /**
     * ========================== THỐNG KÊ THEO TRẠNG THÁI
     * ==========================
     */
    /**
     * Thống kê chi tiết Reservation theo status
     */
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

    /**
     * Thống kê trạng thái Reservation
     */
    public Map<String, Integer> getReservationStatusCount() {
        return getStatusCount("Reservation", "status");
    }

    /**
     * Thống kê trạng thái Orders
     */
    public Map<String, Integer> getOrderStatusCount() {
        return getStatusCount("Orders", "status");
    }

    /**
     * Thống kê trạng thái Payment
     */
    public Map<String, Integer> getPaymentStatusCount() {
        return getStatusCount("Payment", "status");
    }

    /**
     * Đếm số bàn theo trạng thái hoạt động
     */
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

    /**
     * ========================== THỐNG KÊ CHUYÊN SÂU ==========================
     */
    /**
     * Thống kê món bán chạy (Top N)
     */
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

    /**
     * Thống kê số bàn theo khu vực
     */
    public Map<String, Integer> getTableCountByArea() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
            SELECT a.name AS area_name, COUNT(t.table_id) AS total
            FROM TableArea a
            LEFT JOIN RestaurantTable t ON a.area_id = t.area_id
            GROUP BY a.name
            ORDER BY a.name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("area_name"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy thống kê bàn theo khu vực: " + e.getMessage());
        }
        return map;
    }

    // 🔹 Lấy danh sách nhân viên có phân trang
    public List<User> getStaffByPage(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT * FROM (
                SELECT ROW_NUMBER() OVER (ORDER BY id DESC) AS row_num, *
                FROM Users WHERE role_id = 2
            ) AS temp
            WHERE row_num BETWEEN ? AND ?
        """;

        int start = (page - 1) * pageSize + 1;
        int end = page * pageSize;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setTelephone(rs.getString("telephone"));
                    u.setActived(rs.getBoolean("is_actived"));

                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi phân trang nhân viên: " + e.getMessage());
        }
        return list;
    }

    // 🔹 Lấy tổng số nhân viên (để tính số trang)
    public int getTotalStaffCount() {
        String sql = "SELECT COUNT(*) FROM Users WHERE role_id = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi đếm tổng số nhân viên: " + e.getMessage());
        }
        return 0;
    }

    public boolean addStaff(User user) {
        // Kiểm tra email đã tồn tại chưa
        String checkEmailSQL = "SELECT COUNT(*) FROM Users WHERE email = ?";
        String insertSQL = """
        INSERT INTO Users (username, email, password, telephone, role_id, is_actived, photo_url)
        VALUES (?, ?, ?, ?, 2, 1, ?)
    """;

        try (PreparedStatement check = connection.prepareStatement(checkEmailSQL)) {
            check.setString(1, user.getEmail());
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.out.println("⚠️ Email đã tồn tại: " + user.getEmail());
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi kiểm tra email: " + e.getMessage());
            return false;
        }

        try (PreparedStatement ps = connection.prepareStatement(insertSQL)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getTelephone());
            ps.setString(5, user.getPhotoUrl());

            int rows = ps.executeUpdate();
            System.out.println(rows > 0 ? "✅ Đã thêm nhân viên: " + user.getUsername() : "❌ Thêm thất bại!");
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi thêm nhân viên: " + e.getMessage());
        }
        return false;
    }

    public User getStaffById(int id) {
        String sql = "SELECT * FROM Users WHERE id = ? AND role_id = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setTelephone(rs.getString("telephone"));
                    u.setActived(rs.getBoolean("is_actived"));

                    return u;
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi lấy nhân viên theo ID: " + e.getMessage());
        }
        return null;
    }

    public List<User> searchStaff(String keyword, String status, int page, int pageSize) {
        List<User> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT * FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY id DESC) AS row_num, *
            FROM Users
            WHERE role_id = 2
        """);

        // Bộ lọc từ khóa
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (username LIKE ? OR email LIKE ?) ");
        }

        // Bộ lọc trạng thái
        if ("active".equals(status)) {
            sql.append(" AND is_actived = 1 ");
        } else if ("inactive".equals(status)) {
            sql.append(" AND is_actived = 0 ");
        }

        sql.append(") AS temp WHERE row_num BETWEEN ? AND ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.isBlank()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }

            int start = (page - 1) * pageSize + 1;
            int end = start + pageSize - 1;
            ps.setInt(paramIndex++, start);
            ps.setInt(paramIndex, end);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setTelephone(rs.getString("telephone"));
                    u.setActived(rs.getBoolean("is_actived"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi searchStaff: " + e.getMessage());
        }
        return list;
    }

    public int countStaffByFilter(String keyword, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Users WHERE role_id = 2");

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (username LIKE ? OR email LIKE ?)");
        }
        if ("active".equals(status)) {
            sql.append(" AND is_actived = 1");
        } else if ("inactive".equals(status)) {
            sql.append(" AND is_actived = 0");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.isBlank()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex, "%" + keyword + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi countStaffByFilter: " + e.getMessage());
        }
        return 0;
    }

    public boolean updateStaff(User user) {
        String sql = """
        UPDATE Users
        SET username = ?, email = ?, telephone = ?, is_actived = ?, modified_at = GETDATE()
        WHERE id = ? AND role_id = 2
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getTelephone());
            ps.setBoolean(4, user.isActived());
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi updateStaff: " + e.getMessage());
            return false;
        }
    }

    public boolean banStaff(int id) {
        String sql = "UPDATE Users SET is_actived = 0, modified_at = GETDATE() WHERE id = ? AND role_id = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi banStaff: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM Users WHERE id = ? AND role_id = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[StaffDAO] Lỗi deleteStaff: " + e.getMessage());
            return false;
        }
    }

}
