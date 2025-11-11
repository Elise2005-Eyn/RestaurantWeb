package DAO;

import Models.RestaurantTable;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantTableDAO extends DBContext {

    // 🟢 Lấy danh sách bàn cho staff
    public List<RestaurantTable> getAllTablesForStaff() {
        List<RestaurantTable> list = new ArrayList<>();
        String sql =
                "SELECT t.table_id, t.code, a.name AS area_name, t.capacity, t.note, "
              + "CASE "
              + "    WHEN EXISTS ( "
              + "        SELECT 1 FROM BookingTable bt "
              + "        JOIN Reservation r ON bt.reservation_id = r.reservation_id "
              + "        WHERE bt.table_id = t.table_id AND r.status = 'SEATED' "
              + "    ) THEN 'SEATED' "
              + "    WHEN EXISTS ( "
              + "        SELECT 1 FROM BookingTable bt "
              + "        JOIN Reservation r ON bt.reservation_id = r.reservation_id "
              + "        WHERE bt.table_id = t.table_id AND r.status = 'CONFIRMED' "
              + "    ) THEN 'BOOKED' "
              + "    WHEN t.status = 'OCCUPIED' THEN 'OCCUPIED' "
              + "    WHEN t.is_active = 0 THEN 'INACTIVE' "
              + "    ELSE 'AVAILABLE' "
              + "END AS current_status "
              + "FROM RestaurantTable t "
              + "JOIN TableArea a ON t.area_id = a.area_id "
              + "ORDER BY t.table_id";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaName(rs.getString("area_name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("current_status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[DB] getAllTablesForStaff() failed: " + e.getMessage());
        }

        return list;
    }

    // 🟣 Lấy toàn bộ bàn (admin)
    public List<RestaurantTable> getAllTables() {
        List<RestaurantTable> tables = new ArrayList<>();
        String sql =
                "SELECT t.table_id, t.code, t.area_id, a.name AS areaName, "
              + "t.capacity, t.is_active, t.note, t.status "
              + "FROM RestaurantTable t "
              + "JOIN TableArea a ON t.area_id = a.area_id "
              + "ORDER BY t.table_id ASC";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaId(rs.getInt("area_id"));
                t.setAreaName(rs.getString("areaName"));
                t.setCapacity(rs.getInt("capacity"));
                t.setActive(rs.getBoolean("is_active"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("status"));
                tables.add(t);
            }
        } catch (SQLException e) {
            System.out.println("[DB] getAllTables() failed: " + e.getMessage());
        }

        return tables;
    }

    // 🟡 Cập nhật trạng thái bàn
    public boolean updateStatus(int id, String status) {
        String note;

        if ("OCCUPIED".equalsIgnoreCase(status)) {
            note = "Đang có khách vãng lai";
        } else if ("AVAILABLE".equalsIgnoreCase(status)) {
            note = "Không xác định";
        } else if ("INACTIVE".equalsIgnoreCase(status)) {
            note = "Không hoạt động";
        } else {
            note = "";
        }

        String sql = "UPDATE RestaurantTable SET status = ?, note = ? WHERE table_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, id);

            int rows = ps.executeUpdate();
            System.out.println("[DB] updateStatus(): " + rows + " rows affected.");
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("[DB] updateStatus() failed: " + e.getMessage());
            return false;
        }
    }

    // 🔵 Lấy thông tin chi tiết 1 bàn
    public RestaurantTable getTableById(int id) {
        String sql =
                "SELECT t.table_id, t.code, a.name AS area_name, t.capacity, "
              + "t.note, t.status, t.is_active "
              + "FROM RestaurantTable t "
              + "JOIN TableArea a ON t.area_id = a.area_id "
              + "WHERE t.table_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setTableId(rs.getInt("table_id"));
                t.setCode(rs.getString("code"));
                t.setAreaName(rs.getString("area_name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setNote(rs.getString("note"));
                t.setStatus(rs.getString("status"));
                t.setActive(rs.getBoolean("is_active"));
                return t;
            }
        } catch (SQLException e) {
            System.out.println("[DB] getTableById() failed: " + e.getMessage());
        }
        return null;
    }
    
  public boolean seatWalkInCustomer(int tableId) {
    String insertReservation =
        "INSERT INTO Reservation (customer_id, reserved_at, reserved_duration, guest_count, status, note, created_at) "
      + "VALUES (?, GETDATE(), 90, 2, 'SEATED', N'Khách vãng lai', GETDATE())";

    String insertBooking =
        "INSERT INTO BookingTable (reservation_id, table_id) VALUES (?, ?)";

    String updateTable =
        "UPDATE RestaurantTable SET status = 'OCCUPIED', note = N'Đang có khách vãng lai' WHERE table_id = ?";

    try {
        connection.setAutoCommit(false);

        // 1️⃣ Tạo Reservation mới
        PreparedStatement ps1 = connection.prepareStatement(insertReservation, Statement.RETURN_GENERATED_KEYS);
        ps1.setString(1, "7aaed135-1957-4d33-9dd4-1b7f7f83b770"); // customer vãng lai (hoặc null)
        ps1.executeUpdate();

        int reservationId = 0;
        ResultSet rs = ps1.getGeneratedKeys();
        if (rs.next()) {
            reservationId = rs.getInt(1);
        }
        rs.close();
        ps1.close();

        if (reservationId == 0) {
            throw new SQLException("Không lấy được reservation_id mới.");
        }

        // 2️⃣ Ghi BookingTable
        PreparedStatement ps2 = connection.prepareStatement(insertBooking);
        ps2.setInt(1, reservationId);
        ps2.setInt(2, tableId);
        ps2.executeUpdate();
        ps2.close();

        // 3️⃣ Update bàn
        PreparedStatement ps3 = connection.prepareStatement(updateTable);
        ps3.setInt(1, tableId);
        ps3.executeUpdate();
        ps3.close();

        connection.commit();
        connection.setAutoCommit(true);
        return true;
    } catch (SQLException e) {
        try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        System.out.println("[DB] seatWalkInCustomer() failed: " + e.getMessage());
        return false;
    }
}


