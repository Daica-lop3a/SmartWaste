<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.CollectionRequest"%>
<%@page import="model.AppUser"%>

<%
    CollectionRequest collection
            = (CollectionRequest) request.getAttribute("REQUEST");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";

    boolean canEdit
            = "ADM".equals(role)
            || "MGR".equals(role)
            || "STF".equals(role);

    boolean canDelete
            = "ADM".equals(role)
            || "MGR".equals(role);

    String statusClass = "";

    if (collection != null) {

        if ("Pending".equals(collection.getStatus())) {

            statusClass = "pending";

        } else if ("In_Progress".equals(collection.getStatus())) {

            statusClass = "progress";

        } else if ("Completed".equals(collection.getStatus())) {

            statusClass = "completed";

        } else if ("Cancelled".equals(collection.getStatus())) {

            statusClass = "cancelled";
        }
    }
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Collection Request Details</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background: #f5f7fa;
            }

            .container {
                width: 700px;
                background: white;
                padding: 25px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            h1 {
                margin-top: 0;
                margin-bottom: 25px;
            }

            .info-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 25px;
            }

            .info-table th,
            .info-table td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            .info-table th {
                width: 180px;
                background: #f1f3f5;
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

            .notes {
                white-space: pre-wrap;
            }

            .btn {
                display: inline-block;
                padding: 9px 16px;
                margin-right: 6px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                cursor: pointer;
                color: white;
            }

            .btn-back {
                background: #6b7280;
            }

            .btn-edit {
                background: #2563eb;
            }

            .btn-delete {
                background: #dc2626;
            }

            form {
                display: inline;
            }

        </style>

    </head>


    <body>

        <div class="container">

            <h1>
                Collection Request Details
            </h1>


            <% if (collection != null) {%>


            <table class="info-table">

                <tr>

                    <th>Request ID</th>

                    <td>
                        <%=collection.getRequestID()%>
                    </td>

                </tr>


                <tr>

                    <th>Waste Bin</th>

                    <td>
                        <%=collection.getBinID()%>
                    </td>

                </tr>


                <tr>

                    <th>Staff</th>

                    <td>

                        <%=collection.getStaffID() == null
                                ? "Not assigned"
                                : collection.getStaffID()%>

                    </td>

                </tr>


                <tr>

                    <th>Status</th>

                    <td class="<%=statusClass%>">

                        <%=collection.getStatus()%>

                    </td>

                </tr>


                <tr>

                    <th>Priority</th>

                    <td>

                        <%=collection.getPriority()%>

                    </td>

                </tr>


                <tr>

                    <th>Created Date</th>

                    <td>

                        <%=collection.getCreatedDate() == null
                                ? ""
                                : collection.getCreatedDate()%>

                    </td>

                </tr>


                <tr>

                    <th>Notes</th>

                    <td class="notes">

                        <%=collection.getNotes() == null
                                || collection.getNotes().trim().isEmpty()
                                ? "No notes"
                                : collection.getNotes()%>

                    </td>

                </tr>

            </table>


            <!-- ACTION BUTTONS -->


            <% if (canEdit) {%>

            <a
                class="btn btn-edit"
                href="<%=request.getContextPath()%>/collection/edit?id=<%=collection.getRequestID()%>">

                Edit

            </a>

            <% } %>


            <% if (canDelete) {%>

            <form
                action="<%=request.getContextPath()%>/collection/delete"
                method="POST"
                onsubmit="return confirm('Are you sure you want to delete this request?');">

                <input
                    type="hidden"
                    name="id"
                    value="<%=collection.getRequestID()%>">

                <button
                    type="submit"
                    class="btn btn-delete">

                    Delete

                </button>

            </form>

            <% }%>


            <a
                class="btn btn-back"
                href="<%=request.getContextPath()%>/collection">

                Back to Collection

            </a>


            <% } else {%>


            <p>
                Collection request not found.
            </p>


            <a
                class="btn btn-back"
                href="<%=request.getContextPath()%>/collection">

                Back to Collection

            </a>


            <% }%>

        </div>

    </body>

</html>