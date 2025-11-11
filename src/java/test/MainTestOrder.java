package test;

import DAO.OrderDAO;
import Models.OrderItem;
import java.util.List;

public class MainTestOrder {
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();

        int tableId = 1;                     // bàn tồn tại trong DB
        String customerId = "CUST001";       // có thể là ID hoặc mã khách hàng
        int menuItemId = 1;                  // ID món ăn tồn tại trong bảng dishes
        int quantity = 2;

        System.out.println("=== [TEST 1] Tạo hoặc lấy Order đang hoạt động cho bàn " + tableId + " ===");
        long orderId = dao.createOrGetActiveOrder(tableId, customerId);
        if (orderId > 0) {
            System.out.println("✅ Order hiện tại của bàn " + tableId + " là: " + orderId);
        } else {
            System.out.println("❌ Không thể tạo/lấy Order cho bàn " + tableId);
            return;
        }

        System.out.println("\n=== [TEST 2] Thêm món vào Order ===");
        boolean added = dao.addItemToOrder(orderId, menuItemId, quantity);
        if (added) {
            System.out.println("✅ Đã thêm món có ID = " + menuItemId + " (số lượng: " + quantity + ")");
        } else {
            System.out.println("❌ Thêm món thất bại. Kiểm tra ID món hoặc Order.");
        }

        System.out.println("\n=== [TEST 3] Lấy lịch sử đặt món của bàn ===");
        List<OrderItem> history = dao.getOrderHistoryByTable(tableId);
        if (history.isEmpty()) {
            System.out.println("❗ Không có lịch sử đặt món nào cho bàn " + tableId);
        } else {
            System.out.println("📜 Lịch sử đặt món:");
            for (OrderItem i : history) {
                System.out.printf("- Item #%d | Order #%d | Menu #%d | Qty: %d | Price: %.0f | Note: %s | Time: %s%n",
                        i.getId(), i.getOrderId(), i.getMenuItemId(),
                        i.getQuantity(), i.getPrice(),
                        i.getNote() != null ? i.getNote() : "(trống)",
                        i.getCreatedAt());
            }
        }

        System.out.println("\n=== ✅ Kết thúc kiểm thử 3 hàm ===");
    }
}
