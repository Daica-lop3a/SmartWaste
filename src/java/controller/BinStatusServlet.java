package controller;

import dao.WasteBinDAO;
import model.WasteBin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/bin/status")
public class BinStatusServlet extends HttpServlet {

    private final WasteBinDAO binDAO = new WasteBinDAO();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        List<WasteBin> list = binDAO.getAll();

        PrintWriter out = resp.getWriter();

        out.print("[");

        for (int i = 0; i < list.size(); i++) {

            WasteBin bin = list.get(i);

            if (i > 0) {
                out.print(",");
            }

            out.print("{");

            out.print("\"binID\":\""
                    + escape(bin.getBinID())
                    + "\",");

            out.print("\"binCode\":\""
                    + escape(bin.getBinCode())
                    + "\",");

            out.print("\"currentFill\":"
                    + bin.getCurrentFill()
                    + ",");

            out.print("\"status\":\""
                    + escape(bin.getStatus())
                    + "\"");

            out.print("}");
        }

        out.print("]");
    }

    private String escape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}
