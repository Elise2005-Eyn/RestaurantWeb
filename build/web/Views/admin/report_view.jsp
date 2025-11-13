<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Báo cáo</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            :root {
                --primary-gold: #FFD700;
                --gold-hover: #ffea70;
                --bg-dark: #0c0c0c;
                --bg-panel: #1a1a1a;
                --bg-inset: #0a0a0a;   /* Màu nền tối hơn cho các ô lún xuống */
                --text-light: #f5f5f5;
                --text-dim: #bbb;
                --border-gold: rgba(255, 215, 0, 0.3);
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--bg-dark);
                margin: 0;
                padding: 70px;
                color: var(--text-light);
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .container {
                background: var(--bg-panel);
                border-radius: 10px;
                padding: 40px 50px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.7); /* Bóng đen sâu */
                max-width: 800px;
                margin: 0 auto;
                border: 1px solid var(--border-gold); /* Viền vàng mờ sang trọng */
            }

            h1 {
                color: var(--primary-gold);
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 35px;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
                border-bottom: 1px solid var(--border-gold);
                padding-bottom: 15px;
            }

            /* Grid Layout cho thông tin */
            .report-detail {
                display: grid;
                grid-template-columns: 200px 1fr; /* Tăng chiều rộng cột label chút cho thoáng */
                gap: 20px 30px;
                align-items: baseline;
            }

            .report-detail label {
                font-weight: 700;
                color: var(--primary-gold);
                text-align: right;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .report-detail div {
                color: var(--text-light);
                font-size: 15px;
                line-height: 1.5;
            }

            /* Khung mô tả (Description Box) */
            .description {
                grid-column: 1 / span 2;
                background: var(--bg-inset); /* Nền tối hơn để tạo cảm giác "lõm" xuống */
                border: 1px solid var(--border-gold);
                border-radius: 8px;
                padding: 20px;
                font-size: 14px;
                color: #ddd;
                margin-top: 10px;
                box-shadow: inset 0 0 10px rgba(0,0,0,0.5); /* Bóng đổ vào trong */
            }

            /* Nút tải file */
            .file-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background-color: var(--primary-gold);
                color: #000;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 700;
                margin-top: 20px;
                transition: 0.3s;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            .file-link:hover {
                background-color: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            /* Nút Quay lại (Back Button) */
            .btn-back {
                display: inline-block;
                background-color: transparent;
                color: var(--text-dim);
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                margin-top: 30px;
                border: 1px solid #444;
                transition: 0.3s;
            }

            .btn-back:hover {
                background-color: var(--primary-gold);
                color: #000;
                border-color: var(--primary-gold);
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            }

            .no-file {
                color: #777;
                font-style: italic;
                margin-top: 15px;
                display: inline-block;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <h1><i class="fa-solid fa-file-alt"></i> Chi tiết Báo cáo</h1>

            <c:if test="${not empty error}">
                <div style="background:#ffe6e6;color:#b30000;padding:10px;border-radius:6px;margin-bottom:15px;">
                    ${error}
                </div>
            </c:if>




            <c:if test="${not empty report}">
                <div class="report-detail">
                    <label>ID báo cáo:</label>
                    <div>${report.reportId}</div>

                    <label>Tiêu đề:</label>
                    <div>${report.title}</div>

                    <label>Loại báo cáo:</label>
                    <div>${report.reportType}</div>

                    <label>Ngày bắt đầu:</label>
                    <div><c:out value="${report.fromDate}" default="-"/></div>

                    <label>Ngày kết thúc:</label>
                    <div><c:out value="${report.toDate}" default="-"/></div>

                    <label>Người tạo:</label>
                    <div><c:out value="${report.createdBy}" default="Không rõ"/></div>

                    <label>Ngày tạo:</label>
                    <div><fmt:formatDate value="${report.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></div>

                    <label>Tệp đính kèm:</label>
                    <div>
                        <c:choose>
                            <c:when test="${not empty report.filePath}">
                                <a class="file-link"
                                   href="${pageContext.request.contextPath}/${report.filePath}"
                                   target="_blank">
                                    <i class="fa-solid fa-download"></i> Tải hoặc xem tệp
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="no-file">Không có tệp đính kèm</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="description">
                        <strong>Mô tả:</strong><br>
                        <c:out value="${report.description}" default="Không có mô tả"/>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/admin/reports" class="btn-back">
                    ← Quay lại danh sách
                </a>
            </c:if>
        </div>
    </body>
</html>
