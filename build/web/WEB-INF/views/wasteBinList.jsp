<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.WasteBin"%>
<%@page import="model.AppUser"%>

<%
    List<WasteBin> list
            = (List<WasteBin>) request.getAttribute("LIST_BIN");

    String error
            = (String) request.getAttribute("ERROR");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";

    boolean canManage
            = "ADM".equals(role)
            || "MGR".equals(role)
            || "TEC".equals(role);
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Waste Bin Management</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background: #f5f7fa;
            }

            h1 {
                margin-bottom: 20px;
            }

            .top-bar {
                margin-bottom: 20px;
            }

            .btn {
                display: inline-block;
                padding: 9px 14px;
                margin-right: 6px;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background: #2563eb;
                color: white;
            }

            .btn-secondary {
                background: #6b7280;
            }

            .btn-danger {
                background: #dc2626;
            }

            .role-info {
                background: white;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
            }

            .error {
                color: #b91c1c;
                margin-bottom: 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            th {
                background: #e5e7eb;
            }

            form {
                display: inline;
            }

            .fill-green {
                color: #15803d;
                font-weight: bold;
            }

            .fill-yellow {
                color: #ca8a04;
                font-weight: bold;
            }

            .fill-red {
                color: #dc2626;
                font-weight: bold;
            }

        </style>

    </head>

    <body>

        <h1>Waste Bin Management</h1>

        <div class="role-info">

            Logged in as:

            <strong>
                <%=currentUser != null
                        ? currentUser.getFullName()
                        : ""%>
            </strong>

            |

            Role:

            <strong>
                <%=role%>
            </strong>

        </div>


        <div class="top-bar">

            <% if (canManage) {%>

            <a class="btn"
               href="<%=request.getContextPath()%>/wastebin/create">
                Add Waste Bin
            </a>

            <% }%>


            <a class="btn btn-secondary"
               href="<%=request.getContextPath()%>/dashboard">
                Dashboard
            </a>

        </div>


        <% if (error != null) {%>

        <div class="error">
            <%=error%>
        </div>

        <% } %>


        <table>

            <thead>

                <tr>

                    <th>Bin ID</th>

                    <th>Bin Code</th>

                    <th>Location</th>

                    <th>Capacity</th>

                    <th>Current Fill</th>

                    <th>Status</th>

                    <th>Area</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

                <%
                    if (list != null && !list.isEmpty()) {

                        for (WasteBin bin : list) {

                            double fill = bin.getCurrentFill();

                            String fillClass = "fill-green";

                            if (fill >= 80) {
                                fillClass = "fill-red";
                            } else if (fill >= 50) {
                                fillClass = "fill-yellow";
                            }
                %>

                <tr>

                    <td>
                        <%=bin.getBinID()%>
                    </td>

                    <td>
                        <%=bin.getBinCode()%>
                    </td>

                    <td>
                        <%=bin.getLocation()%>
                    </td>

                    <td>
                        <%=bin.getCapacity()%>
                    </td>

                    <td class="<%=fillClass%>">
                        <%=fill%>%
                    </td>

                    <td>
                        <%=bin.getStatus()%>
                    </td>

                    <td>
                        <%=bin.getAreaID()%>
                    </td>

                    <td>

                        <a class="btn btn-secondary"
                           href="<%=request.getContextPath()%>/wastebin/view?id=<%=bin.getBinID()%>">
                            View
                        </a>


                        <% if (canManage) {%>

                        <a class="btn"
                           href="<%=request.getContextPath()%>/wastebin/edit?id=<%=bin.getBinID()%>">
                            Edit
                        </a>


                        <form action="<%=request.getContextPath()%>/wastebin/delete"
                              method="POST"
                              onsubmit="return confirm('Are you sure you want to delete this waste bin?');">

                            <input type="hidden"
                                   name="id"
                                   value="<%=bin.getBinID()%>">

                            <button type="submit"
                                    class="btn btn-danger">
                                Delete
                            </button>

                        </form>

                        <% } %>

                    </td>

                </tr>

                <%
                    }

                } else {
                %>

                <tr>

                    <td colspan="8">
                        No waste bins found.
                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

        </table>

    </body>

</html>