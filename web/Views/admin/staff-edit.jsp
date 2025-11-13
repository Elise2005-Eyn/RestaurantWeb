<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa nhân viên</title>
        <style>
            :root {
                --primary-gold: #FFD700;
                --gold-hover: #ffea70;
                --bg-dark: #0c0c0c;
                --bg-panel: #1a1a1a;
                --text-light: #f5f5f5;
                --border-gold: rgba(255, 215, 0, 0.3);
            }

            body {
                background: var(--bg-dark);
                font-family: 'Segoe UI', Arial, sans-serif;
                padding: 40px;
                color: var(--text-light);
            }

            .container {
                background: var(--bg-panel);
                padding: 40px 30px; /* Tăng padding chút cho thoáng */
                border-radius: 10px;
                max-width: 600px;
                margin: auto;
                /* Đổi bóng đen sâu và thêm viền mờ vàng */
                box-shadow: 0 10px 30px rgba(0,0,0,0.7);
                border: 1px solid var(--border-gold);
            }

            h2 {
                text-align: center;
                color: var(--primary-gold);
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
            }

            label {
                display: block;
                margin-top: 15px;
                margin-bottom: 8px;
                font-weight: 700;
                color: var(--primary-gold);
                font-size: 13px;
                text-transform: uppercase;
            }

            /* Style cho các ô nhập liệu */
            input[type=text], input[type=email], input[type=tel] {
                width: 100%;
                padding: 12px 15px;
                /* Nền input tối hơn nền container để tạo độ sâu */
                background-color: #0a0a0a;
                border: 1px solid var(--border-gold);
                border-radius: 6px;
                color: #fff;
                outline: none;
                transition: all 0.3s ease;
                box-sizing: border-box; /* Quan trọng: Giữ input không bị tràn lề */
            }

            input:focus {
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            /* Checkbox styling cơ bản */
            .checkbox {
                margin-top: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: #ccc;
                font-size: 14px;
            }

            /* Nút Submit */
            .btn {
                display: block;
                width: 100%;
                margin-top: 30px;
                background-color: var(--primary-gold);
                color: #000;
                border: none;
                padding: 12px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 700;
                font-size: 16px;
                text-transform: uppercase;
                transition: 0.3s;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            .btn:hover {
                background-color: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            .error {
                color: #ff4d4d; /* Đỏ neon */
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
                text-shadow: 0 0 5px rgba(255, 77, 77, 0.4);
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Chỉnh sửa thông tin nhân viên</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                <input type="hidden" name="action" value="saveEdit">
                <input type="hidden" name="id" value="${staff.id}">

                <label>Tên đăng nhập:</label>
                <input type="text" name="username" value="${staff.username}" required>

                <label>Email:</label>
                <input type="email" name="email" value="${staff.email}" required>

                <label>Số điện thoại:</label>
                <input type="tel" name="phone" value="${staff.telephone}" pattern="0[0-9]{9}" maxlength="10" required>

                <div class="checkbox">
                    <input type="checkbox" name="active" ${staff.actived ? "checked" : ""}> Kích hoạt tài khoản
                </div>

                <button class="btn" type="submit">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/staff" style="margin-left:10px;">Hủy</a>

                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
            </form>
        </div>

    </body>
</html>
