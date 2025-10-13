package controller.admin;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/dishes/delete"})
public class DishDeleteServlet extends HttpServlet {
    private final DishDao dao = new DishDao();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/dishes");
        } catch (Exception e) { throw new ServletException(e); }
    }
}
