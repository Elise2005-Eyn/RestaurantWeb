/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.User;
import java.sql.*;
import java.time.LocalDateTime;
import util.DBUtil;

public class UserDao {

    private static final String INSERT_SQL =
        "INSERT INTO users (username,email,password_hash,full_name,phone,role,status,created_at) " +
        "VALUES (?,?,?,?,?,?,?,GETDATE())";

    private static final String FIND_BY_USERNAME =
        "SELECT * FROM users WHERE username = ?";

    private static final String FIND_BY_EMAIL =
        "SELECT * FROM users WHERE email = ?";

    public boolean existsByUsername(String username) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(FIND_BY_USERNAME)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public boolean existsByEmail(String email) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(FIND_BY_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public void create(User u) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getRole() == null ? "customer" : u.getRole());
            ps.setString(7, u.getStatus() == null ? "active" : u.getStatus());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) u.setId(keys.getInt(1));
            }
            u.setCreatedAt(LocalDateTime.now());
        }
    }

    public User findByUsername(String username) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(FIND_BY_USERNAME)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
                return u;
            }
        }
    }
 public User authenticatePlain(String username, String rawPassword) throws Exception {
    User u = findByUsername(username);
    if (u == null) return null;
    // Dùng password_hash cột hiện tại làm "mật khẩu lưu trữ"
    if (u.getPasswordHash() != null && u.getPasswordHash().equals(rawPassword)) {
        return u;
    }
    return null;
}
   
}
