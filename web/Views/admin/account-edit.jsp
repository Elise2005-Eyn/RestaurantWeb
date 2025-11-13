<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật tài khoản</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #0c0c0c;
                color: #f5f5f5;
                padding: 60px 20px;
            }

            .container {
                background: #111;
                padding: 40px;
                border-radius: 12px;
                max-width: 600px;
                margin: auto;
                box-shadow: 0 0 30px rgba(255, 215, 0, 0.15);
                border: 1px solid rgba(255, 215, 0, 0.25);
            }

            h2 {
                text-align: center;
                color: #FFD700;
                margin-bottom: 25px;
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
            }

            label {
                display: block;
                margin-top: 14px;
                font-weight: 600;
                color: #FFD700;
                font-size: 14px;
            }

            input, select {
                width: 100%;
                padding: 10px;
                border: 1px solid rgba(255, 215, 0, 0.3);
                border-radius: 8px;
                background-color: #1a1a1a;
                color: #fff;
                font-size: 15px;
                margin-top: 6px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }

            input:focus, select:focus {
                outline: none;
                border-color: #FFD700;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
            }

            input::placeholder {
                color: #999;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            
            .btn {
                display: block;
                margin: 30px auto 0;
                background: #FFD700;
                color: #000;
                border: none;
                padding: 12px 22px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 15px;
                box-shadow: 0 0 12px rgba(255, 215, 0, 0.3);
                transition: background 0.3s, transform 0.2s;
            }

            .btn:hover {
                background: #ffea70;
                transform: scale(1.05);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.6);
            }

            .note {
                margin-top: 10px;
                font-size: 13px;
                color: #bbb;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Cập nhật tài khoản</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/accounts">
                <input type="hidden" name="action" value="saveEdit">
                <input type="hidden" name="id" value="${account.id}">
                <label>Tên đăng nhập</label><input type="text" name="username" value="${account.username}" required>
                <label>Email</label><input type="email" name="email" value="${account.email}" required>
                <label>Số điện thoại</label><input type="tel" name="phone" value="${account.telephone}" required>
                <label>Vai trò</label>
                <select name="role">
                    <option value="1" ${account.roleId == 1 ? "selected" : ""}>Admin</option>
                    <option value="2" ${account.roleId == 2 ? "selected" : ""}>Nhân viên</option>
                    <option value="3" ${account.roleId == 3 ? "selected" : ""}>Khách hàng</option>
                </select>
                <label><input type="checkbox" name="active" ${account.actived ? "checked" : ""}> Kích hoạt tài khoản</label>
                <button class="btn">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/accounts">Hủy</a>
            </form>
        </div>
    </body>
</html>
