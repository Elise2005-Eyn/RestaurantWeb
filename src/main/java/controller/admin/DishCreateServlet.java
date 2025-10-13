package controller.admin;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(urlPatterns = {"/admin/dishes/create"})
public class DishCreateServlet extends HttpServlet {
    private final DishDao dao = new DishDao();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("mode", "create");
        req.getRequestDispatcher("/admin/dish-form.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            Dish d = new Dish();
            d.setName(req.getParameter("name"));
            d.setCategory(req.getParameter("category"));
            d.setDescription(req.getParameter("description"));
            d.setPrice(new BigDecimal(req.getParameter("price")));
            d.setImagePath(req.getParameter("imagePath")); // filename in assets/images/dishes
            d.setStatus("active");
            dao.create(d);
            resp.sendRedirect(req.getContextPath() + "/admin/dishes");
        } catch (Exception e) {
            req.setAttribute("error", "Save failed: " + e.getMessage());
            req.setAttribute("mode", "create");
            req.getRequestDispatcher("/admin/dish-form.jsp").forward(req, resp);
        }
    }
}
