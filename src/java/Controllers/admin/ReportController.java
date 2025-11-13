package Controllers.admin;

import DAO.ReportDAO;
import Models.Report;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "ReportController", urlPatterns = {"/admin/reports"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class ReportController extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "delete":
                deleteReport(request, response);
                break;
            case "view":
                viewReport(request, response);
                break;
            default:
                listReports(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createReportWithFile(request, response);
                break;
            case "update":
                updateReport(request, response);
                break;
            default:
                listReports(request, response);
                break;
        }
    }

    private void listReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String typeFilter = request.getParameter("type");
            if (typeFilter == null) {
                typeFilter = "";
            }

            List<Report> reports = reportDAO.getReportsByType(typeFilter);
            List<String> types = reportDAO.getDistinctReportTypes();

            request.setAttribute("reports", reports);
            request.setAttribute("types", types);
            request.setAttribute("selectedType", typeFilter);

            RequestDispatcher rd = request.getRequestDispatcher("/Views/admin/report-list.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách báo cáo: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/Views/admin/report-list.jsp");
            rd.forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/Views/admin/report_create.jsp");
        rd.forward(request, response);
    }

    // ========== TẠO BÁO CÁO CÓ UPLOAD FILE ==========
    private void createReportWithFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            String title = request.getParameter("title");
            String reportType = request.getParameter("reportType");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String description = request.getParameter("description");

            // Lấy file upload
            Part filePart = request.getPart("fileUpload");
            String filePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/uploads/reports");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                File fileSave = new File(uploadDir, fileName);
                filePart.write(fileSave.getAbsolutePath());

                // Lưu đường dẫn tương đối
                filePath = "uploads/reports/" + fileName;
            }

            // Lấy user hiện tại (nếu có)
            HttpSession session = request.getSession(false);
            int createdBy = (session != null && session.getAttribute("USER_ID") != null)
                    ? (int) session.getAttribute("USER_ID")
                    : 0;

            Report report = new Report();
            report.setTitle(title);
            report.setReportType(reportType);
            if (fromDateStr != null && !fromDateStr.isBlank()) {
                report.setFromDate(LocalDate.parse(fromDateStr));
            }
            if (toDateStr != null && !toDateStr.isBlank()) {
                report.setToDate(LocalDate.parse(toDateStr));
            }
            report.setDescription(description);
            report.setFilePath(filePath);
            report.setCreatedBy(createdBy);

            boolean success = reportDAO.createReport(report);

            if (success) {
                request.getSession().setAttribute("flash", "✅ Tạo báo cáo mới thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/reports");
            } else {
                request.setAttribute("error", "Không thể tạo báo cáo, vui lòng thử lại.");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tạo báo cáo: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void viewReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Report report = reportDAO.getReportById(id);
            if (report == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo này.");
            } else {
                request.setAttribute("report", report);
            }
            RequestDispatcher rd = request.getRequestDispatcher("/Views/admin/report_view.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/reports");
        }
    }

    private void updateReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("reportId"));
            String title = request.getParameter("title");
            String type = request.getParameter("reportType");
            String description = request.getParameter("description");
            String filePath = request.getParameter("filePath");

            Report report = reportDAO.getReportById(id);
            if (report != null) {
                report.setTitle(title);
                report.setReportType(type);
                report.setDescription(description);
                report.setFilePath(filePath);

                boolean success = reportDAO.updateReport(report);
                if (success) {
                    request.getSession().setAttribute("flash", "Cập nhật báo cáo thành công!");
                } else {
                    request.getSession().setAttribute("flash", "Không thể cập nhật báo cáo.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/reports");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Lỗi khi cập nhật báo cáo.");
            response.sendRedirect(request.getContextPath() + "/admin/reports");
        }
    }

    private void deleteReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = reportDAO.deleteReport(id);
            if (success) {
                request.getSession().setAttribute("flash", "Đã xóa báo cáo thành công!");
            } else {
                request.getSession().setAttribute("flash", "Không thể xóa báo cáo.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Lỗi khi xóa báo cáo.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reports");
    }
}
