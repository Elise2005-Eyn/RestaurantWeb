package DAO;

import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class OrderDAO extends DBContext {

    // Hàm đếm tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS total FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[OrderDAO] Lỗi đếm đơn hàng: " + e.getMessage());
        }
        return 0;
    }

    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> data = new LinkedHashMap<>();

        String sql = """
            SELECT 
                FORMAT(created_at, 'MM-yyyy') AS month_year,
                SUM(amount) AS total_revenue
            FROM Orders
            WHERE amount > 0
            GROUP BY FORMAT(created_at, 'MM-yyyy')
            ORDER BY MIN(created_at)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String month = rs.getString("month_year");
                double revenue = rs.getDouble("total_revenue");
                data.put(month, revenue);
                System.out.println("📊 Tháng " + month + " → " + revenue + " VND");
            }

        } catch (SQLException e) {
            System.out.println("[OrderDAO] ❌ Lỗi lấy doanh thu theo tháng: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("✅ Tổng số tháng có dữ liệu: " + data.size());
        return data;
    }

    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        Map<String, Double> test = dao.getMonthlyRevenue();
        System.out.println("Kết quả lấy doanh thu:");
        test.forEach((month, revenue)
                -> System.out.println(month + " → " + revenue)
        );
    }

public Map<String, Integer> getOrderStatusCount() {
    Map<String, Integer> map = new LinkedHashMap<>();
    String sql = """
        SELECT status, COUNT(*) AS total
        FROM Orders
        GROUP BY status
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            map.put(rs.getString("status"), rs.getInt("total"));
        }

    } catch (SQLException e) {
        System.out.println("[OrderDAO] ❌ Lỗi getOrderStatusCount: " + e.getMessage());
    }
    return map;
}


}
