package service;

import dao.UserDao;
import dto.RegistrationDTO;
import exception.ValidationException;
import model.User;
import util.PasswordUtil;

public class RegistrationService {
    private final UserDao userDao;
    private final RegisterValidator validator = new RegisterValidator();

    public RegistrationService(UserDao userDao) { this.userDao = userDao; }

    public void register(RegistrationDTO dto) throws Exception {
        validator.validate(dto);

        if (userDao.existsByUsername(dto.username()))
            throw new ValidationException("Username đã tồn tại.");
        if (userDao.existsByEmail(dto.email()))
            throw new ValidationException("Email đã tồn tại.");

        User u = new User();
        u.setUsername(dto.username());
        u.setEmail(dto.email());
        u.setPasswordHash(PasswordUtil.hash(dto.password()));
        u.setFullName(dto.fullName());
        u.setPhone(dto.phone());
        u.setRole("customer");
        u.setStatus("active"); // BR-06

        // Create
        userDao.create(u);
    }
}
