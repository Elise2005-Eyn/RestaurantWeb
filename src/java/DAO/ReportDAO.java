package DAO;

import Models.Report;
import Models.Report;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO extends DBContext {

    public List<Report> getAllReports() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT * FROM Reports ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Report r = mapResultSetToReport(rs);
                list.add(r);
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getAllReports error: " + e.getMessage());
        }
        return list;
    }

    public Report getReportById(int id) {
        String sql = "SELECT * FROM Reports WHERE report_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToReport(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getReportById error: " + e.getMessage());
        }
        return null;
    }

    public boolean createReport(Report report) {
        String sql = "INSERT INTO Reports (title, report_type, from_date, to_date, file_path, description, created_by, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, report.getTitle());
            ps.setString(2, report.getReportType());
            if (report.getFromDate() != null) {
                ps.setDate(3, Date.valueOf(report.getFromDate()));
            } else {
                ps.setNull(3, Types.DATE);
            }

            if (report.getToDate() != null) {
                ps.setDate(4, Date.valueOf(report.getToDate()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            ps.setString(5, report.getFilePath());
            ps.setString(6, report.getDescription());
            ps.setInt(7, report.getCreatedBy());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[ReportDAO] createReport error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateReport(Report report) {
        String sql = "UPDATE Reports SET title=?, report_type=?, from_date=?, to_date=?, file_path=?, description=?, updated_at=GETDATE() WHERE report_id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, report.getTitle());
            ps.setString(2, report.getReportType());
            ps.setDate(3, report.getFromDate() != null ? Date.valueOf(report.getFromDate()) : null);
            ps.setDate(4, report.getToDate() != null ? Date.valueOf(report.getToDate()) : null);
            ps.setString(5, report.getFilePath());
            ps.setString(6, report.getDescription());
            ps.setInt(7, report.getReportId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[ReportDAO] updateReport error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteReport(int id) {
        String sql = "DELETE FROM Reports WHERE report_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[ReportDAO] deleteReport error: " + e.getMessage());
        }
        return false;
    }

    private Report mapResultSetToReport(ResultSet rs) throws SQLException {
        Report r = new Report();
        r.setReportId(rs.getInt("report_id"));
        r.setTitle(rs.getString("title"));
        r.setReportType(rs.getString("report_type"));
        Date from = rs.getDate("from_date");
        Date to = rs.getDate("to_date");
        if (from != null) {
            r.setFromDate(from.toLocalDate());
        }
        if (to != null) {
            r.setToDate(to.toLocalDate());
        }
        r.setFilePath(rs.getString("file_path"));
        r.setDescription(rs.getString("description"));
        r.setCreatedBy(rs.getInt("created_by"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUpdatedAt(rs.getTimestamp("updated_at"));
        return r;
    }

    // Lấy danh sách các loại báo cáo (tự động sinh từ DB)
    public List<String> getDistinctReportTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT report_type FROM Reports WHERE report_type IS NOT NULL AND report_type <> '' ORDER BY report_type";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("report_type"));
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getDistinctReportTypes error: " + e.getMessage());
        }
        return types;
    }

// Lọc theo loại báo cáo
    public List<Report> getReportsByType(String reportType) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT * FROM Reports WHERE (? = '' OR report_type = ?) ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reportType);
            ps.setString(2, reportType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ReportDAO] getReportsByType error: " + e.getMessage());
        }
        return list;
    }

}
