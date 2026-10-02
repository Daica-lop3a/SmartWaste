package controller;

import dao.AreaDAO;
import dao.WasteBinDAO;
import model.Area;
import model.WasteBin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/wastebin/*")
public class WasteBinServlet extends HttpServlet {

    private static final String BIN_LIST =
            "/WEB-INF/views/wasteBinList.jsp";

    private static final String BIN_FORM =
            "/WEB-INF/views/wasteBinForm.jsp";

    private static final String BIN_DETAIL =
            "/WEB-INF/views/binDetail.jsp";

    private final WasteBinDAO bins = new WasteBinDAO();
    private final AreaDAO areas = new AreaDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();

        // LIST
        if (path == null || "/".equals(path)) {
            showList(request, response);
            return;
        }

        // CREATE
        if ("/create".equals(path)) {
            showForm(request, response, null);
            return;
        }

        // VIEW
        if ("/view".equals(path)) {

            String binID = request.getParameter("id");

            if (binID == null || binID.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/wastebin"
                );
                return;
            }

            WasteBin bin = bins.findByID(binID);

            if (bin == null) {
                request.setAttribute(
                        "ERROR",
                        "Waste bin not found."
                );

                showList(request, response);
                return;
            }

            request.setAttribute("BIN", bin);

            request.getRequestDispatcher(BIN_DETAIL)
                    .forward(request, response);

            return;
        }

        // EDIT
        if ("/edit".equals(path)) {

            String binID = request.getParameter("id");

            if (binID == null || binID.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/wastebin"
                );
                return;
            }

            WasteBin bin = bins.findByID(binID);

            if (bin == null) {

                request.setAttribute(
                        "ERROR",
                        "Waste bin not found."
                );

                showList(request, response);
                return;
            }

            showForm(request, response, bin);
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

        // SAVE
        if ("/save".equals(path)) {
            save(request, response);
            return;
        }

        // DELETE
        if ("/delete".equals(path)) {
            delete(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/wastebin"
        );
    }

    private void showList(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "LIST_BIN",
                bins.getAll()
        );

        request.getRequestDispatcher(BIN_LIST)
                .forward(request, response);
    }

    private void showForm(HttpServletRequest request,
            HttpServletResponse response,
            WasteBin bin)
            throws ServletException, IOException {

        request.setAttribute("BIN", bin);

        request.setAttribute(
                "LIST_AREA",
                areas.getAll()
        );

        request.getRequestDispatcher(BIN_FORM)
                .forward(request, response);
    }

    private void save(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String binID = request.getParameter("binID");
        String binCode = request.getParameter("binCode");
        String location = request.getParameter("location");
        String capacityRaw = request.getParameter("capacity");
        String status = request.getParameter("status");
        String areaID = request.getParameter("areaID");

        if (binID != null) {
            binID = binID.trim();
        }

        if (binCode != null) {
            binCode = binCode.trim();
        }

        if (location != null) {
            location = location.trim();
        }

        if (status != null) {
            status = status.trim();
        }

        if (areaID != null) {
            areaID = areaID.trim();
        }

        // BIN ID
        if (binID == null || binID.isEmpty()) {

            request.setAttribute(
                    "ERROR",
                    "Bin ID is required."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        // BIN CODE
        if (binCode == null || binCode.isEmpty()) {

            request.setAttribute(
                    "ERROR",
                    "Bin code is required."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        // CAPACITY
        double capacity;

        try {

            capacity = Double.parseDouble(capacityRaw);

        } catch (Exception e) {

            request.setAttribute(
                    "ERROR",
                    "Capacity must be a number."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        if (capacity <= 0) {

            request.setAttribute(
                    "ERROR",
                    "Capacity must be greater than 0."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        // AREA
        if (areaID == null || areaID.isEmpty()) {

            request.setAttribute(
                    "ERROR",
                    "Area is required."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        Area area = areas.findById(areaID);

        if (area == null) {

            request.setAttribute(
                    "ERROR",
                    "Selected area does not exist."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        WasteBin oldBin = bins.findByID(binID);

        boolean success;

        // CREATE
        if (oldBin == null) {

            WasteBin bin = new WasteBin();

            bin.setBinID(binID);
            bin.setBinCode(binCode);
            bin.setLocation(location);
            bin.setCapacity(capacity);

            // Sensor will update this value later
            bin.setCurrentFill(0);

            bin.setStatus(status);
            bin.setAreaID(areaID);

            success = bins.insert(bin);

        } else {

            // UPDATE

            oldBin.setBinCode(binCode);
            oldBin.setLocation(location);
            oldBin.setCapacity(capacity);

            // DO NOT change currentFill manually
            oldBin.setStatus(status);
            oldBin.setAreaID(areaID);

            success = bins.update(oldBin);
        }

        if (!success) {

            request.setAttribute(
                    "ERROR",
                    "Cannot save waste bin."
            );

            showFormWithValues(
                    request,
                    response,
                    binID,
                    binCode,
                    location,
                    capacityRaw,
                    status,
                    areaID
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/wastebin"
        );
    }

    private void delete(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String binID = request.getParameter("id");

        if (binID != null && !binID.trim().isEmpty()) {
            bins.delete(binID);
        }

        response.sendRedirect(
                request.getContextPath() + "/wastebin"
        );
    }

    private void showFormWithValues(
            HttpServletRequest request,
            HttpServletResponse response,
            String binID,
            String binCode,
            String location,
            String capacityRaw,
            String status,
            String areaID)
            throws ServletException, IOException {

        WasteBin bin = new WasteBin();

        bin.setBinID(binID);
        bin.setBinCode(binCode);
        bin.setLocation(location);
        bin.setStatus(status);
        bin.setAreaID(areaID);

        try {
            bin.setCapacity(
                    Double.parseDouble(capacityRaw)
            );
        } catch (Exception e) {
            bin.setCapacity(0);
        }

        /*
         * Current Fill is controlled by sensor.
         * Therefore, when validation fails,
         * we don't take currentFill from the form.
         */
        bin.setCurrentFill(0);

        request.setAttribute("BIN", bin);

        request.setAttribute(
                "LIST_AREA",
                areas.getAll()
        );

        request.getRequestDispatcher(BIN_FORM)
                .forward(request, response);
    }
}