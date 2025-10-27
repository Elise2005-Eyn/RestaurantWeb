package Controllers;

import DAO.MenuDAO;
import DAO.ReservationDAO;
import Models.Reservation;
import Models.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-reservations")
public class ViewReservationController extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect("auth");
            return;
        }

        List<Reservation> reservations = reservationDAO.getReservationsByUserId(user.getId());

        // 🔹 Chuyển note từ [Món #1: SL 2] sang "Phở bò (x2)"
        for (Reservation r : reservations) {
            String note = r.getNote();
            if (note != null && note.contains("[Món")) {
                StringBuilder display = new StringBuilder();
                String[] parts = note.split("\\[Món");
                for (String p : parts) {
                    if (p.contains(":")) {
                        try {
                            // Lấy ID món ăn
                            String idPart = p.substring(0, p.indexOf(":")).trim();
                            int menuId = Integer.parseInt(idPart.replace("#", "").trim());

                            // Lấy số lượng
                            String qty = p.substring(p.indexOf("SL") + 3, p.indexOf("]")).trim();

                            // Truy vấn tên món
                            String menuName = menuDAO.getMenuNameById(menuId);

                            display.append("🥢 ")
                                    .append(menuName)
                                    .append(" — SL: ")
                                    .append(qty)
                                    .append("\n");
                        } catch (Exception ignored) {
                        }
                    }
                }

                // Ghép lại phần note gốc + danh sách món
                String newNote = note.split("\\|")[0].trim()
                        + "\n-----------------\n"
                        + display.toString().trim();
                r.setNote(newNote);
            }
        }

        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/Views/reservation/my-reservations.jsp").forward(req, resp);
    }
}
