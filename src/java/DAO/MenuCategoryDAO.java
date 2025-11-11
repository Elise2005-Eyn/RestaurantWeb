package DAO;

import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO quản lý bảng MenuCategory
 */
public class MenuCategoryDAO extends DBContext {

    /**
     * Trả về Map<category_id, category_name>
     * Dùng để hiển thị tên danh mục thay vì ID trong menu-list.jsp
     */
    public Map<Integer, String> getCategoryMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        String sql = "SELECT id, name FROM MenuCategory ORDER BY id";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("id"), rs.getString("name"));
            }
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi khi lấy danh mục: " + e.getMessage());
        }
        return map;
    }

    /**
     * Lấy toàn bộ danh sách danh mục (dùng cho admin hoặc trang thêm món)
     */
    public List<String> getAllCategoryNames() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT name FROM MenuCategory ORDER BY id";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi getAllCategoryNames: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy tên danh mục theo ID
     */
    public String getCategoryNameById(int id) {
        String sql = "SELECT name FROM MenuCategory WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("name");
            }
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi getCategoryNameById: " + e.getMessage());
        }
        return "Không xác định";
    }

    /**
     * Thêm danh mục mới
     */
    public boolean addCategory(String name) {
        String sql = "INSERT INTO MenuCategory(name) VALUES (?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi addCategory: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cập nhật danh mục
     */
    public boolean updateCategory(int id, String name) {
        String sql = "UPDATE MenuCategory SET name = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi updateCategory: " + e.getMessage());
        }
        return false;
    }

    /**
     * Xóa danh mục
     */
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM MenuCategory WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[MenuCategoryDAO] Lỗi deleteCategory: " + e.getMessage());
        }
        return false;
    }
    
    
}
