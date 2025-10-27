package DAO;

import Utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
}
