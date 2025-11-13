package test;

import DAO.TableDAO;
import java.util.List;
import java.util.Map;

public class TestTableDAO {
    public static void main(String[] args) {
        TableDAO dao = new TableDAO();

        System.out.println("===== ✅ TEST getTablesPaginated() =====");
        List<Map<String, Object>> tables = dao.getTablesPaginated(1, 5);
        if (tables.isEmpty()) {
            System.out.println("⚠️ Không có dữ liệu bàn nào!");
        } else {
            for (Map<String, Object> t : tables) {
                System.out.printf("ID: %s | Code: %s | Area: %s | Capacity: %s | Active: %s | Note: %s%n",
                        t.get("id"), t.get("code"), t.get("area_id"), t.get("capacity"), t.get("is_active"), t.get("note"));
            }
        }

        System.out.println("\n===== ✅ TEST getTotalTables() =====");
        int total = dao.getTotalTables();
        System.out.println("Tổng số bàn: " + total);

        System.out.println("\n===== ✅ TEST getTablesByStatus(true) (bàn đang hoạt động) =====");
        List<Map<String, Object>> activeTables = dao.getTablesByStatus(true, 1, 10);
        for (Map<String, Object> t : activeTables) {
            System.out.printf("ACTIVE -> %s | %s%n", t.get("code"), t.get("note"));
        }

        System.out.println("\n===== ✅ TEST getTablesByStatus(false) (bàn ngừng hoạt động) =====");
        List<Map<String, Object>> inactiveTables = dao.getTablesByStatus(false, 1, 10);
        for (Map<String, Object> t : inactiveTables) {
            System.out.printf("INACTIVE -> %s | %s%n", t.get("code"), t.get("note"));
        }

        System.out.println("\n===== ✅ TEST getTotalTablesByStatus(true/false) =====");
        System.out.println("Số bàn hoạt động: " + dao.getTotalTablesByStatus(true));
        System.out.println("Số bàn ngừng hoạt động: " + dao.getTotalTablesByStatus(false));

        System.out.println("\n===== ✅ TEST updateTableStatus() =====");
        int testTableId = 1; // 🔁 đổi ID phù hợp với DB của bạn
        boolean currentStatus = (boolean) tables.get(0).get("is_active");
        boolean newStatus = !currentStatus;
        System.out.printf("Đang đổi trạng thái bàn ID %d từ %s -> %s%n",
                testTableId, currentStatus, newStatus);

        boolean updated = dao.updateTableStatus(testTableId, newStatus);
        System.out.println(updated ? "✅ Cập nhật thành công!" : "❌ Cập nhật thất bại!");

        System.out.println("\n===== ✅ TEST getReservationHistoryByTable() =====");
        int tableIdToTest = 1; // 🔁 đổi ID cho bàn có lịch sử đặt
        List<Map<String, Object>> history = dao.getReservationHistoryByTable(tableIdToTest);
        if (history.isEmpty()) {
            System.out.println("⚠️ Không có lịch sử đặt bàn nào cho bàn ID " + tableIdToTest);
        } else {
            for (Map<String, Object> r : history) {
                System.out.printf(
                        "ReservationID: %s | Customer: %s | ReservedAt: %s | Duration: %s | Guests: %s | Status: %s | Note: %s%n",
                        r.get("reservation_id"), r.get("customer_name"), r.get("reserved_at"),
                        r.get("reserved_duration"), r.get("guest_count"), r.get("status"), r.get("note")
                );
            }
        }

        System.out.println("\n===== 🧾 TEST HOÀN TẤT =====");
    }
}
