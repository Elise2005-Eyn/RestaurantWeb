<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn đặt bàn của tôi</title>

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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Lato', sans-serif;
            background-color: var(--color-black);
            color: var(--color-white);
            line-height: 1.6;
        }
        h1, h2, h3 {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
        }
        
        /* --------------------------------- */
        /* HEADER (GIỮ NGUYÊN)               */
        /* --------------------------------- */
        .header-main {
            background-color: var(--color-gray-dark);
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
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
            color: var(--color-white);
            text-decoration: none;
            font-weight: 700;
        }
        .logo span { color: var(--color-gold); }
        .main-nav {
            display: flex;
            gap: 25px;
            align-items: center;
        }
        .main-nav a {
            text-decoration: none;
            color: var(--color-white);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            font-size: 1.1em;
            text-transform: uppercase;
            transition: color 0.2s;
        }
        .main-nav a:hover { color: var(--color-gold); }
        .main-nav span {
            color: var(--color-gold);
            font-weight: 700;
            font-size: 1.05em;
        }
        /* Dòng contact bị thiếu trong code gốc, tôi thêm lại cho đủ bộ header */
        .header-contact {
            background-color: var(--color-gold);
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
        /* MỚI: CSS CHO NỘI DUNG TRANG NÀY   */
        /* --------------------------------- */

        /* Tiêu đề (Giống trang chủ) */
        .section-title {
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }
        .section-title::before,
        .section-title::after {
            content: '';
            height: 3px;
            width: 100px;
            background-color: var(--color-gold);
        }
        
        /* Box thông báo "Không có đơn" */
        .no-reservations-box {
            background-color: var(--color-gray-dark);
            border: 1px dashed var(--color-gray-medium);
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            color: var(--color-gray-light);
            font-size: 1.2em;
        }
        .no-reservations-box a {
            color: var(--color-gold);
            font-weight: 700;
            text-decoration: none;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
        }
        .no-reservations-box a:hover {
            text-decoration: underline;
        }

        /* Tùy chỉnh Bảng */
        .table-custom {
            background-color: var(--color-gray-dark);
            border-color: var(--color-gray-medium);
            color: var(--color-white);
        }
        .table-custom th {
            color: var(--color-gold);
            border-bottom: 2px solid var(--color-gold) !important;
            border-top: none;
        }
        .table-custom td {
            border-color: var(--color-gray-medium);
            vertical-align: middle;
        }
        .table-custom tbody tr:hover {
            background-color: var(--color-gray-medium);
            color: var(--color-white);
        }
        
        /* Nút Vàng (Bị thiếu trong CSS gốc) */
        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            font-size: 0.9em;
            padding: 0.3rem 0.75rem;
            transition: all 0.2s ease;
        }
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }
        
        /* Tùy chỉnh Badge Trạng thái */
        .badge-status {
            padding: 0.5em 0.75em;
            font-size: 0.9em;
            font-family: 'Oswald', sans-serif;
            font-weight: 600;
        }
        /* Ghi đè màu xám của Bootstrap */
        .badge-status.bg-secondary {
            background-color: var(--color-gray-medium) !important;
            color: var(--color-gray-light) !important;
        }
        /* Ghi đè màu vàng (cho PENDING) */
        .badge-status.bg-warning {
             background-color: var(--color-gold) !important;
             color: var(--color-black) !important;
        }
        
        /* --------------------------------- */
        /* MỚI: TÙY CHỈNH MODAL              */
        /* --------------------------------- */
        .modal-content {
            background-color: var(--color-gray-dark) !important;
            border: 1px solid var(--color-gray-medium);
            color: var(--color-white);
        }
        .modal-header {
            border-bottom: 1px solid var(--color-gray-medium) !important;
        }
        .modal-header .modal-title {
            color: var(--color-gold);
        }
        .modal-body strong {
            color: var(--color-gray-light);
        }
        .modal-body .detail-value {
            color: var(--color-white);
            font-weight: 700;
            font-size: 1.1em;
        }
        /* Khu vực ghi chú */
        #detailNote {
            background-color: var(--color-black) !important;
            color: var(--color-gold) !important;
            border: 1px solid var(--color-gray-medium);
            border-radius: 5px;
            padding: 10px;
            min-height: 100px;
            white-space: pre-wrap; /* Giữ định dạng xuống dòng */
            font-family: 'Lato', sans-serif;
        }
        
        /* --------------------------------- */
        /* MỚI: FOOTER (Thêm vào)           */
        /* --------------------------------- */
        footer {
            background-color: var(--color-gray-dark); 
            color: var(--color-gray-light); 
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            font-size: 0.9em;
            border-top: 3px solid var(--color-gold); 
        }
        
    </style>
