<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi hệ thống</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f8f9fa;
            text-align: center;
            padding-top: 120px;
            color: #555;
        }
        h1 {
            color: #dc3545;
            font-size: 38px;
            margin-bottom: 10px;
        }
        p {
            font-size: 18px;
            margin-bottom: 20px;
        }
        a {
            text-decoration: none;
            color: #007bff;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>⚠️ 404 - Trang không tồn tại</h1>
    <p>Rất tiếc, trang bạn yêu cầu không được tìm thấy.</p>
    <a href="${pageContext.request.contextPath}/home">⬅️ Quay về trang chủ</a>
</body>
</html>
