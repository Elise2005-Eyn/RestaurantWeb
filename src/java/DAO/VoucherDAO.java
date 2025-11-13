package DAO;

import Models.Voucher;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBContext {

    // ✅ Lấy danh sách voucher có phân trang
    public List<Voucher> getVouchersByPage(int pageNumber, int pageSize) {
        List<Voucher> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Voucher
            ORDER BY created_at DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (pageNumber - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] getVouchersByPage lỗi: " + e.getMessage());
        }
        return list;
    }

    public int getTotalVouchers() {
        String sql = "SELECT COUNT(*) AS total FROM Voucher";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] getTotalVouchers lỗi: " + e.getMessage());
        }
        return 0;
    }

    // ✅ Tìm kiếm voucher theo nhiều tiêu chí
    public List<Voucher> searchVouchers(String keyword, Double minDiscount, Double maxDiscount, Boolean active) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Voucher WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND code LIKE ?");
            params.add("%" + keyword + "%");
        }
        if (minDiscount != null) {
            sql.append(" AND discount_percent >= ?");
            params.add(minDiscount);
        }
        if (maxDiscount != null) {
            sql.append(" AND discount_percent <= ?");
            params.add(maxDiscount);
        }
        if (active != null) {
            sql.append(" AND is_active = ?");
            params.add(active);
        }

        sql.append(" ORDER BY created_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] searchVouchers lỗi: " + e.getMessage());
        }
        return list;
    }

    // CRUD cơ bản
    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM Voucher WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] getVoucherById lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean addVoucher(Voucher v) {
        String sql = "INSERT INTO Voucher (code, description, discount_percent, start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setBigDecimal(3, v.getDiscountPercent());
            ps.setTimestamp(4, Timestamp.valueOf(v.getStartDate()));
            ps.setTimestamp(5, Timestamp.valueOf(v.getEndDate()));
            ps.setBoolean(6, v.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] addVoucher lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE Voucher SET code=?, description=?, discount_percent=?, start_date=?, end_date=?, is_active=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setBigDecimal(3, v.getDiscountPercent());
            ps.setTimestamp(4, Timestamp.valueOf(v.getStartDate()));
            ps.setTimestamp(5, Timestamp.valueOf(v.getEndDate()));
            ps.setBoolean(6, v.isActive());
            ps.setInt(7, v.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] updateVoucher lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM Voucher WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[VoucherDAO] deleteVoucher lỗi: " + e.getMessage());
        }
        return false;
    }

    // Helper để map dữ liệu
    private Voucher mapResultSet(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setId(rs.getInt("id"));
        v.setCode(rs.getString("code"));
        v.setDescription(rs.getString("description"));
        v.setDiscountPercent(rs.getBigDecimal("discount_percent"));
        v.setStartDate(rs.getTimestamp("start_date").toLocalDateTime());
        v.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
        v.setActive(rs.getBoolean("is_active"));
        return v;
    }
}
