package controller.admin;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(urlPatterns = {"/admin/dishes/edit"})
public class DishEditServlet extends HttpServlet {
    private final DishDao dao = new DishDao();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Dish d = dao.findById(id);
            if (d == null) { resp.sendError(404); return; }
            req.setAttribute("dish", d);
            req.setAttribute("mode", "edit");
            req.getRequestDispatcher("/admin/dish-form.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Dish d = dao.findById(id);
            if (d == null) { resp.sendError(404); return; }
            d.setName(req.getParameter("name"));
            d.setCategory(req.getParameter("category"));
            d.setDescription(req.getParameter("description"));
            d.setPrice(new BigDecimal(req.getParameter("price")));
            d.setImagePath(req.getParameter("imagePath"));
            d.setStatus("active");
            dao.update(d);
            resp.sendRedirect(req.getContextPath() + "/admin/dishes");
        } catch (Exception e) {
            req.setAttribute("error", "Update failed: " + e.getMessage());
            req.setAttribute("mode", "edit");
            req.getRequestDispatcher("/admin/dish-form.jsp").forward(req, resp);
        }
    }
}
