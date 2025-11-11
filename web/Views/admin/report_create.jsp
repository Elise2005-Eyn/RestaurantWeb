<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo Báo cáo mới</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #f5f6fa;
                margin: 0;
                padding: 40px 60px;
            }
            h1 {
                color: #4b0082;
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
            }
            form {
                background: white;
                border-radius: 10px;
                padding: 25px 30px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                max-width: 700px;
            }
            .form-group {
                margin-bottom: 18px;
            }
            label {
                display: block;
                font-weight: 600;
                margin-bottom: 6px;
                color: #333;
            }
            input[type="text"], input[type="date"], textarea, select, input[type="file"] {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }
            textarea {
                resize: vertical;
                min-height: 80px;
            }
            .btn-submit {
                background-color: #6a11cb;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
            }
            .btn-back {
                background-color: #ccc;
                color: #333;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                text-decoration: none;
            }
            .file-note {
                font-size: 13px;
                color: #777;
                margin-top: 4px;
            }
        </style>
    </head>

    <body>
        <h1><i class="fa-solid fa-plus"></i> Tạo Báo cáo mới</h1>

        <form method="post" action="${pageContext.request.contextPath}/admin/reports?action=create"
              enctype="multipart/form-data">

            <div class="form-group">
                <label for="title">Tiêu đề báo cáo</label>
                <input type="text" id="title" name="title" required>
            </div>

            <div class="form-group">
                <label for="reportType">Loại báo cáo</label>
                <select id="reportType" name="reportType" required>
                    <option value="">-- Chọn loại báo cáo --</option>
                    <option value="Doanh thu">Doanh thu</option>
                    <option value="Hoạt động nhân viên">Hoạt động nhân viên</option>
                    <option value="Khách hàng">Khách hàng</option>
                    <option value="Tùy chỉnh">Tùy chỉnh</option>
                </select>
            </div>

            <div class="form-group">
                <label for="fromDate">Từ ngày</label>
                <input type="date" id="fromDate" name="fromDate">
            </div>

            <div class="form-group">
                <label for="toDate">Đến ngày</label>
                <input type="date" id="toDate" name="toDate">
            </div>

            <div class="form-group">
                <label for="fileUpload">Tệp báo cáo (PDF / Excel / Word)</label>
                <input type="file" id="fileUpload" name="fileUpload" accept=".pdf,.xlsx,.xls,.doc,.docx,.csv">
                <div class="file-note">Bạn có thể chọn một tệp báo cáo từ máy tính của mình.</div>
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea id="description" name="description"></textarea>
            </div>

            <button type="submit" class="btn-submit"><i class="fa-solid fa-save"></i> Lưu báo cáo</button>
            <a href="${pageContext.request.contextPath}/admin/reports" class="btn-back">Quay lại</a>
        </form>

    </body>
</html>
