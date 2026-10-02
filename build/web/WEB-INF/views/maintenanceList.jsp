<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Maintenance"%>
<%@page import="model.AppUser"%>

<%
    AppUser user
            = (AppUser) session.getAttribute("user");

    String role
            = user != null
                    ? user.getRoleId()
                    : "";

    boolean canManage
            = "ADM".equals(role)
            || "MGR".equals(role);

    boolean isTechnician
            = "TEC".equals(role);

    List<Maintenance> list
            = (List<Maintenance>) request.getAttribute("LIST_MAINTENANCE");

    String error
            = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Maintenance Management</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background-color: #f7f7f7;
            }

            .container {
                max-width: 1400px;
                margin: auto;
                background-color: white;
                padding: 25px;
                border-radius: 8px;
            }

            h2 {
                margin-bottom: 20px;
            }

            .top-bar {
                margin-bottom: 20px;
            }

            .btn {
                display: inline-block;
                padding: 8px 14px;
                margin-right: 5px;
                text-decoration: none;
                border-radius: 5px;
                cursor: pointer;
                border: none;
            }

            .btn-dashboard {
                background-color: #6c757d;
                color: white;
            }

            .btn-add {
                background-color: #198754;
                color: white;
            }

            .btn-view {
                background-color: #0d6efd;
                color: white;
            }

            .btn-edit {
                background-color: #ffc107;
                color: black;
            }

            .btn-delete {
                background-color: #dc3545;
                color: white;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            th {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #fafafa;
            }

            .pending {
                color: #d97706;
                font-weight: bold;
            }

            .progress {
                color: #2563eb;
                font-weight: bold;
            }

            .completed {
                color: #198754;
                font-weight: bold;
            }

            .cancelled {
                color: #dc3545;
                font-weight: bold;
            }

            .action {
                white-space: nowrap;
            }

            form {
                display: inline;
            }

            .error {
                color: #dc3545;
                margin-bottom: 15px;
                font-weight: bold;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h2>Maintenance Management</h2>

            <div class="top-bar">

                <a class="btn btn-dashboard"
                   href="<%=request.getContextPath()%>/dashboard">
                    Dashboard
                </a>

                <% if (canManage) {%>

                <a class="btn btn-add"
                   href="<%=request.getContextPath()%>/maintenance/create">
                    Add Maintenance
                </a>

                <% } %>

            </div>

            <% if (error != null) {%>

            <div class="error">
                <%=error%>
            </div>

            <% } %>

            <table>

                <thead>

                    <tr>

                        <th>Maintenance ID</th>
                        <th>Bin ID</th>
                        <th>Technician</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Scheduled Date</th>
                        <th>Completed Date</th>
                        <th>Action</th>

                    </tr>

                </thead>

                <tbody>

                    <% if (list != null && !list.isEmpty()) { %>

                    <% for (Maintenance maintenance : list) { %>

                    <%
                        String statusClass = "";

                        if ("Pending".equals(
                                maintenance.getStatus())) {

                            statusClass = "pending";

                        } else if ("In_Progress".equals(
                                maintenance.getStatus())) {

                            statusClass = "progress";

                        } else if ("Completed".equals(
                                maintenance.getStatus())) {

                            statusClass = "completed";

                        } else if ("Cancelled".equals(
                                maintenance.getStatus())) {

                            statusClass = "cancelled";
                        }
                    %>

                    <tr>

                        <td>
                            <%=maintenance.getMaintenanceID()%>
                        </td>

                        <td>
                            <%=maintenance.getBinID()%>
                        </td>

                        <td>
                            <%=maintenance.getTechnicianID()%>
                        </td>

                        <td>
                            <%=maintenance.getMaintenanceType()%>
                        </td>

                        <td class="<%=statusClass%>">
                            <%=maintenance.getStatus()%>
                        </td>

                        <td>
                            <%=maintenance.getScheduledDate() == null
                                    ? ""
                                    : maintenance.getScheduledDate()%>
                        </td>

                        <td>
                            <%=maintenance.getCompletedDate() == null
                                    ? ""
                                    : maintenance.getCompletedDate()%>
                        </td>

                        <td class="action">

                            <!-- VIEW -->

                            <a class="btn btn-view"
                               href="<%=request.getContextPath()%>/maintenance/view?id=<%=maintenance.getMaintenanceID()%>">
                                View
                            </a>

                            <!-- EDIT -->

                            <% if (canManage
                                    || (isTechnician
                                    && user.getUserId().equals(
                                            maintenance.getTechnicianID()))) {%>

                            <a class="btn btn-edit"
                               href="<%=request.getContextPath()%>/maintenance/edit?id=<%=maintenance.getMaintenanceID()%>">
                                Edit
                            </a>

                            <% } %>

                            <!-- DELETE -->

                            <% if (canManage) {%>

                            <form method="post"
                                  action="<%=request.getContextPath()%>/maintenance/delete"
                                  onsubmit="return confirm('Bạn có chắc muốn xóa Maintenance này không?');">

                                <input type="hidden"
                                       name="id"
                                       value="<%=maintenance.getMaintenanceID()%>">

                                <button class="btn btn-delete"
                                        type="submit">
                                    Delete
                                </button>

                            </form>

                            <% } %>

                        </td>

                    </tr>

                    <% } %>

                    <% } else { %>

                    <tr>

                        <td colspan="8"
                            style="text-align:center;">
                            No maintenance records found.
                        </td>

                    </tr>

                    <% }%>

                </tbody>

            </table>

        </div>

    </body>

</html>