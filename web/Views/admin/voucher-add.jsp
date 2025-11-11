<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Voucher mới</title>
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
                background: #fff;
                padding: 30px 40px;
                max-width: 700px;
                border-radius: 12px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #333;
                margin-bottom: 6px;
                font-size: 14px;
            }

            input[type="text"],
            input[type="number"],
            input[type="datetime-local"],
            textarea,
            select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
                transition: border-color 0.2s;
            }

            input:focus,
            textarea:focus,
            select:focus {
                border-color: #6a11cb;
                outline: none;
            }

            textarea {
                resize: vertical;
            }

            .form-buttons {
                margin-top: 25px;
                display: flex;
                gap: 10px;
            }

            .btn-save {
                background-color: #6a11cb;
                color: #fff;
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: 0.2s;
            }

            .btn-save:hover {
                background-color: #5012a0;
            }

            .btn-back {
                background-color: #ccc;
                color: #333;
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-weight: 500;
            }

            .btn-back:hover {
                background-color: #b3b3b3;
            }

            .required {
                color: #d00;
            }
        </style>
    </head>

    <body>

        <h1><i class="fa-solid fa-plus"></i> Thêm Voucher mới</h1>

        <form method="post" action="${pageContext.request.contextPath}/admin/voucher?action=add">
            <div class="form-group">
                <label>Mã voucher <span class="required">*</span></label>
                <input type="text" name="code" required>
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" rows="3"></textarea>
            </div>

            <div class="form-group">
                <label>Giảm giá (%) <span class="required">*</span></label>
                <input type="number" name="discount_percent" step="1" min="0" max="100" required>
            </div>

            <div class="form-group">
                <label>Ngày bắt đầu <span class="required">*</span></label>
                <input type="datetime-local" name="start_date" required>
            </div>

            <div class="form-group">
                <label>Ngày kết thúc <span class="required">*</span></label>
                <input type="datetime-local" name="end_date" required>
            </div>

            <div class="form-group">
                <label>Trạng thái hiển thị</label>
                <select name="is_active">
                    <option value="true" selected>Hiển thị</option>
                    <option value="false">Ẩn</option>
                </select>
            </div>

            <div class="form-buttons">
                <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu voucher
                </button>
                <a href="${pageContext.request.contextPath}/admin/voucher?action=list" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </form>

    </body>
</html>
