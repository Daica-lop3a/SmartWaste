package controller;

import dao.BinReadingDAO;
import dao.WasteBinDAO;
import model.BinReading;
import model.WasteBin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/wastebin/detail")
public class BinDetailServlet extends HttpServlet {

    private final WasteBinDAO binDAO = new WasteBinDAO();
    private final BinReadingDAO readingDAO = new BinReadingDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String binID = req.getParameter("binID");

        if (binID == null || binID.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/wastebin");
            return;
        }

        WasteBin bin = binDAO.findByID(binID);

        if (bin == null) {
            resp.sendRedirect(req.getContextPath() + "/wastebin");
            return;
        }

        List<BinReading> readings = readingDAO.getByBin(binID);

        req.setAttribute("BIN", bin);
        req.setAttribute("READINGS", readings);

        req.getRequestDispatcher(
                "/WEB-INF/views/binDetail.jsp"
        ).forward(req, resp);
    }
}