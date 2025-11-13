<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa Voucher</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #000;
                color: #fff;
                margin: 0;
                padding: 70px; /* tránh bị header che */
            }

            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            h1 {
                color: #FFD700;
                font-size: 28px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
                text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }

            form {
                background: #111;
                padding: 35px 45px;
                max-width: 700px;
                border-radius: 12px;
                margin: auto;
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.15);
                border: 1px solid rgba(255, 215, 0, 0.25);
                animation: fadeIn 0.5s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #FFD700;
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
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 6px;
                font-size: 14px;
                background-color: #1a1a1a;
                color: #fff;
                box-sizing: border-box;
                transition: 0.25s;
            }

            input:focus,
            textarea:focus,
            select:focus {
                border-color: #FFD700;
                box-shadow: 0 0 6px rgba(255, 215, 0, 0.5);
                outline: none;
            }

            textarea {
                resize: vertical;
                min-height: 90px;
            }

            .form-buttons {
                margin-top: 30px;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }

            /* --- Nút Lưu --- */
            .btn-save {
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                padding: 10px 22px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.25s;
            }

            .btn-save:hover {
                background: linear-gradient(90deg, #ffea00, #daa520);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
                transform: translateY(-1px);
            }

            /* --- Nút Quay lại --- */
            .btn-back {
                background-color: transparent;
                color: #FFD700;
                padding: 10px 20px;
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-weight: 500;
                transition: 0.25s;
            }

            .btn-back:hover {
                background-color: rgba(255, 215, 0, 0.1);
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }

            .required {
                color: #ff4c4c;
                margin-left: 2px;
            }
        </style>

    </head>

    <body>

        <h1><i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa Voucher</h1>

        <form method="post" action="${pageContext.request.contextPath}/admin/voucher?action=edit">
            <input type="hidden" name="id" value="${voucher.id}">

            <div class="form-group">
                <label>Mã voucher <span class="required">*</span></label>
                <input type="text" name="code" value="${voucher.code}" required>
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" rows="3">${voucher.description}</textarea>
            </div>

            <div class="form-group">
                <label>Giảm giá (%) <span class="required">*</span></label>
                <input type="number" name="discount_percent" step="1" min="0" max="100"
                       value="${voucher.discountPercent}" required>
            </div>

            <div class="form-group">
                <label>Ngày bắt đầu <span class="required">*</span></label>
                <input type="datetime-local" name="start_date" value="${voucher.startDate}" required>
            </div>

            <div class="form-group">
                <label>Ngày kết thúc <span class="required">*</span></label>
                <input type="datetime-local" name="end_date" value="${voucher.endDate}" required>
            </div>

            <div class="form-group">
                <label>Trạng thái hiển thị</label>
                <select name="is_active">
                    <option value="true" ${voucher.active ? 'selected' : ''}>Hiển thị</option>
                    <option value="false" ${!voucher.active ? 'selected' : ''}>Ẩn</option>
                </select>
            </div>

            <div class="form-buttons">
                <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Cập nhật
                </button>

                <a href="${pageContext.request.contextPath}/admin/voucher?action=list" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </form>

    </body>
</html>
