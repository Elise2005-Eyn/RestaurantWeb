package Controllers.staff;

import DAO.StaffDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;


@WebServlet("/staff/dashboard")
public class StaffDashboardController extends HttpServlet {

    private final StaffDAO dao = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

 
        req.setAttribute("totalTables", dao.getTotalTables());
        req.setAttribute("totalOrders", dao.getTotalOrders());
        req.setAttribute("totalReservations", dao.getTotalReservations());
        req.setAttribute("totalCustomers", dao.getTotalCustomers());
        req.setAttribute("totalRevenue", dao.getTotalRevenue());
        req.setAttribute("activeBookings", dao.getActiveBookingsCount());

 
        req.setAttribute("reservationDetails", dao.getDetailedReservationCount());
        req.setAttribute("reservationStatus", dao.getReservationStatusCount());
        req.setAttribute("orderStatus", dao.getOrderStatusCount());
        req.setAttribute("paymentStatus", dao.getPaymentStatusCount());
        req.setAttribute("tableStatus", dao.getTableAvailabilityCount());


        req.setAttribute("topSellingItems", dao.getTopSellingMenuItems(5));   // Top 5 món bán chạy
        req.setAttribute("tableCountByArea", dao.getTableCountByArea());      // Số bàn theo khu vực


        req.getRequestDispatcher("/Views/staff/dashboard.jsp").forward(req, resp);
    }
}
