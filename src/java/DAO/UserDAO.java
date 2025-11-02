package DAO;

import Models.User;
import Utils.DBContext;

import java.sql.*;

public class UserDAO extends DBContext {

    // Kiểm tra đăng nhập
    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password = ? AND is_actived = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setTelephone(rs.getString("telephone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setActived(rs.getBoolean("is_actived"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println("[UserDAO] login error: " + e.getMessage());
        }
        return null;
    }

    // Kiểm tra email trùng
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("[UserDAO] emailExists error: " + e.getMessage());
            return false;
        }
    }

    public boolean register(User user) {
        // ✅ Ép role_id = 3 cho tất cả user đăng ký qua form
        int roleId = 3;

        String sqlInsertUser = "INSERT INTO dbo.Users (username, email, password, telephone, role_id, is_actived) "
                + "OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?, ?)";

        String sqlInsertCustomer = "INSERT INTO dbo.Customer (customer_id, user_id, full_name, phone_number, email, created_at) "
                + "VALUES (NEWID(), ?, ?, ?, ?, GETDATE())";

        try {
            connection.setAutoCommit(false);

            PreparedStatement psUser = connection.prepareStatement(sqlInsertUser);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getEmail());
            psUser.setString(3, user.getPassword());
            psUser.setString(4, user.getTelephone());
            psUser.setInt(5, roleId); // ✅ luôn là 3 (khách hàng)
            psUser.setBoolean(6, true);

            ResultSet rs = psUser.executeQuery();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt("id");
            }
            rs.close();
            psUser.close();

            if (userId == 0) {
                throw new SQLException("Không lấy được user_id sau khi insert vào Users (OUTPUT INSERTED.id).");
            }

            PreparedStatement psCustomer = connection.prepareStatement(sqlInsertCustomer);
            psCustomer.setInt(1, userId);
            psCustomer.setString(2, user.getUsername());
            psCustomer.setString(3, user.getTelephone());
            psCustomer.setString(4, user.getEmail());
            psCustomer.executeUpdate();
            psCustomer.close();

            connection.commit();
            connection.setAutoCommit(true);

            System.out.println("✅ Đăng ký user (role_id=3) + customer thành công! (UserID: " + userId + ")");
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.err.println("⚠️ Rollback thất bại: " + ex.getMessage());
            }
            System.err.println("❌ Lỗi khi đăng ký user/customer: " + e.getMessage());
            return false;

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setTelephone(rs.getString("telephone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setActived(rs.getBoolean("is_actived"));
                u.setPhotoUrl(rs.getString("photo_url"));
                try {
                    u.setFirstName(rs.getString("first_name"));
                    u.setLastName(rs.getString("last_name"));
                } catch (SQLException ignored) {
                }
                return u;
            }
        } catch (SQLException e) {
            System.out.println("[UserDAO] getUserById error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateProfile(User user, boolean changePassword) {
        String sql;

        if (changePassword) {
            sql = "UPDATE Users SET first_name=?, last_name=?, telephone=?, photo_url=?, password=?, modified_at=SYSDATETIME() WHERE id=?";
        } else {
            sql = "UPDATE Users SET first_name=?, last_name=?, telephone=?, photo_url=?, modified_at=SYSDATETIME() WHERE id=?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getTelephone());
            ps.setString(4, user.getPhotoUrl());

            if (changePassword) {
                ps.setString(5, user.getPassword());
                ps.setInt(6, user.getId());
            } else {
                ps.setInt(5, user.getId());
            }

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Cập nhật hồ sơ thành công cho user_id = " + user.getId());
                return true;
            }
        } catch (SQLException e) {
            System.out.println("[UserDAO] updateProfile error: " + e.getMessage());
        }
        return false;
    }

}