// 🔴 Khi khách rời đi
public boolean releaseTable(int tableId) {
    String findReservation = 
        "SELECT TOP 1 r.reservation_id FROM Reservation r " +
        "JOIN BookingTable bt ON bt.reservation_id = r.reservation_id " +
        "WHERE bt.table_id = ? AND r.status = 'SEATED' " +
        "ORDER BY r.reserved_at DESC";

    String updateReservation = 
        "UPDATE Reservation SET status = 'COMPLETED', updated_at = GETDATE() WHERE reservation_id = ?";

    String updateTable = 
        "UPDATE RestaurantTable SET status = 'AVAILABLE', note = N'Không xác định' WHERE table_id = ?";

    try {
        connection.setAutoCommit(false);

        // 1️⃣ Lấy reservation hiện tại
        int reservationId = 0;
        PreparedStatement ps1 = connection.prepareStatement(findReservation);
        ps1.setInt(1, tableId);
        ResultSet rs = ps1.executeQuery();
        if (rs.next()) reservationId = rs.getInt("reservation_id");
        rs.close(); ps1.close();

        if (reservationId == 0) {
            System.out.println("[DB] No active reservation found for table " + tableId);
            connection.setAutoCommit(true);
            return false;
        }

        // 2️⃣ Cập nhật Reservation
        PreparedStatement ps2 = connection.prepareStatement(updateReservation);
        ps2.setInt(1, reservationId);
        ps2.executeUpdate();
        ps2.close();

        // 3️⃣ Cập nhật bàn
        PreparedStatement ps3 = connection.prepareStatement(updateTable);
        ps3.setInt(1, tableId);
        ps3.executeUpdate();
        ps3.close();

        connection.commit();
        connection.setAutoCommit(true);
        return true;
    } catch (SQLException e) {
        try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        System.out.println("[DB] releaseTable() failed: " + e.getMessage());
        return false;
    }
}

}
