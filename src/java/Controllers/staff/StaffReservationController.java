/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.staff;

import DAO.ReservationDAO;
import Models.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffReservationController", urlPatterns = {"/staff/reservation_list"})
public class StaffReservationController extends HttpServlet {
<<<<<<< HEAD
    
=======

>>>>>>> LeThuUyen-Staff
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
<<<<<<< HEAD
                request.getRequestDispatcher("/Views/staff/order_add.jsp").forward(request, response);
                break;

            case "changeStatus":
                handleChangeStatus(request, response);
                break;

=======
                request.getRequestDispatcher("/Views/staff/reservation_add.jsp").forward(request, response);
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

>>>>>>> LeThuUyen-Staff
            case "detail":
                handleDetail(request, response);
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
        processRequest(request, response);
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

<<<<<<< HEAD
    private void handleChangeStatus(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
=======
    private void handleChangeStatus(HttpServletRequest request, HttpServletResponse response, String newStatus) throws IOException {
        try {
            long reservationId = Long.parseLong(request.getParameter("id"));

            boolean success = reservationDAO.updateReservationStatus(reservationId, newStatus);
            if (success) {
                request.getSession().setAttribute("successMsg", "Cập nhật trạng thái thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Không thể cập nhật trạng thái!");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/staff/reservation_list");
>>>>>>> LeThuUyen-Staff
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
        }
        int totalPages = (int) Math.ceil((double) totalReservations / pageSize);
        request.setAttribute("reservations", reservations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/Views/staff/reservation_list.jsp").forward(request, response);
    }

<<<<<<< HEAD
=======
    private void handlePayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        request.getRequestDispatcher("/Views/staff/invoice.jsp").forward(request, response);
    }

>>>>>>> LeThuUyen-Staff
}
