package controller.admin;

import dao.DishDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/dishes"})
public class DishListServlet extends HttpServlet {
    private final DishDao dao = new DishDao();

//    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
//            throws ServletException, IOException {
//        try {
//            List<Dish> dishes = dao.findAll();
//            req.setAttribute("dishes", dishes);
//            req.getRequestDispatcher("/admin/dishes.jsp").forward(req, resp);
//        } catch (Exception e) { throw new ServletException(e); }
//    }
        @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        try {
            List<Dish> dishes = (q != null && !q.trim().isEmpty())
                    ? dao.search(q)
                    : dao.findAll();                 
            req.setAttribute("dishes", dishes);
            req.setAttribute("q", q);
            req.getRequestDispatcher("/admin/dishes.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
