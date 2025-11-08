/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Models.ReservationSession;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationSessionDAO extends DBContext {

    public List<ReservationSession> findActive() {
        String sql = """
            SELECT code, [name], start_time, end_time, is_active
            FROM dbo.ReservationSession
            WHERE is_active = 1
            ORDER BY CASE code
                       WHEN 'MORNING' THEN 1
                       WHEN 'LUNCH'   THEN 2
                       WHEN 'TEA'     THEN 3
                       WHEN 'DINNER'  THEN 4
                       WHEN 'EVENING' THEN 5
                       ELSE 99
                     END
        """;
        List<ReservationSession> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ReservationSession findByCode(String code) {
        String sql = "SELECT code, [name], start_time, end_time, is_active FROM dbo.ReservationSession WHERE code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private ReservationSession map(ResultSet rs) throws SQLException {
        ReservationSession s = new ReservationSession();
        s.setCode(rs.getString("code"));
        s.setName(rs.getNString("name"));
        s.setStartTime(rs.getTime("start_time").toLocalTime());
        s.setEndTime(rs.getTime("end_time").toLocalTime());
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }
}
