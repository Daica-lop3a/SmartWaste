package controller;

import dao.AreaAssignmentDAO;
import dao.AreaDAO;
import model.Area;
import model.AppUser;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/area/*")
public class AreaServlet extends HttpServlet {

    private static final String AREA_LIST
            = "/WEB-INF/views/areaList.jsp";

    private static final String AREA_FORM
            = "/WEB-INF/views/areaForm.jsp";

    private final AreaDAO areas = new AreaDAO();
    private final AreaAssignmentDAO assignments = new AreaAssignmentDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String path = request.getPathInfo();

        if (path == null || "/".equals(path)) {
            showList(request, response);
            return;
        }

        if ("/create".equals(path)) {
            showForm(request, response, null);
            return;
        }

        if ("/view".equals(path)) {

            String areaId = request.getParameter("id");

            if (areaId == null || areaId.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/area"
                );
                return;
            }

            if (!canAccessArea(request, areaId)) {
                request.setAttribute(
                        "ERROR",
                        "You do not have permission to access this area."
                );

                showList(request, response);
                return;
            }

            Area area = areas.findById(areaId);

            if (area == null) {
                request.setAttribute(
                        "ERROR",
                        "Area not found."
                );

                showList(request, response);
                return;
            }

            request.setAttribute("AREA", area);

            request.getRequestDispatcher(
                    "/WEB-INF/views/areaDetail.jsp"
            ).forward(request, response);

            return;
        }

        if ("/edit".equals(path)) {

            String areaId = request.getParameter("id");

            if (areaId == null || areaId.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/area"
                );
                return;
            }

            if (!canAccessArea(request, areaId)) {
                request.setAttribute(
                        "ERROR",
                        "You do not have permission to edit this area."
                );

                showList(request, response);
                return;
            }

            Area area = areas.findById(areaId);

            if (area == null) {
                request.setAttribute(
                        "ERROR",
                        "Area not found."
                );

                showList(request, response);
                return;
            }

            showForm(request, response, area);
            return;
        }

        showList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();

        if ("/save".equals(path)) {
            save(request, response);
            return;
        }

        if ("/delete".equals(path)) {
            delete(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/area"
        );
    }

    private void showList(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        AppUser user = (AppUser) session.getAttribute("user");

        String role = user.getRoleId();

        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String order = request.getParameter("order");

        if (search == null) {
            search = "";
        }

        if (sort == null || sort.isEmpty()) {
            sort = "areaId";
        }

        if (order == null || order.isEmpty()) {
            order = "ASC";
        }

        if ("MGR".equals(role)) {

            request.setAttribute(
                    "LIST_AREA",
                    areas.getFilteredByManager(
                            user.getUserId(),
                            search,
                            sort,
                            order
                    )
            );

        } else {

            request.setAttribute(
                    "LIST_AREA",
                    areas.getFiltered(
                            search,
                            sort,
                            order
                    )
            );
        }

        request.setAttribute("SEARCH", search);
        request.setAttribute("SORT", sort);
        request.setAttribute("ORDER", order);

        request.getRequestDispatcher(AREA_LIST)
                .forward(request, response);
    }

    private void showForm(HttpServletRequest request,
            HttpServletResponse response,
            Area area)
            throws ServletException, IOException {

        request.setAttribute("AREA", area);

        request.getRequestDispatcher(AREA_FORM)
                .forward(request, response);
    }

    private void save(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String areaId = request.getParameter("areaId");
        String areaName = request.getParameter("areaName");
        String description = request.getParameter("description");

        if (areaId != null) {
            areaId = areaId.trim();
        }

        if (areaName != null) {
            areaName = areaName.trim();
        }

        if (description != null) {
            description = description.trim();
        }

        if (areaId == null || areaId.isEmpty()) {
            request.setAttribute(
                    "ERROR",
                    "Area ID is required."
            );
            showFormWithValues(
                    request,
                    response,
                    areaId,
                    areaName,
                    description
            );
            return;
        }

        if (areaName == null || areaName.isEmpty()) {
            request.setAttribute(
                    "ERROR",
                    "Area name is required."
            );
            showFormWithValues(
                    request,
                    response,
                    areaId,
                    areaName,
                    description
            );
            return;
        }

        Area oldArea = areas.findById(areaId);

        boolean success;

        if (oldArea == null) {

            Area area = new Area(
                    areaId,
                    areaName,
                    description
            );

            success = areas.insert(area);

        } else {

            oldArea.setAreaName(areaName);
            oldArea.setDescription(description);

            success = areas.update(oldArea);
        }

        if (!success) {
            request.setAttribute(
                    "ERROR",
                    "Cannot save area."
            );

            showFormWithValues(
                    request,
                    response,
                    areaId,
                    areaName,
                    description
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/area"
        );
    }

    private void delete(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, ServletException {

        String areaId = request.getParameter("id");

        if (areaId == null || areaId.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/area"
            );
            return;
        }

        if (!canAccessArea(request, areaId)) {

            request.setAttribute(
                    "ERROR",
                    "You do not have permission to delete this area."
            );

            showList(request, response);
            return;
        }

        areas.delete(areaId);

        response.sendRedirect(
                request.getContextPath() + "/area"
        );
    }

    private void showFormWithValues(
            HttpServletRequest request,
            HttpServletResponse response,
            String areaId,
            String areaName,
            String description)
            throws ServletException, IOException {

        Area area = new Area(
                areaId,
                areaName,
                description
        );

        request.setAttribute("AREA", area);

        request.getRequestDispatcher(AREA_FORM)
                .forward(request, response);
    }

    private boolean canAccessArea(HttpServletRequest request,
            String areaId) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        AppUser user = (AppUser) session.getAttribute("user");

        if (user == null) {
            return false;
        }

        String role = user.getRoleId();

        if ("ADM".equals(role)) {
            return true;
        }

        if ("MGR".equals(role)) {
            return assignments.isManagerOfArea(
                    user.getUserId(),
                    areaId
            );
        }

        if ("STF".equals(role) || "TEC".equals(role)) {
            return true;
        }

        return false;
    }
}
