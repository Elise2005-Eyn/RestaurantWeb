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
                font-family: 'Segoe UI';
                background: #f5f6fa;
                padding: 40px;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                max-width: 600px;
                margin: auto;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            label {
                display:block;
                margin-top:10px;
                font-weight:600;
            }
            input, select {
                width:100%;
                padding:8px;
                border:1px solid #ccc;
                border-radius:6px;
            }
            .btn {
                margin-top:20px;
                background:#6a11cb;
                color:white;
                border:none;
                padding:10px 18px;
                border-radius:6px;
                cursor:pointer;
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
