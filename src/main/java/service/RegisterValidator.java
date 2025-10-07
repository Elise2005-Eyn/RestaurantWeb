package service;

import dto.RegistrationDTO;
import exception.ValidationException;

import java.util.regex.Pattern;

public class RegisterValidator {
    private static final Pattern USERNAME = Pattern.compile("^[a-zA-Z0-9](?:[a-zA-Z0-9._-]{2,18}[a-zA-Z0-9])$");
    private static final Pattern EMAIL    = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONEVN  = Pattern.compile("^(?:0|\\+84)\\d{9}$");

    public void validate(RegistrationDTO d) {
        if (blank(d.username()) || blank(d.email()) || blank(d.password()))
            throw new ValidationException("Vui lòng nhập đủ Username/Email/Password.");

        if (!USERNAME.matcher(d.username()).matches())
            throw new ValidationException("Username 4–20, chỉ a–z, 0–9, ., _, - (không ở đầu/cuối).");

        if (!EMAIL.matcher(d.email()).matches())
            throw new ValidationException("Email không hợp lệ.");

        if (d.password().length() < 6)
            throw new ValidationException("Mật khẩu tối thiểu 6 ký tự.");

        if (d.phone() != null && !d.phone().isBlank() && !PHONEVN.matcher(d.phone()).matches())
            throw new ValidationException("Số điện thoại không hợp lệ.");

        if (!d.acceptTerms())
            throw new ValidationException("Bạn cần đồng ý Điều khoản & Chính sách.");
    }

    private boolean blank(String s){ return s == null || s.trim().isEmpty(); }
}
