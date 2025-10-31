<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Models.User" %>
<%
    User user = (User) request.getAttribute("user");
%>
<html>
<head>
    <title>Hồ sơ cá nhân</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f8f9fa, #e9ecef);
            margin: 0;
            padding: 40px 0;
        }

        .profile-container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            display: flex;
            overflow: hidden;
        }

        /* ===== LEFT (AVATAR) ===== */
        .profile-left {
            background: #f4f5f7;
            width: 40%;
            padding: 40px 20px;
            text-align: center;
            border-right: 1px solid #ddd;
        }

        .profile-left img {
            width: 220px;
            height: 220px;
            object-fit: cover;
            border-radius: 50%;
            border: 5px solid #4CAF50;
            margin-bottom: 20px;
            transition: transform 0.2s ease-in-out;
        }

        .profile-left img:hover {
            transform: scale(1.05);
        }

        .profile-left h2 {
            font-size: 1.6em;
            color: #333;
            margin-bottom: 10px;
        }

        .profile-left p {
            color: #777;
            font-size: 0.95em;
        }

        /* ===== RIGHT (FORM) ===== */
        .profile-right {
            flex: 1;
            padding: 40px;
        }

        .profile-right h3 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 8px;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }

        input[type=text],
        input[type=password],
        input[type=file] {
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
        }

        .btn-submit:hover {
            background: #43a047;
            transform: translateY(-2px);
        }

        .message { margin-top: 15px; color: #2e7d32; font-weight: bold; }
        .error { margin-top: 15px; color: #d32f2f; font-weight: bold; }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .profile-container { flex-direction: column; }
            .profile-left, .profile-right { width: 100%; border: none; }
            .profile-left img { width: 160px; height: 160px; }
        }
    </style>
</head>
<body>
<div class="profile-container">
    <!-- LEFT: AVATAR -->
    <div class="profile-left">
        <img src="<%= request.getContextPath() + "/" + 
            (user.getPhotoUrl() != null ? user.getPhotoUrl() : "uploads/default-avatar.png") %>" 
            alt="avatar">

        <h2><%= user.getFullName() != null && !user.getFullName().isBlank() ? user.getFullName() : user.getUsername() %></h2>
        <p><%= user.getEmail() %></p>

        <form action="<%= request.getContextPath() %>/user/profile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="current_photo" value="<%= user.getPhotoUrl() %>">
            <label style="margin-top: 20px;">Thay ảnh đại diện:</label>
            <input type="file" name="photo">
            <button class="btn-submit" style="margin-top:15px;">Cập nhật ảnh</button>
        </form>
    </div>

    <!-- RIGHT: PROFILE INFO -->
    <div class="profile-right">
        <h3>Thông tin cá nhân</h3>
        <form action="<%= request.getContextPath() %>/user/profile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="current_photo" value="<%= user.getPhotoUrl() %>">

            <div class="form-group">
                <label>Họ:</label>
                <input type="text" name="first_name" value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>" required>
            </div>

            <div class="form-group">
                <label>Tên:</label>
                <input type="text" name="last_name" value="<%= user.getLastName() != null ? user.getLastName() : "" %>" required>
            </div>

            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="telephone" value="<%= user.getTelephone() != null ? user.getTelephone() : "" %>">
            </div>

            <div class="form-group">
                <label>Email (không chỉnh sửa):</label>
                <input type="text" value="<%= user.getEmail() %>" readonly>
            </div>

            <h3>Đổi mật khẩu</h3>
            <div class="form-group">
                <label>Mật khẩu mới:</label>
                <input type="password" name="new_password" placeholder="Nhập mật khẩu mới">
            </div>

            <div class="form-group">
                <label>Nhập lại mật khẩu mới:</label>
                <input type="password" name="confirm_password" placeholder="Nhập lại mật khẩu">
            </div>

            <button type="submit" class="btn-submit">Lưu thay đổi</button>

            <% if (request.getAttribute("success") != null) { %>
                <p class="message">
                    <%= request.getAttribute("success") %> <br>
                    Tự động quay lại trang chủ sau <span id="countdown">5</span> giây...
                </p>
                <script>
                    let counter = 5;
                    const countdown = document.getElementById("countdown");
                    const timer = setInterval(() => {
                        counter--;
                        if (counter <= 0) {
                            clearInterval(timer);
                            window.location.href = "<%= request.getContextPath() %>/home";
                        } else {
                            countdown.textContent = counter;
                        }
                    }, 1000);
                </script>
            <% } else if (request.getAttribute("error") != null) { %>
                <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>
        </form>
    </div>
</div>
</body>
</html>
