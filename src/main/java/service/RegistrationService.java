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
        // Validate input (BR-04, BR-03, BR-07, ...)
        validator.validate(dto);

        // Uniqueness (BR-01, BR-02)
        if (userDao.existsByUsername(dto.username()))
            throw new ValidationException("Username đã tồn tại.");
        if (userDao.existsByEmail(dto.email()))
            throw new ValidationException("Email đã tồn tại.");

        // Map DTO -> Entity
        User u = new User();
        u.setUsername(dto.username());
        u.setEmail(dto.email());
        u.setPasswordHash(PasswordUtil.hash(dto.password())); // hash (BR-03)
        u.setFullName(dto.fullName());
        u.setPhone(dto.phone());
        u.setRole("customer");
        u.setStatus("active"); // BR-06

        // Create
        userDao.create(u);
    }
}
