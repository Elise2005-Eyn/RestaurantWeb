<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký tài khoản</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --color-black: #121212;
            --color-gray-dark: #222222;
            --color-gray-medium: #444444;
            --color-gray-light: #AAAAAA;
            --color-white: #F0F0F0;
            --color-gold: #E0B841;
        }

        body {
            background-color: var(--color-black);
            color: var(--color-white);
            font-family: 'Lato', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .register-wrapper {
            display: flex;
            width: 90%;
            max-width: 1300px;
            min-height: 80vh;
            max-height: 90vh;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .register-image-side {
            flex: 1;
            background-image: url('https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=1200&h=1000&q=80');
            background-size: cover;
            background-position: center;
            position: relative;
        }
        .register-image-side::before {
            content: '';
            position: absolute;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.3);
        }

        .register-form-side {
            flex: 1;
            background-color: var(--color-gray-dark);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            overflow-y: auto;
        }

        .register-title {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            font-size: 2.5em;
            font-weight: 700;
            text-align: center;
        }

        .form-label {
            color: var(--color-white);
            font-weight: 700;
        }

        .form-control {
            background-color: var(--color-gray-medium);
            color: var(--color-white);
            border: 1px solid var(--color-gray-light);
            border-radius: 5px;
            padding: 10px 15px;
        }
        .form-control:focus {
            background-color: var(--color-gray-medium);
            border-color: var(--color-gold);
            box-shadow: 0 0 0 0.25rem rgba(224, 184, 65, 0.25);
        }

        .form-check-input {
            background-color: var(--color-gray-medium);
            border-color: var(--color-gray-light);
        }
        .form-check-input:checked {
            background-color: var(--color-gold);
            border-color: var(--color-gold);
        }

        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            font-weight: 700;
            border: none;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            padding: 10px 20px;
            transition: all 0.3s;
        }
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border: 1px solid var(--color-gold);
        }

        a {
            color: var(--color-gold);
            text-decoration: none;
            font-weight: 700;
        }

        a:hover {
            text-decoration: underline;
        }

        .alert-danger {
            background-color: rgba(217, 83, 79, 0.1);
            border: 1px solid #d9534f;
            color: #f0c9c8;
        }

        .alert-success {
            background-color: rgba(92, 184, 92, 0.1);
            border: 1px solid #5cb85c;
            color: #d6e9c6;
        }

        @media (max-width: 992px) {
            .register-wrapper {
                flex-direction: column;
                width: 95%;
                max-height: 95vh;
            }
            .register-image-side {
                height: 200px;
            }
        }
    </style>

    <c:if test="${autoRedirect}">
        <meta http-equiv="refresh" content="3;url=auth?action=login">
    </c:if>
</head>

<body>

<div class="register-wrapper">
    <div class="register-image-side"></div>

    <div class="register-form-side">
        <div class="w-100" style="max-width: 500px;">
            <h3 class="register-title mb-4">Đăng ký tài khoản</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success text-center">${success}</div>
            </c:if>

            <form action="auth?action=register" method="post">
                <div class="mb-3">
                    <label class="form-label">Họ và tên:</label>
                    <input type="text" name="username" class="form-control" placeholder="Nguyễn Văn A"
                           value="${param.username}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="text" name="email" class="form-control" placeholder="example@gmail.com"
                           value="${param.email}" required>
                    <div class="text-muted small">Email phải có dạng ...@...</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số điện thoại:</label>
                    <input type="text" name="phone" class="form-control" placeholder="0912345678"
                           value="${param.phone}" required>
                    <div class="text-muted small">Bắt đầu bằng 0 và gồm 10 số.</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu:</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Nhập lại mật khẩu:</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="agree" id="agree" required>
                    <label class="form-check-label" for="agree">
                        Tôi đồng ý với <a href="#">điều khoản sử dụng</a>.
                    </label>
                </div>

                <button type="submit" class="btn btn-gold w-100 mt-2">Đăng ký</button>

                <p class="text-center mt-4" style="color: var(--color-gray-light);">
                    Đã có tài khoản? <a href="auth?action=login">Đăng nhập</a>
                </p>
            </form>
        </div>
    </div>
</div>

</body>
</html>
