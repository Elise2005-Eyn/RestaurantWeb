<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm tài khoản</title>
    <style>
        body { font-family: 'Segoe UI'; background: #f5f6fa; padding: 40px; }
        .container { background: white; padding: 30px; border-radius: 10px; max-width: 600px; margin: auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        label { display:block; margin-top:10px; font-weight:600; }
        input, select { width:100%; padding:8px; border:1px solid #ccc; border-radius:6px; }
        .btn { margin-top:20px; background:#6a11cb; color:white; border:none; padding:10px 18px; border-radius:6px; cursor:pointer; }
    </style>
</head>
<body>
<div class="container">
    <h2>Thêm tài khoản mới</h2>
    <form method="post" action="${pageContext.request.contextPath}/admin/accounts">
        <input type="hidden" name="action" value="saveAdd">
        <label>Tên đăng nhập</label><input type="text" name="username" required>
        <label>Email</label><input type="email" name="email" required>
        <label>Mật khẩu</label><input type="password" name="password" required>
        <label>Số điện thoại</label><input type="tel" name="phone" pattern="0[0-9]{9}" required>
        <label>Vai trò</label>
        <select name="role">
            <option value="1">Admin</option>
            <option value="2">Nhân viên</option>
            <option value="3">Khách hàng</option>
        </select>
        <button class="btn">Lưu</button>
        <a href="${pageContext.request.contextPath}/admin/accounts">Hủy</a>
    </form>
</div>
</body>
</html>