</head>

<body>

<header class="header-main">
    <div class="header-container">
        <a href="home.jsp" class="logo">NHÀ HÀNG <span>NGON</span></a>
        <nav class="main-nav">
            <a href="home">Trang Chủ</a>
            <a href="menu?action=list">Thực Đơn</a>
            <a href="book-table">Đặt Bàn</a>
            <a href="my-reservations" style="color: var(--color-gold);">Đơn đặt bàn của tôi</a>

            <c:if test="${empty sessionScope.user}">
                <a href="auth?action=login">Đăng Nhập</a>
                <a href="auth?action=register">Đăng Ký</a>
            </c:if>

            <c:if test="${not empty sessionScope.user}">
                <span>👋 Xin chào, ${sessionScope.user.username}</span>
                <a href="auth?action=logout">Đăng Xuất</a>
            </c:if>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>


<main class="container py-5">
    <h2 class="section-title">📋 Đơn đặt bàn của tôi</h2>

    <c:if test="${empty reservations}">
        <div class="no-reservations-box">
            Bạn chưa có đơn đặt bàn nào.
            <br>
            <a href="book-table" class="mt-3 d-inline-block">Đặt bàn ngay!</a>
        </div>
    </c:if>

    <c:if test="${not empty reservations}">
        <div class="table-responsive">
            <table class="table table-custom table-hover align-middle">
                <thead>
                    <tr class="text-center">
                        <th>#</th>
                        <th>Thời gian đặt</th>
                        <th>Số khách</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${reservations}" varStatus="loop">
                    <tr class="text-center">
                        <td>${loop.index + 1}</td>
                        <td>${r.reservedAt}</td>
                        <td>${r.guestCount}</td>
                        <td>
                            <c:set var="statusClass" value="secondary"/>
                            <c:if test="${r.status == 'CONFIRMED'}"><c:set var="statusClass" value="success"/></c:if>
                            <c:if test="${r.status == 'PENDING'}"><c:set var="statusClass" value="warning"/></c:if>
                            <c:if test="${r.status == 'CANCELLED'}"><c:set var="statusClass" value="danger"/></c:if>
                            
                            <span class="badge badge-status bg-${statusClass}">
                                ${r.status}
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-gold"
                                    data-bs-toggle="modal"
                                    data-bs-target="#detailModal"
                                    data-note="${r.note}"
                                    data-time="${r.reservedAt}"
                                    data-guest="${r.guestCount}"
                                    data-status="${r.status}"
                                    data-status-class="bg-${statusClass}">
                                Xem chi tiết
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</main>

<div class="modal fade" id="detailModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Chi tiết đơn đặt bàn</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p><strong>Thời gian:</strong> <span id="detailTime" class="detail-value"></span></p>
        <p><strong>Số khách:</strong> <span id="detailGuest" class="detail-value"></span></p>
        <p><strong>Trạng thái:</strong> <span id="detailStatus" class="detail-value"></span></p>
        <hr>
        <p><strong>Món ăn & Ghi chú:</strong></p>
        <div id="detailNote"></div>
      </div>
    </div>
  </div>
</div>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const detailModal = document.getElementById('detailModal');
detailModal.addEventListener('show.bs.modal', event => {
  const button = event.relatedTarget;
  
  // Lấy dữ liệu từ nút
  const note = button.getAttribute('data-note');
  const time = button.getAttribute('data-time');
  const guest = button.getAttribute('data-guest');
  const status = button.getAttribute('data-status');
  
  // THAY ĐỔI: Cập nhật nội dung cho modal
  document.getElementById('detailNote').textContent = (note && note.trim() !== "") ? note : "Không có ghi chú.";
  document.getElementById('detailTime').textContent = time;
  document.getElementById('detailGuest').textContent = guest;
  
  // THAY ĐỔI: Hiển thị trạng thái bằng chữ (đã có badge trong bảng)
  document.getElementById('detailStatus').textContent = status;

});
</script>

</body>
</html>