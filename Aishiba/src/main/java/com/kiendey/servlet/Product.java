package com.kiendey.servlet;

import com.kiendey.dao.ToyDAO;
import com.kiendey.dao.impl.ToyDAOImpl;
import com.kiendey.model.Toy;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/product")
public class Product extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ToyDAO toyDAO;
    private static final int DEFAULT_PAGE_SIZE = 10; // Number of products per page

    @Override
    public void init() throws ServletException {
        super.init();
        toyDAO = new ToyDAOImpl();
        }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                // Keep currentPage as 1 if the parameter is invalid
                currentPage = 1;
            }
        }

        long totalProducts = toyDAO.getTotalToyCount();
        int totalPages = (int) Math.ceil((double) totalProducts / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages>0 ) {
            currentPage = totalPages;
        }
        if (currentPage >1 && totalPages==0) {
            currentPage = 1;
        }


        List<Toy> productList = toyDAO.getToysByPage(currentPage, DEFAULT_PAGE_SIZE);
        req.setAttribute("productList", productList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE); // Send pageSize to JSP if needed

        //Call jsp files
        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null){
            head.include(req, resp);
        }
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null){
            header.include(req, resp);
        }
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null){
            sidebar.include(req, resp);
        }

        RequestDispatcher product = req.getRequestDispatcher("/product.jsp");
        if (product != null){
            product.include(req, resp);
        }
        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null){
            footer.include(req, resp);
        }
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null){
            end.include(req, resp);
        }
    }
}
