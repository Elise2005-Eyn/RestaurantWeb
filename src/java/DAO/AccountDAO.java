package DAO;

import Models.User;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class AccountDAO extends DBContext {

    public List<User> getAccountsByPage(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT * FROM (
                SELECT ROW_NUMBER() OVER (ORDER BY id ASC) AS row_num, *
                FROM Users
            ) AS temp
            WHERE row_num BETWEEN ? AND ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int start = (page - 1) * pageSize + 1;
            int end = start + pageSize - 1;
            ps.setInt(1, start);
            ps.setInt(2, end);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setTelephone(rs.getString("telephone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setActived(rs.getBoolean("is_actived"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi getAccountsByPage: " + e.getMessage());
        }
        return list;
    }

    public int getTotalAccounts() {
        try (PreparedStatement ps = connection.prepareStatement("SELECT COUNT(*) FROM Users"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi getTotalAccounts: " + e.getMessage());
        }
        return 0;
    }

    public User getAccountById(int id) {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
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
            System.out.println("[AccountDAO] Lỗi getAccountById: " + e.getMessage());
        }
        return null;
    }

    public boolean addAccount(User u) {
        String sql = "INSERT INTO Users (username, email, password, telephone, role_id, is_actived, photo_url) VALUES (?, ?, ?, ?, ?, 1, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getTelephone());
            ps.setInt(5, u.getRoleId());
            ps.setString(6, u.getPhotoUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi addAccount: " + e.getMessage());
        }
        return false;
    }

    public boolean updateAccount(User u) {
        String sql = "UPDATE Users SET username=?, email=?, telephone=?, role_id=?, is_actived=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getTelephone());
            ps.setInt(4, u.getRoleId());
            ps.setBoolean(5, u.isActived());
            ps.setInt(6, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi updateAccount: " + e.getMessage());
        }
        return false;
    }

    public boolean banAccount(int id) {
        String sql = "UPDATE Users SET is_actived = 0 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi banAccount: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAccount(int id) {
        String sql = "DELETE FROM Users WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi deleteAccount: " + e.getMessage());
        }
        return false;
    }

    public List<User> searchAccounts(String username, String email, String role, String status, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE 1=1");

        if (username != null && !username.isBlank()) {
            sql.append(" AND username LIKE ?");
        }
        if (email != null && !email.isBlank()) {
            sql.append(" AND email LIKE ?");
        }
        if (role != null && !role.isBlank()) {
            sql.append(" AND role_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND is_actived = ").append(status.equals("active") ? 1 : 0);
        }

        sql.append(" ORDER BY id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (username != null && !username.isBlank()) {
                ps.setString(idx++, "%" + username + "%");
            }
            if (email != null && !email.isBlank()) {
                ps.setString(idx++, "%" + email + "%");
            }
            if (role != null && !role.isBlank()) {
                ps.setInt(idx++, Integer.parseInt(role));
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setTelephone(rs.getString("telephone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setActived(rs.getBoolean("is_actived"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi searchAccounts: " + e.getMessage());
        }
        return list;
    }

    public int countFilteredAccounts(String username, String email, String role, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Users WHERE 1=1");
        if (username != null && !username.isBlank()) {
            sql.append(" AND username LIKE ?");
        }
        if (email != null && !email.isBlank()) {
            sql.append(" AND email LIKE ?");
        }
        if (role != null && !role.isBlank()) {
            sql.append(" AND role_id = ?");
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND is_actived = ").append(status.equals("active") ? 1 : 0);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (username != null && !username.isBlank()) {
                ps.setString(idx++, "%" + username + "%");
            }
            if (email != null && !email.isBlank()) {
                ps.setString(idx++, "%" + email + "%");
            }
            if (role != null && !role.isBlank()) {
                ps.setInt(idx++, Integer.parseInt(role));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("[AccountDAO] Lỗi countFilteredAccounts: " + e.getMessage());
        }
        return 0;
    }

}
