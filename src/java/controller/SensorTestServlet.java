package controller;

import dao.WasteBinDAO;
import model.WasteBin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/sensor-test")
public class SensorTestServlet extends HttpServlet {

    private final WasteBinDAO binDAO = new WasteBinDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login");

            return;
        }

        // Lấy tất cả Waste Bin từ database
        List<WasteBin> bins = binDAO.getAll();

        // Gửi danh sách sang JSP
        req.setAttribute("LIST_BIN", bins);

        req.getRequestDispatcher(
                "/WEB-INF/views/sensorTest.jsp")
           .forward(req, resp);
    }
}
