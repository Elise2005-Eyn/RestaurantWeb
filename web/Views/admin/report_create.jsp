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
            :root {
                --primary-gold: #FFD700;
                --gold-hover: #ffea70;
                --bg-dark: #0c0c0c;
                --bg-panel: #1a1a1a;
                --bg-input: #0a0a0a;   /* Nền input tối hơn */
                --text-light: #f5f5f5;
                --text-dim: #bbb;
                --border-gold: rgba(255, 215, 0, 0.3);
                --shadow-dark: rgba(0,0,0,0.5);
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
                margin: 0;
                padding: 70px;
            }

            h1 {
                color: var(--primary-gold);
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            /* Khung Form chính */
            form {
                background: var(--bg-panel);
                border-radius: 10px;
                padding: 30px 40px;
                /* Bóng đen sâu + Viền vàng mờ */
                box-shadow: 0 10px 30px var(--shadow-dark);
                border: 1px solid var(--border-gold);
                max-width: 700px;
            }

            .form-group {
                margin-bottom: 25px; /* Tăng khoảng cách chút cho thoáng */
            }

            label {
                display: block;
                font-weight: 700;
                margin-bottom: 10px;
                color: var(--primary-gold); /* Label màu vàng */
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            /* Style chung cho các ô nhập liệu */
            input[type="text"],
            input[type="date"],
            textarea,
            select,
            input[type="file"] {
                width: 100%;
                padding: 12px 15px;
                background-color: var(--bg-input);
                border: 1px solid var(--border-gold);
                border-radius: 6px;
                font-size: 14px;
                color: var(--text-light);
                outline: none;
                box-sizing: border-box; /* Giữ khung không bị tràn */
                transition: all 0.3s ease;
            }

            /* Hiệu ứng khi click vào ô nhập */
            input:focus, textarea:focus, select:focus {
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
                background-color: #151515;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
                line-height: 1.5;
            }

            /* Custom cho thẻ Select để mũi tên đẹp hơn (tùy trình duyệt) */
            select {
                cursor: pointer;
            }

            /* Nút Submit (Vàng) */
            .btn-submit {
                background-color: var(--primary-gold);
                color: #000; /* Chữ đen nền vàng */
                border: none;
                padding: 12px 25px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 700;
                font-size: 15px;
                text-transform: uppercase;
                transition: 0.3s;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
                margin-right: 10px;
            }

            .btn-submit:hover {
                background-color: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            /* Nút Quay lại (Xám tối/Trong suốt) */
            .btn-back {
                background-color: transparent;
                color: var(--text-dim);
                border: 1px solid #444;
                padding: 11px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                transition: 0.3s;
            }

            .btn-back:hover {
                background-color: #333;
                color: #fff;
                border-color: #666;
            }

            .file-note {
                font-size: 13px;
                color: #888;
                margin-top: 8px;
                font-style: italic;
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
