<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ | Nhà hàng của chúng tôi</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">

    <style>
        /* CSS Reset cơ bản */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            /* MỚI: Font Lato cho nội dung */
            font-family: 'Lato', sans-serif;
            /* MỚI: Màu nền kem rất nhạt */
            background-color: #fffef5;
            color: #333;
            line-height: 1.6;
        }

        /* MỚI: Font Oswald cho tất cả tiêu đề, viết hoa */
        h1, h2, h3 {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: #1d3557; /* Màu xanh đậm */
        }
        
        /* --------------------------------- */
        /* MỚI: PHẦN HEADER ĐÃ THIẾT KẾ LẠI */
        /* --------------------------------- */
        .header-main {
            background-color: #f9d749; /* Màu vàng chủ đạo */
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .header-container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-family: 'Oswald', sans-serif;
            font-size: 2.2em;
            color: #1d3557; /* Xanh đậm */
            text-decoration: none;
            font-weight: 700;
        }
        .logo span {
            color: #e63946; /* Màu đỏ */
        }

        .main-nav {
            display: flex;
            gap: 25px;
        }

        .main-nav a {
            text-decoration: none;
            color: #1d3557;
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            font-size: 1.1em;
            text-transform: uppercase;
            transition: color 0.2s;
        }

        .main-nav a:hover {
            color: #e63946; /* Đổi sang màu đỏ khi hover */
        }

        .header-contact {
            background-color: #e63946; /* Màu đỏ */
            color: white;
            padding: 10px 20px;
            text-align: center;
            font-family: 'Oswald', sans-serif;
        }

        .header-contact strong {
            font-size: 1.2em;
            margin: 0 10px;
        }
        /* --------------------------------- */
        /* KẾT THÚC HEADER MỚI             */
        /* --------------------------------- */


        /* Đã XÓA class .actions */

        .menu-section {
            padding: 60px 20px;
            max-width: 1200px;
            margin: auto;
        }

        /* MỚI: Tiêu đề có gạch 2 bên */
        .section-title {
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }

        /* MỚI: 2 đường gạch đỏ */
        .section-title::before,
        .section-title::after {
            content: '';
            height: 3px;
            width: 100px;
            background-color: #e63946;
        }


        .grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px; /* Tăng khoảng cách */
        }

        /* --------------------------------- */
        /* MỚI: THẺ MÓN ĂN ĐÃ THIẾT KẾ LẠI  */
        /* --------------------------------- */
        .dish-card {
            background: white;
            border-radius: 8px; /* Bo góc ít hơn */
            border: 1px solid #eee; /* Thêm viền mờ */
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            width: 280px;
            text-align: center; /* Căn giữa nội dung */
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .dish-card:hover { 
            transform: translateY(-6px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .dish-card img {
            width: 100%;
            height: 200px; /* Ảnh cao hơn */
            object-fit: cover;
            /* Thêm padding cho ảnh */
            padding: 10px;
            border-radius: 12px; /* Bo góc cho ảnh bên trong */
        }
        
        /* Bọc nội dung để padding */
        .dish-card-content {
            padding: 0 15px 20px 15px;
        }

        .dish-card h3 {
            margin: 10px 0 8px;
            color: #1d3557; /* Màu xanh đậm */
            font-size: 1.4em;
        }

        .dish-card p {
            font-size: 0.9em;
            color: #555;
            height: 38px; /* Giữ 2 dòng */
            overflow: hidden;
            margin-bottom: 15px;
        }

        .dish-card strong {
            color: #e63946; /* MỚI: Giá tiền màu đỏ */
            font-size: 1.3em;
            font-weight: 700;
        }
        /* --------------------------------- */
        /* KẾT THÚC THẺ MÓN ĂN MỚI          */
        /* --------------------------------- */


        /* MỚI: FOOTER ĐÃ THIẾT KẾ LẠI */
        footer {
            background-color: #fffef5; /* Nền kem nhạt */
            color: #333; /* Chữ đậm */
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            font-size: 0.9em;
            /* Thêm viền vàng ở trên */
            border-top: 3px solid #f9d749; 
        }
    </style>
</head>
<body>

<header class="header-main">
    <div class="header-container">
        <a href="#" class="logo">NHÀ HÀNG <span>NGON</span></a>
        
        <nav class="main-nav">
            <a href="#">Trang Chủ</a>
            <a href="menu">Thực Đơn</a>
            <a href="book-table">Đặt Bàn</a>
            <a href="login">Đăng Nhập</a>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>


<section class="menu-section">
    <h2 class="section-title">Món ăn nổi bật</h2>
    
    <div class="grid">
        <c:forEach var="d" items="${topDishes}">
            <div class="dish-card">
                <img src="${d.imagePath}" alt="${d.name}">
                <div class="dish-card-content">
                    <h3>${d.name}</h3>
                    <p>${d.description}</p>
                    <strong>${d.price} VNĐ</strong>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>

</body>
</html>