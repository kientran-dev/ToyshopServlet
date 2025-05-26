package com.kiendey.servlet.test;

import com.kiendey.dao.ToyDAO;
import com.kiendey.dao.impl.ToyDAOImpl;
import com.kiendey.model.Permission;
import com.kiendey.model.Role;
import com.kiendey.model.Toy;
import com.kiendey.model.User;
import com.kiendey.utils.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.xml.transform.Result;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/init")
public class InitServlet extends HttpServlet {
    private EntityManagerFactory emf;



    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        resp.setContentType("text/html;charset=UTF-8");

        try {
            ToyDAOImpl toyDAO = new ToyDAOImpl();
            List<Toy> toys = toyDAO.getAllToys();
            out.println("<html>Laay thanh cong<body>");
        } catch (Exception e) {
            out.println("<html>Khong the lay du lieu <body>");
        }


    }


    @Override
    public void destroy() {
        emf.close();
    }
}
