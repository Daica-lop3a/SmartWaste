package controller;

import dao.AlertDAO;
import dao.AreaAssignmentDAO;
import dao.CollectionDAO;
import dao.UserDAO;
import dao.WasteBinDAO;

import model.AppUser;
import model.CollectionRequest;
import model.WasteBin;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/collection/*")
public class CollectionServlet extends HttpServlet {

    private static final String LIST
            = "/WEB-INF/views/collectionList.jsp";

    private static final String FORM
            = "/WEB-INF/views/collectionForm.jsp";

    private static final String DETAIL
            = "/WEB-INF/views/collectionDetail.jsp";

    private final CollectionDAO collections
            = new CollectionDAO();

    private final WasteBinDAO bins
            = new WasteBinDAO();

    private final UserDAO users
            = new UserDAO();

    private final AlertDAO alerts
            = new AlertDAO();

    private final AreaAssignmentDAO assignments
            = new AreaAssignmentDAO();

    // =========================================================
    // GET
    // =========================================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path == null || "/".equals(path)) {
            showList(request, response);
            return;
        }

        if ("/create".equals(path)) {
            createForm(request, response);
            return;
        }

        if ("/view".equals(path)) {
            view(request, response);
            return;
        }

        if ("/edit".equals(path)) {
            editForm(request, response);
            return;
        }

        /*
         * AJAX:
         * Lấy Staff theo Area của Waste Bin.
         */
        if ("/staff-by-bin".equals(path)) {
            staffByBin(request, response);
            return;
        }

        showList(request, response);
    }

    // =========================================================
    // POST
    // =========================================================
    @Override
    protected void doPost(
            HttpServletRequest request,
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

        showList(request, response);
    }

    // =========================================================
    // STAFF BY BIN
    // =========================================================
    private void staffByBin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType(
                "application/json;charset=UTF-8");

        AppUser currentUser
                = getCurrentUser(request);

        /*
         * Chưa login.
         */
        if (currentUser == null) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED);

            response.getWriter().write("[]");
            return;
        }

        String binID
                = request.getParameter("binID");

        if (binID == null
                || binID.trim().isEmpty()) {

            response.getWriter().write("[]");
            return;
        }

        WasteBin bin
                = bins.findByID(binID);

        if (bin == null
                || bin.getAreaID() == null
                || bin.getAreaID().trim().isEmpty()) {

            response.getWriter().write("[]");
            return;
        }

        String role
                = currentUser.getRoleId();

        /*
         * MANAGER chỉ được xem Staff
         * trong Area mình quản lý.
         */
        if ("MGR".equals(role)) {

            boolean managerOfArea
                    = assignments.isManagerOfArea(
                            currentUser.getUserId(),
                            bin.getAreaID());

            if (!managerOfArea) {

                response.setStatus(
                        HttpServletResponse.SC_FORBIDDEN);

                response.getWriter().write("[]");
                return;
            }
        }

        /*
         * Chỉ ADM + MGR được load Staff
         * để tạo Collection Request.
         */
        if (!"ADM".equals(role)
                && !"MGR".equals(role)) {

            response.setStatus(
                    HttpServletResponse.SC_FORBIDDEN);

            response.getWriter().write("[]");
            return;
        }

        /*
         * Lấy Staff thuộc Area của Bin.
         */
        List<AppUser> staffList
                = assignments.getStaffByArea(
                        bin.getAreaID());

        StringBuilder json
                = new StringBuilder();

        json.append("[");

        for (int i = 0;
                i < staffList.size();
                i++) {

            AppUser staff
                    = staffList.get(i);

            if (i > 0) {
                json.append(",");
            }

            json.append("{");

            json.append("\"userID\":\"")
                    .append(jsonEscape(
                            staff.getUserId()))
                    .append("\",");

            json.append("\"fullName\":\"")
                    .append(jsonEscape(
                            staff.getFullName()))
                    .append("\"");

            json.append("}");
        }

        json.append("]");

        response.getWriter()
                .write(json.toString());
    }

    // =========================================================
    // JSON ESCAPE
    // =========================================================
    private String jsonEscape(
            String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }

    // =========================================================
    // LIST
    // =========================================================
    private void showList(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String role
                = currentUser.getRoleId();

        if ("STF".equals(role)) {

            /*
             * STAFF chỉ xem request được giao cho mình.
             */
            request.setAttribute(
                    "LIST_COLLECTION",
                    collections.getByStaff(
                            currentUser.getUserId()));

        } else {

            /*
             * ADMIN + MANAGER xem Collection Request.
             */
            request.setAttribute(
                    "LIST_COLLECTION",
                    collections.getAll());
        }

        request.getRequestDispatcher(LIST)
                .forward(request, response);
    }

    // =========================================================
    // CREATE FORM
    // =========================================================
    private void createForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        String role
                = currentUser.getRoleId();

        /*
         * STAFF không được tạo request.
         */
        if ("STF".equals(role)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");
            return;
        }

        CollectionRequest collection
                = new CollectionRequest();

        collection.setRequestID("");
        collection.setStatus("Pending");
        collection.setPriority("Normal");

        collection.setCreatedDate(
                new Timestamp(
                        System.currentTimeMillis()));

        String binID
                = request.getParameter("binID");

        if (binID != null
                && !binID.trim().isEmpty()) {

            collection.setBinID(binID);
        }

        showForm(
                request,
                response,
                collection);
    }

    // =========================================================
    // VIEW
    // =========================================================
    private void view(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String requestID
                = request.getParameter("id");

        if (requestID == null
                || requestID.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");
            return;
        }

        CollectionRequest collection
                = collections.findByID(requestID);

        if (collection == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");
            return;
        }

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login");
            return;
        }

        /*
         * STAFF chỉ xem request của mình.
         */
        if ("STF".equals(
                currentUser.getRoleId())) {

            if (!currentUser.getUserId().equals(
                    collection.getStaffID())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/collection");
                return;
            }
        }

        request.setAttribute(
                "REQUEST",
                collection);

        request.getRequestDispatcher(DETAIL)
                .forward(request, response);
    }

    // =========================================================
    // EDIT FORM
    // =========================================================
    private void editForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String requestID
                = request.getParameter("id");

        if (requestID == null
                || requestID.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");
            return;
        }

        CollectionRequest collection
                = collections.findByID(requestID);

        if (collection == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");
            return;
        }

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login");
            return;
        }

        String role
                = currentUser.getRoleId();

        /*
         * STAFF chỉ được edit request của mình.
         */
        if ("STF".equals(role)) {

            if (!currentUser.getUserId().equals(
                    collection.getStaffID())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/collection");
                return;
            }
        }

        /*
         * MANAGER phải quản lý Area của Bin.
         */
        if ("MGR".equals(role)) {

            WasteBin bin
                    = bins.findByID(
                            collection.getBinID());

            if (bin == null
                    || !assignments.isManagerOfArea(
                            currentUser.getUserId(),
                            bin.getAreaID())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/collection");
                return;
            }
        }

        showForm(
                request,
                response,
                collection);
    }

    // =========================================================
    // FORM
    // =========================================================
    private void showForm(
            HttpServletRequest request,
            HttpServletResponse response,
            CollectionRequest collection)
            throws ServletException, IOException {

        request.setAttribute(
                "REQUEST",
                collection);

        /*
         * Load toàn bộ Waste Bin.
         */
        request.setAttribute(
                "LIST_BIN",
                bins.getAll());

        List<AppUser> staffList
                = new ArrayList<>();

        String binID
                = collection.getBinID();

        AppUser currentUser
                = getCurrentUser(request);

        /*
         * Nếu đã có Bin:
         * chỉ load Staff thuộc Area của Bin.
         */
        if (binID != null
                && !binID.trim().isEmpty()) {

            WasteBin bin
                    = bins.findByID(binID);

            if (bin != null) {

                staffList
                        = assignments.getStaffByArea(
                                bin.getAreaID());
            }

        } else {

            /*
             * Chưa chọn Bin.
             *
             * ADMIN có thể thấy toàn bộ Staff.
             *
             * MANAGER chưa xác định Area
             * nên chưa load Staff.
             */
            if (currentUser != null
                    && "ADM".equals(
                            currentUser.getRoleId())) {

                staffList
                        = users.search("", "STF");
            }
        }

        request.setAttribute(
                "LIST_STAFF",
                staffList);

        request.getRequestDispatcher(FORM)
                .forward(request, response);
    }

    // =========================================================
    // SAVE
    // =========================================================
    private void save(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login");
            return;
        }

        String role
                = currentUser.getRoleId();

        String requestID
                = request.getParameter("requestID");

        String binID
                = request.getParameter("binID");

        String staffID
                = request.getParameter("staffID");

        String status
                = request.getParameter("status");

        String priority
                = request.getParameter("priority");

        String notes
                = request.getParameter("notes");

        // -----------------------------------------------------
        // REQUEST ID
        // -----------------------------------------------------
        if (requestID == null
                || requestID.trim().isEmpty()) {

            requestID
                    = "REQ"
                    + System.currentTimeMillis();
        }

        // -----------------------------------------------------
        // BIN
        // -----------------------------------------------------
        if (binID == null
                || binID.trim().isEmpty()) {

            returnWithError(
                    request,
                    response,
                    "Waste Bin is required.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        WasteBin bin
                = bins.findByID(binID);

        if (bin == null) {

            returnWithError(
                    request,
                    response,
                    "Waste Bin does not exist.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        // -----------------------------------------------------
        // MANAGER - AREA PERMISSION
        // -----------------------------------------------------
        if ("MGR".equals(role)) {

            boolean managerOfArea
                    = assignments.isManagerOfArea(
                            currentUser.getUserId(),
                            bin.getAreaID());

            if (!managerOfArea) {

                returnWithError(
                        request,
                        response,
                        "You can only create collection requests for bins in your managed areas.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }
        }

        // -----------------------------------------------------
        // STATUS
        // -----------------------------------------------------
        if (status == null
                || status.trim().isEmpty()) {

            status = "Pending";
        }

        if (!status.equals("Pending")
                && !status.equals("In_Progress")
                && !status.equals("Completed")
                && !status.equals("Cancelled")) {

            returnWithError(
                    request,
                    response,
                    "Invalid status.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        // -----------------------------------------------------
        // PRIORITY
        // -----------------------------------------------------
        if (priority == null
                || priority.trim().isEmpty()) {

            priority = "Normal";
        }

        if (!priority.equals("Low")
                && !priority.equals("Normal")
                && !priority.equals("High")
                && !priority.equals("Emergency")) {

            returnWithError(
                    request,
                    response,
                    "Invalid priority.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        // -----------------------------------------------------
        // STAFF
        // -----------------------------------------------------
        if (staffID == null
                || staffID.trim().isEmpty()) {

            returnWithError(
                    request,
                    response,
                    "Staff is required.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        AppUser staff
                = users.findById(staffID);

        if (staff == null
                || !"STF".equals(
                        staff.getRoleId())) {

            returnWithError(
                    request,
                    response,
                    "Selected Staff is invalid.",
                    requestID,
                    binID,
                    staffID,
                    status,
                    priority,
                    notes);

            return;
        }

        /*
         * MANAGER:
         * Staff phải thuộc cùng Area với Bin.
         */
        if ("MGR".equals(role)) {

            boolean staffOfArea
                    = assignments.isStaffOfArea(
                            staffID,
                            bin.getAreaID());

            if (!staffOfArea) {

                returnWithError(
                        request,
                        response,
                        "Selected Staff does not belong to the Bin's Area.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }
        }

        // -----------------------------------------------------
        // OLD REQUEST
        // -----------------------------------------------------
        CollectionRequest oldRequest
                = collections.findByID(requestID);

        // -----------------------------------------------------
        // STAFF PERMISSION
        // -----------------------------------------------------
        if ("STF".equals(role)) {

            /*
             * STAFF không được tạo mới.
             */
            if (oldRequest == null) {

                returnWithError(
                        request,
                        response,
                        "Staff cannot create collection requests.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }

            /*
             * STAFF chỉ sửa request của mình.
             */
            if (!currentUser.getUserId().equals(
                    oldRequest.getStaffID())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/collection");
                return;
            }

            /*
             * STAFF không đổi Bin.
             */
            if (!oldRequest.getBinID().equals(
                    binID)) {

                returnWithError(
                        request,
                        response,
                        "Staff cannot change the Waste Bin.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }

            /*
             * STAFF không đổi người được giao.
             */
            if (!oldRequest.getStaffID().equals(
                    staffID)) {

                returnWithError(
                        request,
                        response,
                        "Staff cannot change the assigned Staff.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }

            /*
             * STAFF không Cancel.
             */
            if ("Cancelled".equals(status)) {

                returnWithError(
                        request,
                        response,
                        "Staff cannot cancel collection requests.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }
        }

        // -----------------------------------------------------
        // CREATE / UPDATE
        // -----------------------------------------------------
        CollectionRequest collection;

        if (oldRequest == null) {

            collection
                    = new CollectionRequest();

            collection.setRequestID(
                    requestID);

            collection.setCreatedDate(
                    new Timestamp(
                            System.currentTimeMillis()));

        } else {

            collection = oldRequest;
        }

        collection.setBinID(binID);
        collection.setStaffID(staffID);
        collection.setStatus(status);
        collection.setPriority(priority);
        collection.setNotes(notes);

        // -----------------------------------------------------
        // INSERT
        // -----------------------------------------------------
        if (oldRequest == null) {

            boolean success
                    = collections.insert(
                            collection);

            if (!success) {

                returnWithError(
                        request,
                        response,
                        "Failed to create Collection Request.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }

        } else {

            // -------------------------------------------------
            // UPDATE
            // -------------------------------------------------
            boolean success
                    = collections.update(
                            collection);

            if (!success) {

                returnWithError(
                        request,
                        response,
                        "Failed to update Collection Request.",
                        requestID,
                        binID,
                        staffID,
                        status,
                        priority,
                        notes);

                return;
            }
        }

        // -----------------------------------------------------
        // COMPLETED
        // -----------------------------------------------------
        if ("Completed".equals(status)) {

            completeCollection(binID);
        }

        // -----------------------------------------------------
        // DONE
        // -----------------------------------------------------
        response.sendRedirect(
                request.getContextPath()
                + "/collection");
    }

    // =========================================================
    // COMPLETE COLLECTION
    // =========================================================
    private void completeCollection(
            String binID) {

        if (binID == null
                || binID.trim().isEmpty()) {
            return;
        }

        /*
         * Thu gom xong:
         * Bin về 0%.
         */
        bins.updateCurrentFill(
                binID,
                0);

        /*
         * Resolve High_Fill Alert.
         */
        alerts.resolveUnresolvedHighFillAlerts(
                binID);
    }

    // =========================================================
    // DELETE
    // =========================================================
    private void delete(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        AppUser currentUser
                = getCurrentUser(request);

        if (currentUser == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login");
            return;
        }

        String role
                = currentUser.getRoleId();

        /*
         * Chỉ ADMIN + MANAGER được delete.
         */
        if (!"ADM".equals(role)
                && !"MGR".equals(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");

            return;
        }

        String requestID
                = request.getParameter("id");

        if (requestID == null
                || requestID.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");

            return;
        }

        CollectionRequest collection
                = collections.findByID(requestID);

        if (collection == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/collection");

            return;
        }

        /*
         * MANAGER chỉ delete request
         * thuộc Area mình quản lý.
         */
        if ("MGR".equals(role)) {

            WasteBin bin
                    = bins.findByID(
                            collection.getBinID());

            if (bin == null
                    || !assignments.isManagerOfArea(
                            currentUser.getUserId(),
                            bin.getAreaID())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/collection");

                return;
            }
        }

        collections.delete(requestID);

        response.sendRedirect(
                request.getContextPath()
                + "/collection");
    }

    // =========================================================
    // ERROR -> SHOW FORM
    // =========================================================
    private void returnWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message,
            String requestID,
            String binID,
            String staffID,
            String status,
            String priority,
            String notes)
            throws ServletException, IOException {

        request.setAttribute(
                "ERROR",
                message);

        showFormWithValues(
                request,
                response,
                requestID,
                binID,
                staffID,
                status,
                priority,
                notes);
    }

    // =========================================================
    // SHOW FORM WITH VALUES
    // =========================================================
    private void showFormWithValues(
            HttpServletRequest request,
            HttpServletResponse response,
            String requestID,
            String binID,
            String staffID,
            String status,
            String priority,
            String notes)
            throws ServletException, IOException {

        CollectionRequest collection
                = new CollectionRequest();

        collection.setRequestID(requestID);
        collection.setBinID(binID);
        collection.setStaffID(staffID);
        collection.setStatus(status);
        collection.setPriority(priority);
        collection.setNotes(notes);

        CollectionRequest oldRequest
                = collections.findByID(requestID);

        if (oldRequest != null) {

            collection.setCreatedDate(
                    oldRequest.getCreatedDate());

        } else {

            collection.setCreatedDate(
                    new Timestamp(
                            System.currentTimeMillis()));
        }

        showForm(
                request,
                response,
                collection);
    }

    // =========================================================
    // CURRENT USER
    // =========================================================
    private AppUser getCurrentUser(
            HttpServletRequest request) {

        HttpSession session
                = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object obj
                = session.getAttribute("user");

        if (obj instanceof AppUser) {
            return (AppUser) obj;
        }

        return null;
    }
}