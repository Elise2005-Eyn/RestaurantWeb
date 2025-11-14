/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Models.BookingTable;
import Models.RestaurantTable;
import Utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
public class BookingTableDAO extends DBContext{
    public boolean isAssignedSuccessful(long reservationId, int tableId){
        String sql = """
        INSERT INTO BookingTable (reservation_id, table_id)
                VALUES (?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            ps.setInt(2, tableId);
            int affectedRows = ps.executeUpdate();
            return affectedRows>0;
        } catch (SQLException e) {
            System.out.println("[BookingTableDAO] ❌ Lỗi isAssignedSuccessful " + e.getMessage());
        }
        return false;
    }
    
     public BookingTable getTableByReservationId(long reservationId){
        String sql = """
        SELECT * FROM BookingTable WHERE reservation_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingTable r = new BookingTable();
                r.setReservationId(reservationId);
                r.setTableId(rs.getInt("table_id"));
                return r;}
        } catch (SQLException e) {
            System.out.println("[BookingTableDAO] ❌ Lỗi isAssignedSuccessful " + e.getMessage());
        }
        return null;
    }
}
