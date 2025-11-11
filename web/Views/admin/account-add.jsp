<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm tài khoản</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #0e0e0e; /* Nền đen thuần */
                color: #f1f1f1; /* Chữ trắng */
                margin: 0;
                padding: 60px 20px;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                min-height: 100vh;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            .container {
                background: #1b1b1b; /* Khối form nền xám đậm */
                padding: 40px;
                margin-top: 100px;
                border-radius: 14px;
                max-width: 550px;
                width: 100%;
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.1); /* ánh vàng mờ */
                border: 1px solid rgba(255, 215, 0, 0.25); /* viền vàng nhẹ */
                animation: fadeIn 0.4s ease;
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

            h2 {
                color: #FFD700; /* vàng kim */
                text-align: center;
                font-size: 24px;
                margin-bottom: 25px;
                font-weight: 700;
                letter-spacing: 0.5px;
                text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }

            label {
                display: block;
                margin-top: 14px;
                font-weight: 600;
                color: #f1f1f1;
                font-size: 15px;
            }

            input, select {
                width: 100%;
                padding: 10px 12px;
                margin-top: 6px;
                background: #111; /* nền input đen */
                color: #fff;
                border: 1px solid #444;
                border-radius: 8px;
                font-size: 15px;
                transition: all 0.3s ease;
            }

            input:focus, select:focus {
                outline: none;
                border-color: #FFD700;
                box-shadow: 0 0 6px rgba(255, 215, 0, 0.4);
            }

            .form-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 30px;
            }

            .btn {
                background: linear-gradient(135deg, #FFD700, #ffb400); /* vàng kim ánh đồng */
                color: #000;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 600;
                transition: all 0.2s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
            }

            .cancel-link {
                color: #FFD700;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.2s;
            }

            .cancel-link:hover {
                color: #ffb400;
                text-shadow: 0 0 6px rgba(255, 215, 0, 0.4);
            }

            /* Hiệu ứng placeholder */
            input::placeholder {
                color: #888;
            }

            /* Viền và ánh sáng khi rê vào form */
            .container:hover {
                box-shadow: 0 0 25px rgba(255, 215, 0, 0.15);
            }
        </style>
    </head>

    <body>
        <div class="container">
            <h2>Thêm tài khoản mới</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/accounts">
                <input type="hidden" name="action" value="saveAdd">

                <label>Tên đăng nhập</label>
                <input type="text" name="username" required placeholder="Nhập tên đăng nhập...">

                <label>Email</label>
                <input type="email" name="email" required placeholder="Nhập email...">

                <label>Mật khẩu</label>
                <input type="password" name="password" required placeholder="Nhập mật khẩu...">

                <label>Số điện thoại</label>
                <input type="tel" name="phone" pattern="0[0-9]{9}" required placeholder="VD: 0912345678">

                <label>Vai trò</label>
                <select name="role">
                    <option value="1">Admin</option>
                    <option value="2">Nhân viên</option>
                    <option value="3">Khách hàng</option>
                </select>

                <div class="form-actions">
                    <button class="btn">Lưu</button>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="cancel-link">Hủy</a>
                </div>
            </form>
        </div>
    </body>
</html>
