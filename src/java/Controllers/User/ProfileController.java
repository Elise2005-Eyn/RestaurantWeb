package Controllers.User;

import DAO.UserDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = {"/user/profile"})
@MultipartConfig
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("USER_ID");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/Views/User/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("USER_ID");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String telephone = request.getParameter("telephone");
        String currentPhoto = request.getParameter("current_photo");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        Part photoPart = request.getPart("photo");
        String photoUrl = currentPhoto;

        if (photoPart != null && photoPart.getSize() > 0) {
            String fileName = photoPart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadPath, fileName);
            photoPart.write(file.getAbsolutePath());
            photoUrl = "uploads/" + fileName;
        }

        boolean changePassword = false;
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
                doGet(request, response);
                return;
            }
            changePassword = true;
        }

        User user = new User();
        user.setId(userId);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setTelephone(telephone);
        user.setPhotoUrl(photoUrl);
        if (changePassword) {
            user.setPassword(newPassword);
        }

        boolean updated = userDAO.updateProfile(user, changePassword);

        if (updated) {
            request.setAttribute("success", "Cập nhật hồ sơ thành công!");
        } else {
            request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại!");
        }

        User updatedUser = userDAO.getUserById(userId);
        request.setAttribute("user", updatedUser);
        request.getRequestDispatcher("/Views/User/profile.jsp").forward(request, response);
    }

}
