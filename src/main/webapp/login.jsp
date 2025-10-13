<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Login</title></head>
<body>
<h2>Đăng nhập</h2>
<form action="login" method="post">
    <label>Tên đăng nhập:</label><br>
    <input type="text" name="username" required><br>
    <label>Mật khẩu:</label><br>
    <input type="password" name="password" required><br><br>
    <button type="submit">Đăng nhập</button>
</form>
<p style="color:red;">${error}</p>
</body>
</html>
