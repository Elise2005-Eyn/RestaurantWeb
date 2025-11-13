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
                background-color: #000; /* Nền đen */
                color: #fff;
                margin: 0;
                padding: 70px; /* đẩy nội dung xuống dưới header cố định */
            }

            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            h1 {
                color: #FFD700; /* vàng ánh kim */
                font-size: 28px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 30px;
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
            }

            form {
                background: #111; /* đen đậm hơn nền */
                padding: 40px 50px;
                max-width: 750px;
                border-radius: 14px;
                box-shadow: 0 0 25px rgba(255, 215, 0, 0.15);
                border: 1px solid rgba(255, 215, 0, 0.2);
                margin: 0 auto;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #FFD700;
                margin-bottom: 8px;
                font-size: 15px;
            }

            input[type="text"],
            input[type="number"],
            input[type="datetime-local"],
            textarea,
            select {
                width: 100%;
                padding: 10px 14px;
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 8px;
                background-color: #1a1a1a;
                color: #fff;
                font-size: 15px;
                transition: 0.25s;
                box-sizing: border-box;
            }

            input:focus,
            textarea:focus,
            select:focus {
                border-color: #FFD700;
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
                outline: none;
            }

            textarea {
                resize: vertical;
            }

            .required {
                color: #ff4c4c;
            }

            .form-buttons {
                margin-top: 30px;
                display: flex;
                gap: 12px;
                justify-content: flex-end;
            }

            .btn-save {
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                border: none;
                padding: 10px 22px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.25s ease;
            }

            .btn-save:hover {
                background: linear-gradient(90deg, #ffea00, #daa520);
                transform: translateY(-1px);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
            }

            .btn-back {
                background-color: transparent;
                color: #FFD700;
                padding: 10px 20px;
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 8px;
                text-decoration: none;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: all 0.25s ease;
            }

            .btn-back:hover {
                background-color: rgba(255, 215, 0, 0.1);
                border-color: #FFD700;
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
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
