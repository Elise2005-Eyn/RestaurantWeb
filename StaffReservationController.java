/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.staff;

import DAO.BookingTableDAO;
import DAO.ReservationDAO;
import DAO.TableDAO;
import Models.BookingTable;
import Models.Reservation;
import Models.RestaurantTable;
import Utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.Math.abs;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffReservationController", urlPatterns = {"/staff/reservation_list"})
public class StaffReservationController extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "add":
                request.getRequestDispatcher("/Views/staff/reservation_add.jsp").forward(request, response);
                break;
            case "todayReservation":
                showTodayReservation(request, response);
                break;

            case "confirm":
                handleChangeStatus(request, response, "CONFIRMED");
                break;

            case "cancel":
                handleChangeStatus(request, response, "CANCELLED");
                break;

            case "payment":
                handlePayment(request, response);
                break;

            case "assignTable":
                handleAssignTable(request, response);
                break;

            case "detail":
                handleDetail(request, response);
                break;

            case "checkin":
                handleCheckin(request, response);
                break;
            default:
                handleList(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("assignTable".equals(action)) {
            handleAssignTable(request, response);  // Gọi chung method
        }else if ("checkin".equals(action)) {
            handleCheckin(request, response); 
        }else{
            doGet(request, response);  // Fallback
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void handleChangeStatus(HttpServletRequest request, HttpServletResponse response, String newStatus) throws IOException {
        try {
            long reservationId = Long.parseLong(request.getParameter("id"));

            boolean success = reservationDAO.updateReservationStatus(reservationId, newStatus);
            if (success) {
                // ⭐ Nếu đổi sang CONFIRMED thì gửi email xác nhận cho khách
            if ("CONFIRMED".equalsIgnoreCase(newStatus)) {
                Reservation r = reservationDAO.getReservationDetail(reservationId);

                if (r != null && r.getCustomerEmail() != null && !r.getCustomerEmail().isEmpty()) {
                    try {
                        EmailUtils.sendReservationConfirmedEmail(
                                r.getCustomerEmail(),          // email khách
                                r.getCustomerName(),           // tên khách
                                reservationId,                 // mã đặt bàn
                                r.getReservedAtFormatted(),    // thời gian dùng bữa (đã format)
                                r.getGuestCount(),             // số khách
                                r.getNote()                    // ghi chú
                        );
                    } catch (Exception mailEx) {
                        mailEx.printStackTrace();
                        // không cần báo lỗi cho user, chỉ log, tránh văng flow
                    }
                }
            }              
                request.getSession().setAttribute("successMsg", "Cập nhật trạng thái thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Không thể cập nhật trạng thái!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }
        String status = request.getParameter("status");
        List<Reservation> reservations;
        int totalReservations;

        if (status != null && !status.isBlank()) {
            reservations = reservationDAO.getReservationsByStatus(status, page, pageSize);
            totalReservations = reservationDAO.getTotalReservationsByStatus(status);
            request.setAttribute("currentStatus", status);
        } else {
            reservations = reservationDAO.getReservationsPaginated(page, pageSize);
            totalReservations = reservationDAO.getTotalReservations();
            // Gắn thêm thuộc tính isAssigned cho từng reservation
            for (Reservation r : reservations) {
                boolean assigned = reservationDAO.isReservationAssigned(Long.parseLong(r.getReservationId()));
                r.setIsAssigned(assigned);
            }
        }
        int totalPages = (int) Math.ceil((double) totalReservations / pageSize);
        request.setAttribute("reservations", reservations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/Views/staff/reservation_list.jsp").forward(request, response);
    }

    private void handlePayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/Views/staff/invoice.jsp").forward(request, response);
    }

    TableDAO tableDAO = new TableDAO();
    BookingTableDAO btDAO = new BookingTableDAO();
    
    private void handleAssignTable(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tableIdParam = request.getParameter("tableId");  // Kiểm tra có tableId không
        String reservationIdParam = request.getParameter("id");  // Hoặc "reservationId" từ form JSP

        if (reservationIdParam == null || reservationIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy ID đặt bàn!");
            response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
            return;
        }

        long reservationId = Long.parseLong(reservationIdParam);  // Dùng long cho bigint
        Reservation reservation = reservationDAO.getReservationsByReservationId(reservationId);
        if (reservation == null) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy đặt bàn!");
            response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
            return;
        }

        // Check nếu đã assigned
        boolean isAssigned = reservationDAO.isReservationAssigned(reservationId);
        if (isAssigned) {
            request.getSession().setAttribute("errorMsg", "Đặt bàn đã được gán rồi!");
            response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
            return;
        }

        if (tableIdParam == null || tableIdParam.isEmpty()) {
            // Chưa chọn bàn → Hiển thị form
            List<Map<String, Object>> tables = tableDAO.getAvailableTables(reservationId);  // Giả sử method này đúng
            request.setAttribute("reservation", reservation);
            request.setAttribute("tables", tables);
            request.getRequestDispatcher("/Views/staff/table_assign.jsp").forward(request, response);
        } else {
            // Đã chọn bàn → Gán
            int tableId = Integer.parseInt(tableIdParam);
            // Insert vào BookingTable (giả sử method btDAO.assignTable(reservationId, tableId))
            boolean success = btDAO.isAssignedSuccessful(reservationId, tableId);  // Sửa tên method cho rõ
            if (success) {
                // Update status thành SEATED (tùy business logic)
                // reservationDAO.updateReservationStatus(reservationId, "SEATED");
                request.getSession().setAttribute("successMsg", "Gán bàn thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Gán bàn thất bại! (Bàn có thể không phù hợp)");
            }
            response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
        }
    }

    private void showTodayReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        Timestamp start = Timestamp.valueOf(startOfDay);
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        Timestamp end = Timestamp.valueOf(endOfDay);
        List<Map<String, Object>> todayReservations = reservationDAO.getTodayReservations("CONFIRMED", start, end, page, pageSize);
        int totalReservation = reservationDAO.getTotalTodayReservations("CONFIRMED", start, end, page, pageSize);

        int totalPages = (int) Math.ceil((double) totalReservation / pageSize);

        //req.setAttribute("tables", tables);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("todayReservations", todayReservations);

        request.getRequestDispatcher("/Views/staff/today_Reservation.jsp").forward(request, response);

    }

    private void handleCheckin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            long reservationId = Long.parseLong(request.getParameter("id"));
            if(reservationDAO.isReservationAssigned(reservationId)){
            boolean getTable = tableDAO.updateTableStatusByReservationId("OCCUPIED", reservationId);

            boolean success = reservationDAO.updateReservationStatus(reservationId, "SEATED");
            
            if (success && getTable) {
                request.getSession().setAttribute("successMsg", "Cập nhật trạng thái thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Không thể cập nhật trạng thái!");
            }
            }else{
                request.getSession().setAttribute("errorMsg", "Chưa được gán bàn!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/staff/reservation_list?action=todayReservation");
    }
}
