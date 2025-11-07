<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Thanh toán thành công</title></head>
<body style="text-align:center;">
    <h2 style="color:green;">✅ Thanh toán thành công!</h2>
    <p>Mã giao dịch: ${param.vnp_TxnRef}</p>
    <p>Số tiền: ${param.vnp_Amount} VNĐ</p>
    <a href="${pageContext.request.contextPath}/home">Quay lại trang chủ</a>
</body>
</html>
