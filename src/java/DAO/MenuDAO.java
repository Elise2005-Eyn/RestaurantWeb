package DAO;

import Models.MenuItem;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO extends DBContext {

    /**
     * Lấy danh sách tất cả món ăn đang active trong MenuItem
     */
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> menuList = new ArrayList<>();
        String sql = "SELECT id, name, description, price, discount_percent, category_id, " +
                     "inventory, image, is_active, code " +
                     "FROM MenuItem WHERE is_active = 1 ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setInventory(rs.getObject("inventory") != null ? rs.getInt("inventory") : null);
                item.setImage(rs.getString("image"));
                item.setActive(rs.getBoolean("is_active"));
                item.setCode(rs.getString("code"));
                menuList.add(item);
            }

        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi lấy danh sách món ăn: " + e.getMessage());
        }

        return menuList;
    }

    /**
     * Lấy danh sách món ăn theo category
     */
    public List<MenuItem> getMenuByCategory(int categoryId) {
        List<MenuItem> menuList = new ArrayList<>();
        String sql = "SELECT * FROM MenuItem WHERE category_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setInventory(rs.getObject("inventory") != null ? rs.getInt("inventory") : null);
                item.setImage(rs.getString("image"));
                item.setActive(rs.getBoolean("is_active"));
                item.setCode(rs.getString("code"));
                menuList.add(item);
            }

            rs.close();
        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi lấy món theo category: " + e.getMessage());
        }

        return menuList;
    }

    /**
     * Lấy chi tiết món ăn theo ID
     */
    public MenuItem getMenuItemById(int id) {
        MenuItem item = null;
        String sql = "SELECT * FROM MenuItem WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setInventory(rs.getObject("inventory") != null ? rs.getInt("inventory") : null);
                item.setImage(rs.getString("image"));
                item.setActive(rs.getBoolean("is_active"));
                item.setCode(rs.getString("code"));
            }

            rs.close();
        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi lấy chi tiết món ăn: " + e.getMessage());
        }

        return item;
    }

    /**
     * Thêm món ăn mới (dùng cho admin)
     */
    public boolean addMenuItem(MenuItem item) {
        String sql = "INSERT INTO MenuItem (name, description, price, discount_percent, category_id, inventory, image, is_active, code, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setBigDecimal(3, item.getPrice());
            ps.setBigDecimal(4, item.getDiscountPercent());
            ps.setInt(5, item.getCategoryId());
            if (item.getInventory() != null) {
                ps.setInt(6, item.getInventory());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, item.getImage());
            ps.setBoolean(8, item.isActive());
            ps.setString(9, item.getCode());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi thêm món ăn: " + e.getMessage());
            return false;
        }
    }

    /**
     * Cập nhật thông tin món ăn
     */
    public boolean updateMenuItem(MenuItem item) {
        String sql = "UPDATE MenuItem SET name=?, description=?, price=?, discount_percent=?, category_id=?, " +
                     "inventory=?, image=?, is_active=?, code=? WHERE id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setBigDecimal(3, item.getPrice());
            ps.setBigDecimal(4, item.getDiscountPercent());
            ps.setInt(5, item.getCategoryId());
            if (item.getInventory() != null) {
                ps.setInt(6, item.getInventory());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, item.getImage());
            ps.setBoolean(8, item.isActive());
            ps.setString(9, item.getCode());
            ps.setInt(10, item.getId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi cập nhật món ăn: " + e.getMessage());
            return false;
        }
    }

    /**
     * Xóa món ăn theo ID
     */
    public boolean deleteMenuItem(int id) {
        String sql = "DELETE FROM MenuItem WHERE id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[MenuDAO] Lỗi khi xóa món ăn: " + e.getMessage());
            return false;
        }
    }
}
