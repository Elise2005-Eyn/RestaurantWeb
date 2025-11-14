package Utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // ==================== CẤU HÌNH CƠ BẢN ====================
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";
        String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
        String vnp_IpAddr = request.getRemoteAddr();
        String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

        // ==================== LẤY DỮ LIỆU TỪ REQUEST ====================
        String orderInfo = request.getParameter("orderInfo");
        if (orderInfo == null || orderInfo.isEmpty()) {
            orderInfo = "Thanh toán đơn hàng tại Nhà hàng Demo";
        }

        String amountParam = request.getParameter("amount");
        double amount = 0;
        try {
            amount = Double.parseDouble(amountParam);
        } catch (NumberFormatException e) {
            amount = 0;
        }

        // ==================== GÁN THAM SỐ GỬI ĐI ====================
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf((long) (amount * 100))); // VNPay yêu cầu x100
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        // ==================== THỜI GIAN GIAO DỊCH ====================
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // ==================== TẠO CHUỖI HASH ====================
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String name : fieldNames) {
            String value = vnp_Params.get(name);
            if (value != null && !value.isEmpty()) {
                hashData.append(name)
                        .append('=')
                        .append(URLEncoder.encode(value, StandardCharsets.UTF_8))
                        .append('&');
                query.append(name)
                        .append('=')
                        .append(URLEncoder.encode(value, StandardCharsets.UTF_8))
                        .append('&');
            }
        }

        // Xóa ký tự & cuối cùng để đúng chuẩn hash
        hashData.setLength(hashData.length() - 1);
        query.setLength(query.length() - 1);

        // ==================== TẠO CHỮ KÝ BẢO MẬT ====================
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnp_SecureHash);

        // ==================== TẠO URL THANH TOÁN ====================
        String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query;

        // In ra console để debug
        System.out.println("=== VNPay Debug ===");
        System.out.println("HashData: " + hashData);
        System.out.println("SecureHash: " + vnp_SecureHash);
        System.out.println("PaymentURL: " + paymentUrl);

        // ==================== REDIRECT SANG VNPay ====================
        response.sendRedirect(paymentUrl);
    }
}
