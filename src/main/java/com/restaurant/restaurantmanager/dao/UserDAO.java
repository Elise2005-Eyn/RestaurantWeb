package com.restaurant.restaurantmanager.dao;

import com.restaurant.restaurantmanager.model.User;
import com.restaurant.restaurantmanager.util.DBConnection;
import java.sql.*;

public class UserDAO {

    public User checkLogin(String username, String password) {
        String sql = """
            SELECT u.id, u.username, u.password, r.role_name, u.is_actived
            FROM Users u
            JOIN Role r ON u.role_id = r.role_id
            WHERE u.username = ? AND u.password = ? AND u.is_actived = 1
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role_name"),
                        rs.getBoolean("is_actived")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
