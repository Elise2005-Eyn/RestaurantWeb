package controller;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {
    private final DishDao dao = new DishDao();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Dish> dishes = dao.findAll();
            req.setAttribute("dishes", dishes);
            req.getRequestDispatcher("/menu.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
