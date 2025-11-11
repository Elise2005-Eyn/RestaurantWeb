package DAO;

import Models.Dish;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class DishDAO extends DBContext {

    public List<Dish> getAllActiveDishes() {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.dishes WHERE status='active' ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Dish d = new Dish();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setPrice(rs.getDouble("price"));
                d.setCategory(rs.getString("category"));
                d.setImagePath(rs.getString("image_path"));
                list.add(d);
            }

        } catch (SQLException e) {
            System.out.println("[DAO] getAllActiveDishes() failed: " + e.getMessage());
        } finally {
            close();
        }

        return list;
    }

    public List<Dish> getTopDishes(int limit) {
        List<Dish> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM dbo.dishes WHERE status='active' ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Dish d = new Dish();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setPrice(rs.getDouble("price"));
                d.setCategory(rs.getString("category"));
                d.setImagePath(rs.getString("image_path"));
                list.add(d);
            }

        } catch (SQLException e) {
            System.out.println("[DAO] getTopDishes() failed: " + e.getMessage());
        } finally {
            close();
        }

        return list;
    }
    
    public List<Dish> getAllDishes() {
    List<Dish> list = new ArrayList<>();
    String sql = "SELECT id, name, description, price, imagePath FROM dishes";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Dish d = new Dish();
            d.setId(rs.getInt("id"));
            d.setName(rs.getString("name"));
            d.setDescription(rs.getString("description"));
            d.setPrice(rs.getDouble("price"));
            d.setImagePath(rs.getString("imagePath"));
            list.add(d);
        }
    } catch (SQLException e) {
        System.out.println(" Lỗi load dishes: " + e.getMessage());
    }
    return list;
}

}
