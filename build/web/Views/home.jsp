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
        /* --------------------------------- */
        /* MỚI: BẢNG MÀU ĐEN - VÀNG - XÁM    */
        /* --------------------------------- */
        :root {
            --color-black: #121212; /* Nền chính (Đen) */
            --color-gray-dark: #222222; /* Nền phụ, nền thẻ (Xám đậm) */
            --color-gray-medium: #444444; /* Viền (Xám vừa) */
            --color-gray-light: #AAAAAA; /* Chữ mô tả (Xám nhạt) */
            --color-white: #F0F0F0; /* Chữ chính (Trắng xám) */
            --color-gold: #E0B841; /* Điểm nhấn (Vàng Gold) */
        }

        /* CSS Reset cơ bản */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Lato', sans-serif;
            /* THAY ĐỔI: Nền đen */
            background-color: var(--color-black); 
            /* THAY ĐỔI: Chữ trắng xám */
            color: var(--color-white);
            line-height: 1.6;
        }

        /* Tiêu đề dùng font Oswald */
        h1, h2, h3 {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            /* THAY ĐỔI: Tiêu đề màu vàng gold */
            color: var(--color-gold); 
        }
        
        /* --------------------------------- */
        /* THIẾT KẾ LẠI HEADER              */
        /* --------------------------------- */
        .header-main {
            /* THAY ĐỔI: Nền xám đậm */
            background-color: var(--color-gray-dark); 
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            /* THAY ĐỔI: Viền dưới màu vàng */
            border-bottom: 2px solid var(--color-gold);
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
            /* THAY ĐỔI: Chữ logo màu trắng */
            color: var(--color-white); 
            text-decoration: none;
            font-weight: 700;
        }
        .logo span {
            /* THAY ĐỔI: Chữ "NGON" màu vàng */
            color: var(--color-gold); 
        }

        .main-nav {
            display: flex;
            gap: 25px;
        }

        .main-nav a {
            text-decoration: none;
            /* THAY ĐỔI: Chữ nav màu trắng */
            color: var(--color-white); 
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            font-size: 1.1em;
            text-transform: uppercase;
            transition: color 0.2s;
        }

        .main-nav a:hover {
            /* THAY ĐỔI: Hover màu vàng */
            color: var(--color-gold); 
        }

        .header-contact {
            /* THAY ĐỔI: Thanh hotline màu vàng */
            background-color: var(--color-gold); 
            /* THAY ĐỔI: Chữ màu đen */
            color: var(--color-black);
            padding: 10px 20px;
            text-align: center;
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
        }

        .header-contact strong {
            font-size: 1.2em;
            margin: 0 10px;
        }
        
        /* --------------------------------- */
        /* MỚI: PHẦN HERO BANNER (ẢNH LỚN)  */
        /* --------------------------------- */
        .hero {
            position: relative;
            height: 500px; /* Chiều cao của ảnh */
            /* QUAN TRỌNG: Thay URL bên dưới bằng ảnh của bạn 
              (Nên chọn ảnh tối hoặc ảnh đồ ăn/nhà hàng đẹp)
            */
            background-image: url('https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1600&h=500&fit=crop');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        
        /* Lớp phủ màu đen mờ đè lên ảnh để chữ nổi bật */
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6); /* Độ mờ 60% */
        }
        
        .hero-content {
            position: relative; /* Nằm trên lớp phủ */
            z-index: 2;
            color: white;
        }
        
        .hero-content h1 {
            font-size: 3.5em; /* Chữ to */
            color: var(--color-gold); /* Tiêu đề chính màu vàng */
            margin-bottom: 10px;
        }
        
        .hero-content p {
            font-size: 1.5em;
            color: var(--color-white); /* Chữ phụ màu trắng */
            font-family: 'Lato', sans-serif;
        }

        /* --------------------------------- */
        /* PHẦN NỘI DUNG CHÍNH (THỰC ĐƠN)  */
        /* --------------------------------- */
        .menu-section {
            padding: 60px 20px;
            max-width: 1200px;
            margin: auto;
        }

        /* Tiêu đề có gạch 2 bên */
        .section-title {
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }

        /* 2 đường gạch */
        .section-title::before,
        .section-title::after {
            content: '';
            height: 3px;
            width: 100px;
            /* THAY ĐỔI: Gạch màu vàng */
            background-color: var(--color-gold); 
        }


        .grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px; 
        }

        /* --------------------------------- */
        /* THIẾT KẾ LẠI THẺ MÓN ĂN           */
        /* --------------------------------- */
        .dish-card {
            /* THAY ĐỔI: Nền xám đậm */
            background: var(--color-gray-dark);
            border-radius: 8px; 
            /* THAY ĐỔI: Viền xám vừa */
            border: 1px solid var(--color-gray-medium); 
            /* THAY ĐỔI: Shadow cho nền tối */
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            width: 280px;
            text-align: center; 
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .dish-card:hover {  
            transform: translateY(-6px);
            /* THAY ĐỔI: Hiệu ứng shadow màu vàng khi hover */
            box-shadow: 0 6px 20px rgba(224, 184, 65, 0.15);
            border-color: var(--color-gold);
        }

        .dish-card img {
            width: 100%;
            height: 200px; 
            object-fit: cover;
            padding: 0; /* Bỏ padding ảnh */
            border-radius: 0; 
            border-bottom: 1px solid var(--color-gray-medium);
        }
        
        .dish-card-content {
            padding: 20px 15px; /* Tăng padding */
        }

        .dish-card h3 {
            margin: 0 0 10px;
            color: var(--color-gold); /* Đã set ở h3 chung */
            font-size: 1.4em;
        }

        .dish-card p {
            font-size: 0.9em;
            /* THAY ĐỔI: Chữ mô tả màu xám nhạt */
            color: var(--color-gray-light); 
            height: 38px; 
            overflow: hidden;
            margin-bottom: 15px;
        }

        .dish-card strong {
            /* THAY ĐỔI: Giá tiền màu vàng */
            color: var(--color-gold); 
            font-size: 1.3em;
            font-weight: 700;
        }
       
        /* --------------------------------- */
        /* THIẾT KẾ LẠI FOOTER              */
        /* --------------------------------- */
        footer {
            /* THAY ĐỔI: Nền xám đậm */
            background-color: var(--color-gray-dark); 
            /* THAY ĐỔI: Chữ xám nhạt */
            color: var(--color-gray-light); 
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            font-size: 0.9em;
            /* THAY ĐỔI: Viền trên màu vàng */
            border-top: 3px solid var(--color-gold); 
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

<section class="hero">
    <div class="hero-content">
        <h1>Trải Nghiệm Ẩm Thực Đẳng Cấp</h1>
        <p>Hương vị tinh tế trong không gian sang trọng.</p>
    </div>
</section>
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