package test;

import DAO.OrderDAO;
import java.util.List;
import java.util.Map;

public class TestGetAvailableTables {
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();

        System.out.println("===== TEST getAvailableTables() =====");

        List<Map<String, Object>> tables = dao.getAvailableTables();

        if (tables.isEmpty()) {
            System.out.println("⚠️ Không có bàn nào được trả về!");
        } else {
            for (Map<String, Object> t : tables) {
                System.out.println("----------------------------------------");
                System.out.println("Table ID  : " + t.get("id"));
                System.out.println("Label     : " + t.get("label"));
            }
        }
    }
}
