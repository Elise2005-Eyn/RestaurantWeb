/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Dish;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import util.DBUtil;

public class DishDao {
    private static final String SELECT_ALL  = "SELECT * FROM dishes ORDER BY id ASC";
    private static final String SELECT_BY_ID= "SELECT * FROM dishes WHERE id=?";
    private static final String INSERT_SQL  = "INSERT INTO dishes (name,description,price,category,image_path,status) VALUES (?,?,?,?,?,?)";
    private static final String UPDATE_SQL  = "UPDATE dishes SET name=?,description=?,price=?,category=?,image_path=?,status=? WHERE id=?";
    private static final String DELETE_SQL  = "DELETE FROM dishes WHERE id=?";
    // đay la chuc nang search
    private static final String SEARCH_SQL =
        "SELECT * FROM dishes " +
        "WHERE (name        COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? " +
        "   OR  category    COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ? " +
        "   OR  description COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?) " +
        "ORDER BY id DESC";
    public List<Dish> findAll() throws Exception {
        List<Dish> list = new ArrayList<>();
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Dish findById(int id) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public void create(Dish d) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, d.getName());
            ps.setString(2, d.getDescription());
            ps.setBigDecimal(3, d.getPrice());
            ps.setString(4, d.getCategory());
            ps.setString(5, d.getImagePath());
            ps.setString(6, d.getStatus() == null ? "active" : d.getStatus());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { if (k.next()) d.setId(k.getInt(1)); }
        }
    }

    public void update(Dish d) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, d.getName());
            ps.setString(2, d.getDescription());
            ps.setBigDecimal(3, d.getPrice());
            ps.setString(4, d.getCategory());
            ps.setString(5, d.getImagePath());
            ps.setString(6, d.getStatus());
            ps.setInt(7, d.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Dish map(ResultSet rs) throws SQLException {
        Dish d = new Dish();
        d.setId(rs.getInt("id"));
        d.setName(rs.getNString("name"));
        d.setDescription(rs.getNString("description"));
        d.setPrice(rs.getBigDecimal("price"));
        d.setCategory(rs.getNString("category"));
        d.setImagePath(rs.getString("image_path")); // filename only
        d.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) d.setCreatedAt(ts.toLocalDateTime());
        return d;
    }
    public List<Dish> search(String keyword) throws Exception {
    List<Dish> list = new ArrayList<>();
    if (keyword == null) keyword = "";
    String p = "%" + keyword.trim() + "%";
    try (Connection c = DBUtil.getConnection();
         PreparedStatement ps = c.prepareStatement(SEARCH_SQL)) {
        ps.setString(1, p);
        ps.setString(2, p);
        ps.setString(3, p);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
    }
    return list;
}
}
