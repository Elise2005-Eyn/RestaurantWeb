package DAO;

import Utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class CustomerDAO extends DBContext {

    public String getCustomerIdByUserId(int userId) {
        String sql = "SELECT customer_id FROM Customer WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("customer_id");
            }
        } catch (Exception e) {
            System.out.println(" Lỗi khi lấy customer_id: " + e.getMessage());
        }
        return null;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS total FROM Customer";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[CustomerDAO] Lỗi đếm khách hàng: " + e.getMessage());
        }
        return 0;
    }

    public Map<String, Integer> getCustomerStatusCount() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = """
        SELECT 
            CASE 
                WHEN u.is_actived = 1 THEN N'Active'
                ELSE N'Inactive'
            END AS status,
            COUNT(*) AS total
        FROM Customer c
        JOIN Users u ON c.user_id = u.id
        GROUP BY u.is_actived
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("total"));
            }

        } catch (SQLException e) {
            System.out.println("[CustomerDAO] ❌ Lỗi getCustomerStatusCount: " + e.getMessage());
        }
        return map;
    }

}
