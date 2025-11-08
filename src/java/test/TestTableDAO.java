package test;

import DAO.StaffDAO;
import Models.User;

public class TestTableDAO {
public static void main(String[] args) {
    StaffDAO dao = new StaffDAO();

    // ==============================
    // 🔹 Test thêm nhân viên mới
    // ==============================
    User newStaff = new User();
    newStaff.setUsername("staff_test");
    newStaff.setEmail("staff_test@example.com");
    newStaff.setPassword("123456"); // Mật khẩu mặc định
    newStaff.setTelephone("0909988776");
    newStaff.setPhotoUrl("uploads/default-avatar.png");

    boolean added = dao.addStaff(newStaff);

    if (added) {
        System.out.println("✅ Thêm nhân viên mới thành công!");
    } else {
        System.out.println("❌ Thêm nhân viên thất bại!");
    }

    // ==============================
    // 🔹 Kiểm tra lại danh sách nhân viên
    // ==============================
    int page = 1;
    int pageSize = 5;
    var list = dao.getStaffByPage(page, pageSize);

    System.out.println("\n=== DANH SÁCH NHÂN VIÊN (Trang 1) ===");
    for (var s : list) {
        System.out.printf("ID: %-3d | Username: %-15s | Email: %-25s | Phone: %-12s | Active: %s%n",
                s.getId(),
                s.getUsername(),
                s.getEmail(),
                s.getTelephone(),
                s.isActived() ? "✅" : "❌");
    }

    System.out.println("Tổng số nhân viên: " + dao.getTotalStaffCount());
}

}
