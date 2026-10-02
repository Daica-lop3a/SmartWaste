<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Maintenance"%>
<%@page import="model.AppUser"%>

<%
    Maintenance maintenance
            = (Maintenance) request.getAttribute(
                    "MAINTENANCE");

    AppUser user
            = (AppUser) session.getAttribute("user");

    String role
            = user != null
                    ? user.getRoleId()
                    : "";

    boolean canManage
            = "ADM".equals(role)
            || "MGR".equals(role);

    boolean canEdit
            = canManage
            || ("TEC".equals(role)
            && maintenance != null
            && user.getUserId().equals(
                    maintenance.getTechnicianID()));
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Maintenance Details</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
                margin: 30px;
            }

            .container {
                width: 750px;
                margin: auto;
                background-color: white;
                padding: 25px;
                border-radius: 8px;
            }

            h2 {
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                width: 200px;
                background-color: #f2f2f2;
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

            .description {
                white-space: pre-wrap;
            }

            .btn {
                display: inline-block;
                padding: 9px 16px;
                margin-right: 5px;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            .btn-back {
                background-color: #6c757d;
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

            form {
                display: inline;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h2>Maintenance Details</h2>

            <% if (maintenance != null) { %>

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

            <table>

                <tr>
                    <th>Maintenance ID</th>
                    <td>
                        <%=maintenance.getMaintenanceID()%>
                    </td>
                </tr>

                <tr>
                    <th>Waste Bin</th>
                    <td>
                        <%=maintenance.getBinID()%>
                    </td>
                </tr>

                <tr>
                    <th>Technician</th>
                    <td>
                        <%=maintenance.getTechnicianID()%>
                    </td>
                </tr>

                <tr>
                    <th>Maintenance Type</th>
                    <td>
                        <%=maintenance.getMaintenanceType()%>
                    </td>
                </tr>

                <tr>
                    <th>Status</th>
                    <td class="<%=statusClass%>">
                        <%=maintenance.getStatus()%>
                    </td>
                </tr>

                <tr>
                    <th>Scheduled Date</th>
                    <td>
                        <%=maintenance.getScheduledDate() == null
                                ? ""
                                : maintenance.getScheduledDate()%>
                    </td>
                </tr>

                <tr>
                    <th>Completed Date</th>
                    <td>
                        <%=maintenance.getCompletedDate() == null
                                ? ""
                                : maintenance.getCompletedDate()%>
                    </td>
                </tr>

                <tr>
                    <th>Description</th>
                    <td class="description">
                        <%=maintenance.getDescription() == null
                                || maintenance.getDescription()
                                        .trim().isEmpty()
                                    ? "No description"
                                    : maintenance.getDescription()%>
                    </td>
                </tr>

            </table>


            <!-- EDIT -->

            <% if (canEdit) {%>

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

            <% }%>


            <!-- BACK -->

            <a class="btn btn-back"
               href="<%=request.getContextPath()%>/maintenance">

                Back to Maintenance

            </a>

            <% } else {%>

            <p>Maintenance không tồn tại.</p>

            <a class="btn btn-back"
               href="<%=request.getContextPath()%>/maintenance">

                Back to Maintenance

            </a>

            <% }%>

        </div>

    </body>

</html>