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
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #f5f6fa;
                margin: 0;
                padding: 40px 60px;
            }

            .container {
                background: white;
                border-radius: 10px;
                padding: 30px 40px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                max-width: 800px;
                margin: 0 auto;
            }

            h1 {
                color: #4b0082;
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .report-detail {
                display: grid;
                grid-template-columns: 180px 1fr;
                gap: 15px 25px;
            }

            .report-detail label {
                font-weight: 600;
                color: #555;
                text-align: right;
            }

            .report-detail div {
                color: #222;
            }

            .description {
                grid-column: 1 / span 2;
                background: #fafafa;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 15px;
                font-size: 14px;
            }

            .file-link {
                display: inline-block;
                background-color: #6a11cb;
                color: white;
                padding: 10px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                margin-top: 15px;
            }

            .file-link:hover {
                background-color: #5012a0;
            }

            .btn-back {
                display: inline-block;
                background-color: #ccc;
                color: #333;
                padding: 10px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                margin-top: 25px;
            }

            .btn-back:hover {
                background-color: #b3b3b3;
            }

            .no-file {
                color: #777;
                font-style: italic;
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
