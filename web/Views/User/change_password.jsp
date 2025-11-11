<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đổi mật khẩu</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f8f9fa, #e9ecef);
            margin: 0;
            padding: 40px 0;
        }

        .change-password-container {
            max-width: 500px;
            margin: auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
        }

        h2 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
            margin-bottom: 30px;
            text-transform: uppercase;
        }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }

        input[type=password] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 5px rgba(76,175,80,0.3);
        }

        .btn-submit {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 15px;
            transition: all 0.2s;
            width: 100%;
        }

        .btn-submit:hover {
            background: #43a047;
            transform: translateY(-2px);
        }

        .message { margin-top: 15px; color: #2e7d32; font-weight: bold; }
        .error { margin-top: 15px; color: #d32f2f; font-weight: bold; }

        a.back-link {
            display: inline-block;
            margin-top: 20px;
            color: #4CAF50;
            text-decoration: none;
            font-weight: 600;
        }

        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="change-password-container">
    <h2>Đổi mật khẩu</h2>

    <form action="<%= request.getContextPath() %>/user/change-password" method="post">
        <div class="form-group">
            <label>Mật khẩu hiện tại:</label>
            <input type="password" name="current_password" required placeholder="Nhập mật khẩu hiện tại">
        </div>

        <div class="form-group">
            <label>Mật khẩu mới:</label>
            <input type="password" name="new_password" required placeholder="Nhập mật khẩu mới">
        </div>

        <div class="form-group">
            <label>Nhập lại mật khẩu mới:</label>
            <input type="password" name="confirm_password" required placeholder="Nhập lại mật khẩu mới">
        </div>

        <button type="submit" class="btn-submit">Đổi mật khẩu</button>

        <% if (request.getAttribute("success") != null) { %>
            <p class="message"><%= request.getAttribute("success") %></p>
        <% } else if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
    </form>

    <a href="<%= request.getContextPath() %>/user/profile" class="back-link">← Quay lại hồ sơ</a>
</div>
</body>
</html>
