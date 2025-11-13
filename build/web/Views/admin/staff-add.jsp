<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm nhân viên mới</title>
        <style>
            body {
                background-color: #000;
                color: #fff;
                font-family: 'Segoe UI', Arial, sans-serif;
                padding: 100px 20px 40px; /* đẩy nội dung xuống dưới header cố định */
                margin: 0;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .container {
                background-color: #111;
                padding: 40px 50px;
                border-radius: 15px;
                max-width: 650px;
                margin: 0 auto;
                box-shadow: 0 0 25px rgba(255, 215, 0, 0.15);
                border: 1px solid rgba(255, 215, 0, 0.2);
            }

            h2 {
                text-align: center;
                color: #FFD700; /* vàng ánh kim */
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
                font-size: 26px;
                margin-bottom: 25px;
                font-weight: 700;
            }

            label {
                display: block;
                margin-top: 14px;
                font-weight: 600;
                color: #FFD700;
            }

            input[type="text"],
            input[type="email"],
            input[type="tel"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 8px;
                background-color: #1a1a1a;
                color: #fff;
                font-size: 15px;
                transition: 0.2s;
            }

            input:focus, select:focus {
                outline: none;
                border-color: #FFD700;
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
            }

            .btn {
                margin-top: 25px;
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                width: 100%;
                transition: all 0.25s ease;
            }

            .btn:hover {
                background: linear-gradient(90deg, #ffea00, #daa520);
                transform: translateY(-1px);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
            }

            .error {
                color: #ff4c4c;
                text-align: center;
                margin-top: 12px;
                font-weight: 500;
            }
        </style>

    </head>
    <body>

        <div class="container">
            <h2>Thêm nhân viên mới</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                <input type="hidden" name="action" value="saveAdd">

                <label>Tên đăng nhập:</label>
                <input type="text" name="username" required minlength="3">

                <label>Email:</label>
                <input type="email" name="email" required>

                <label>Số điện thoại:</label>
                <input type="tel" name="phone" pattern="0[0-9]{9}" maxlength="10" required>

                <div style="margin-top:10px;color:#666;">Mật khẩu mặc định: <b>123456</b></div>

                <button class="btn" type="submit">Lưu</button>
                <a href="${pageContext.request.contextPath}/admin/staff" style="margin-left:10px;">Hủy</a>

                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
            </form>
        </div>

    </body>
</html>
