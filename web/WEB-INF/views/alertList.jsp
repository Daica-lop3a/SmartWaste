<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Alert"%>
<%@page import="model.AppUser"%>

<%
    AppUser user = (AppUser) session.getAttribute("user");

    boolean canManage
            = user != null
            && ("ADM".equals(user.getRoleId())
            || "MGR".equals(user.getRoleId()));

    List<Alert> list
            = (List<Alert>) request.getAttribute("LIST_ALERT");

    String error = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Alert Management</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background-color: #f7f7f7;
            }

            .container {
                max-width: 1400px;
                margin: auto;
                background: white;
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

            .btn-resolve {
                background-color: #198754;
                color: white;
            }

            .btn-unresolve {
                background-color: #6c757d;
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

            .resolved {
                color: #198754;
                font-weight: bold;
            }

            .unresolved {
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

            <h2>Alert Management</h2>

            <div class="top-bar">

                <a class="btn btn-dashboard"
                   href="<%=request.getContextPath()%>/dashboard">
                    Dashboard
                </a>

                <% if (canManage) {%>

                <a class="btn btn-add"
                   href="<%=request.getContextPath()%>/alert/create">
                    Add Alert
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

                        <th>Alert ID</th>
                        <th>Bin ID</th>
                        <th>Alert Type</th>
                        <th>Message</th>
                        <th>Created Date</th>
                        <th>Status</th>
                        <th>Action</th>

                    </tr>

                </thead>

                <tbody>

                    <% if (list != null && !list.isEmpty()) { %>

                    <% for (Alert alert : list) {%>

                    <tr>

                        <td>
                            <%=alert.getAlertID()%>
                        </td>

                        <td>
                            <%=alert.getBinID()%>
                        </td>

                        <td>
                            <%=alert.getAlertType()%>
                        </td>

                        <td>
                            <%=alert.getMessage()%>
                        </td>

                        <td>
                            <%=alert.getCreatedDate()%>
                        </td>

                        <td>

                            <% if (alert.isResolved()) { %>

                            <span class="resolved">
                                Resolved
                            </span>

                            <% } else { %>

                            <span class="unresolved">
                                Unresolved
                            </span>

                            <% }%>

                        </td>

                        <td class="action">

                            <!-- VIEW -->

                            <a class="btn btn-view"
                               href="<%=request.getContextPath()%>/alert/view?id=<%=alert.getAlertID()%>">
                                View
                            </a>

                            <% if (canManage) {%>

                            <!-- EDIT -->

                            <a class="btn btn-edit"
                               href="<%=request.getContextPath()%>/alert/edit?id=<%=alert.getAlertID()%>">
                                Edit
                            </a>

                            <!-- RESOLVE / UNRESOLVE -->

                            <% if (!alert.isResolved()) {%>

                            <form method="post"
                                  action="<%=request.getContextPath()%>/alert/resolve">

                                <input type="hidden"
                                       name="id"
                                       value="<%=alert.getAlertID()%>">

                                <input type="hidden"
                                       name="value"
                                       value="true">

                                <button class="btn btn-resolve"
                                        type="submit">
                                    Resolve
                                </button>

                            </form>

                            <% } else {%>

                            <form method="post"
                                  action="<%=request.getContextPath()%>/alert/resolve">

                                <input type="hidden"
                                       name="id"
                                       value="<%=alert.getAlertID()%>">

                                <input type="hidden"
                                       name="value"
                                       value="false">

                                <button class="btn btn-unresolve"
                                        type="submit">
                                    Unresolve
                                </button>

                            </form>

                            <% }%>

                            <!-- DELETE -->

                            <form method="post"
                                  action="<%=request.getContextPath()%>/alert/delete"
                                  onsubmit="return confirm('Bạn có chắc muốn xóa Alert này không?');">

                                <input type="hidden"
                                       name="id"
                                       value="<%=alert.getAlertID()%>">

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

                        <td colspan="7"
                            style="text-align:center;">
                            No alerts found.
                        </td>

                    </tr>

                    <% }%>

                </tbody>

            </table>

        </div>

    </body>
</html>