<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.CollectionRequest"%>
<%@page import="model.AppUser"%>

<%
    List<CollectionRequest> list
            = (List<CollectionRequest>) request.getAttribute("LIST_COLLECTION");

    String error
            = (String) request.getAttribute("ERROR");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";

    boolean canCreate
            = "ADM".equals(role)
            || "MGR".equals(role);

    boolean canDelete
            = "ADM".equals(role)
            || "MGR".equals(role);

    boolean canEdit
            = "ADM".equals(role)
            || "MGR".equals(role)
            || "STF".equals(role);
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Collection Management</title>

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
                background: #fee2e2;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
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

            .pending {
                color: #ca8a04;
                font-weight: bold;
            }

            .progress {
                color: #2563eb;
                font-weight: bold;
            }

            .completed {
                color: #15803d;
                font-weight: bold;
            }

            .cancelled {
                color: #dc2626;
                font-weight: bold;
            }

            .empty {
                text-align: center;
                padding: 20px;
                color: #666;
            }

        </style>

    </head>


    <body>

        <h1>Collection Management</h1>


        <!-- CURRENT USER -->

        <div class="role-info">

            Logged in as:

            <strong>
                <%=currentUser != null
                        ? currentUser.getFullName()
                        : ""%>
            </strong>

            &nbsp; | &nbsp;

            Role:

            <strong>
                <%=role%>
            </strong>

        </div>


        <!-- TOP BUTTONS -->

        <div class="top-bar">

            <% if (canCreate) {%>

            <a
                class="btn"
                href="<%=request.getContextPath()%>/collection/create">

                Create Collection Request

            </a>

            <% }%>


            <a
                class="btn btn-secondary"
                href="<%=request.getContextPath()%>/dashboard">

                Dashboard

            </a>

        </div>


        <!-- ERROR -->

        <% if (error != null && !error.trim().isEmpty()) {%>

        <div class="error">

            <%=error%>

        </div>

        <% } %>


        <!-- COLLECTION TABLE -->

        <table>

            <thead>

                <tr>

                    <th>Request ID</th>

                    <th>Bin ID</th>

                    <th>Staff ID</th>

                    <th>Status</th>

                    <th>Priority</th>

                    <th>Created Date</th>

                    <th>Notes</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

                <%
                    if (list != null && !list.isEmpty()) {

                        for (CollectionRequest item : list) {

                            String statusClass = "";

                            if ("Pending".equals(item.getStatus())) {

                                statusClass = "pending";

                            } else if ("In_Progress".equals(item.getStatus())) {

                                statusClass = "progress";

                            } else if ("Completed".equals(item.getStatus())) {

                                statusClass = "completed";

                            } else if ("Cancelled".equals(item.getStatus())) {

                                statusClass = "cancelled";

                            }
                %>


                <tr>

                    <!-- REQUEST ID -->

                    <td>

                        <%=item.getRequestID()%>

                    </td>


                    <!-- BIN -->

                    <td>

                        <%=item.getBinID()%>

                    </td>


                    <!-- STAFF -->

                    <td>

                        <%=item.getStaffID() == null
                                ? ""
                                : item.getStaffID()%>

                    </td>


                    <!-- STATUS -->

                    <td class="<%=statusClass%>">

                        <%=item.getStatus()%>

                    </td>


                    <!-- PRIORITY -->

                    <td>

                        <%=item.getPriority()%>

                    </td>


                    <!-- CREATED DATE -->

                    <td>

                        <%=item.getCreatedDate() == null
                                ? ""
                                : item.getCreatedDate()%>

                    </td>


                    <!-- NOTES -->

                    <td>

                        <%=item.getNotes() == null
                                ? ""
                                : item.getNotes()%>

                    </td>


                    <!-- ACTION -->

                    <td>

                        <!-- VIEW -->

                        <a
                            class="btn btn-secondary"
                            href="<%=request.getContextPath()%>/collection/view?id=<%=item.getRequestID()%>">

                            View

                        </a>


                        <!-- EDIT -->

                        <% if (canEdit) {%>

                        <a
                            class="btn"
                            href="<%=request.getContextPath()%>/collection/edit?id=<%=item.getRequestID()%>">

                            Edit

                        </a>

                        <% } %>


                        <!-- DELETE -->

                        <% if (canDelete) {%>

                        <form
                            action="<%=request.getContextPath()%>/collection/delete"
                            method="POST"
                            onsubmit="return confirm('Are you sure you want to delete this request?');">

                            <input
                                type="hidden"
                                name="id"
                                value="<%=item.getRequestID()%>">


                            <button
                                type="submit"
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

                    <td
                        colspan="8"
                        class="empty">

                        No collection requests found.

                    </td>

                </tr>


                <%
                    }
                %>

            </tbody>

        </table>

    </body>

</html>