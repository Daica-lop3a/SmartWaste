<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.CollectionRequest"%>
<%@page import="model.WasteBin"%>
<%@page import="model.AppUser"%>

<%
    CollectionRequest collection
            = (CollectionRequest) request.getAttribute("REQUEST");

    List<WasteBin> binList
            = (List<WasteBin>) request.getAttribute("LIST_BIN");

    List<AppUser> staffList
            = (List<AppUser>) request.getAttribute("LIST_STAFF");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";

    String error
            = (String) request.getAttribute("ERROR");

    boolean edit
            = collection != null
            && collection.getRequestID() != null
            && !collection.getRequestID().trim().isEmpty();

    boolean isStaff
            = "STF".equals(role);
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>
            <%= edit
                    ? "Edit Collection Request"
                    : "Create Collection Request"%>
        </title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background: #f5f6f8;
            }

            .form-container {
                width: 600px;
                background: white;
                padding: 25px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            h1 {
                margin-top: 0;
                margin-bottom: 25px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            label {
                display: block;
                font-weight: bold;
                margin-bottom: 6px;
            }

            input,
            select,
            textarea {
                width: 100%;
                padding: 9px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            textarea {
                height: 100px;
                resize: vertical;
            }

            .error {
                color: #b00020;
                background: #ffe5e5;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
            }

            .readonly {
                background: #eeeeee;
                color: #555;
            }

            .btn {
                display: inline-block;
                padding: 9px 16px;
                margin-right: 5px;
                border: none;
                border-radius: 4px;
                text-decoration: none;
                cursor: pointer;
            }

            .btn-save {
                background: #198754;
                color: white;
            }

            .btn-cancel {
                background: #6c757d;
                color: white;
            }

            .staff-note {
                background: #eef4ff;
                border: 1px solid #c7d7fe;
                color: #1e3a8a;
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }

            .area-note {
                font-size: 13px;
                color: #666;
                margin-top: 5px;
            }

        </style>

    </head>

    <body>

        <div class="form-container">

            <h1>
                <%= edit
                        ? "Edit Collection Request"
                        : "Create Collection Request"%>
            </h1>


            <% if (error != null && !error.isEmpty()) {%>

            <div class="error">
                <%= error%>
            </div>

            <% } %>


            <% if (isStaff) { %>

            <div class="staff-note">

                You can only edit collection requests assigned to you.
                Waste Bin, Staff and Priority cannot be changed.

            </div>

            <% }%>


            <form
                action="<%=request.getContextPath()%>/collection/save"
                method="POST">


                <!-- =================================================
                     REQUEST ID
                     ================================================= -->

                <div class="form-group">

                    <label>Request ID</label>

                    <input
                        type="text"
                        name="requestID"
                        value="<%= collection != null
                                && collection.getRequestID() != null
                                ? collection.getRequestID()
                                : ""%>"
                        <%= edit
                                ? "readonly class=\"readonly\""
                                : ""%>
                        required>

                </div>


                <!-- =================================================
                     WASTE BIN
                     ================================================= -->

                <div class="form-group">

                    <label>Waste Bin</label>

                    <% if (isStaff) {%>

                    <!-- STAFF cannot change Bin -->

                    <input
                        type="text"
                        value="<%= collection != null
                                && collection.getBinID() != null
                                ? collection.getBinID()
                                : ""%>"
                        readonly
                        class="readonly">

                    <input
                        type="hidden"
                        name="binID"
                        value="<%= collection != null
                                && collection.getBinID() != null
                                ? collection.getBinID()
                                : ""%>">

                    <% } else { %>

                    <select
                        name="binID"
                        id="binID"
                        required
                        onchange="loadStaffByBin()">

                        <option value="">
                            -- Select Waste Bin --
                        </option>

                        <% if (binList != null) { %>

                        <% for (WasteBin bin : binList) {%>

                        <option
                            value="<%=bin.getBinID()%>"
                            <%= collection != null
                                    && bin.getBinID().equals(
                                            collection.getBinID())
                                    ? "selected"
                                    : ""%>>

                            <%=bin.getBinID()%>
                            -
                            <%=bin.getBinCode()%>

                        </option>

                        <% } %>

                        <% } %>

                    </select>

                    <div class="area-note">
                        Select a Waste Bin to load Staff from its Area.
                    </div>

                    <% } %>

                </div>


                <!-- =================================================
                     STAFF
                     ================================================= -->

                <div class="form-group">

                    <label>Staff</label>

                    <% if (isStaff) {%>

                    <!-- STAFF cannot change assigned Staff -->

                    <input
                        type="text"
                        value="<%= collection != null
                                && collection.getStaffID() != null
                                ? collection.getStaffID()
                                : ""%>"
                        readonly
                        class="readonly">

                    <input
                        type="hidden"
                        name="staffID"
                        value="<%= collection != null
                                && collection.getStaffID() != null
                                ? collection.getStaffID()
                                : ""%>">

                    <% } else { %>

                    <select
                        name="staffID"
                        id="staffID"
                        required>

                        <option value="">
                            -- Select Staff --
                        </option>

                        <% if (staffList != null) { %>

                        <% for (AppUser staff : staffList) {%>

                        <option
                            value="<%=staff.getUserId()%>"
                            <%= collection != null
                                    && staff.getUserId().equals(
                                            collection.getStaffID())
                                    ? "selected"
                                    : ""%>>

                            <%=staff.getUserId()%>
                            -
                            <%=staff.getFullName()%>

                        </option>

                        <% } %>

                        <% } %>

                    </select>

                    <% }%>

                </div>


                <!-- =================================================
                     STATUS
                     ================================================= -->

                <div class="form-group">

                    <label>Status</label>

                    <select
                        name="status"
                        required>

                        <option
                            value="Pending"
                            <%= collection != null
                                    && "Pending".equals(
                                            collection.getStatus())
                                    ? "selected"
                                    : ""%>>

                            Pending

                        </option>

                        <option
                            value="In_Progress"
                            <%= collection != null
                                    && "In_Progress".equals(
                                            collection.getStatus())
                                    ? "selected"
                                    : ""%>>

                            In Progress

                        </option>

                        <option
                            value="Completed"
                            <%= collection != null
                                    && "Completed".equals(
                                            collection.getStatus())
                                    ? "selected"
                                    : ""%>>

                            Completed

                        </option>

                        <% if (!isStaff) {%>

                        <option
                            value="Cancelled"
                            <%= collection != null
                                    && "Cancelled".equals(
                                            collection.getStatus())
                                    ? "selected"
                                    : ""%>>

                            Cancelled

                        </option>

                        <% } %>

                    </select>

                </div>


                <!-- =================================================
                     PRIORITY
                     ================================================= -->

                <div class="form-group">

                    <label>Priority</label>

                    <% if (isStaff) {%>

                    <!-- STAFF cannot change Priority -->

                    <input
                        type="text"
                        value="<%= collection != null
                                && collection.getPriority() != null
                                ? collection.getPriority()
                                : ""%>"
                        readonly
                        class="readonly">

                    <input
                        type="hidden"
                        name="priority"
                        value="<%= collection != null
                                && collection.getPriority() != null
                                ? collection.getPriority()
                                : ""%>">

                    <% } else {%>

                    <select
                        name="priority"
                        required>

                        <option
                            value="Low"
                            <%= collection != null
                                    && "Low".equals(
                                            collection.getPriority())
                                    ? "selected"
                                    : ""%>>

                            Low

                        </option>

                        <option
                            value="Normal"
                            <%= collection != null
                                    && "Normal".equals(
                                            collection.getPriority())
                                    ? "selected"
                                    : ""%>>

                            Normal

                        </option>

                        <option
                            value="High"
                            <%= collection != null
                                    && "High".equals(
                                            collection.getPriority())
                                    ? "selected"
                                    : ""%>>

                            High

                        </option>

                        <option
                            value="Emergency"
                            <%= collection != null
                                    && "Emergency".equals(
                                            collection.getPriority())
                                    ? "selected"
                                    : ""%>>

                            Emergency

                        </option>

                    </select>

                    <% }%>

                </div>


                <!-- =================================================
                     NOTES
                     ================================================= -->

                <div class="form-group">

                    <label>Notes</label>

                    <textarea
                        name="notes"
                        placeholder="Enter notes..."><%= collection != null
                                && collection.getNotes() != null
                                ? collection.getNotes()
                                : ""%></textarea>

                </div>


                <!-- =================================================
                     BUTTON
                     ================================================= -->

                <button
                    type="submit"
                    class="btn btn-save">

                    <%= isStaff
                            ? "Update"
                            : (edit
                                    ? "Update Request"
                                    : "Create Request")%>

                </button>


                <a
                    href="<%=request.getContextPath()%>/collection"
                    class="btn btn-cancel">

                    Cancel

                </a>

            </form>

        </div>


        <!-- =========================================================
             JAVASCRIPT
             ========================================================= -->

        <script>

            function loadStaffByBin() {

                var binSelect =
                        document.getElementById("binID");

                var staffSelect =
                        document.getElementById("staffID");

                if (binSelect == null
                        || staffSelect == null) {
                    return;
                }

                var binID =
                        binSelect.value;

                /*
                 * Xóa Staff hiện tại.
                 */
                staffSelect.innerHTML =
                        '<option value="">-- Select Staff --</option>';

                if (binID === "") {
                    return;
                }

                /*
                 * Hiện trạng thái loading.
                 */
                staffSelect.innerHTML =
                        '<option value="">Loading Staff...</option>';

                var contextPath =
                        "<%=request.getContextPath()%>";

                fetch(
                        contextPath
                        + "/collection/staff-by-bin?binID="
                        + encodeURIComponent(binID)
                        )
                        .then(function (response) {

                            if (!response.ok) {
                                throw new Error(
                                        "Failed to load Staff.");
                            }

                            return response.json();
                        })
                        .then(function (data) {

                            staffSelect.innerHTML =
                                    '<option value="">-- Select Staff --</option>';

                            if (data == null
                                    || data.length === 0) {

                                staffSelect.innerHTML +=
                                        '<option value="">No Staff available</option>';

                                return;
                            }

                            data.forEach(function (staff) {

                                var option =
                                        document.createElement("option");

                                option.value =
                                        staff.userID;

                                option.textContent =
                                        staff.userID
                                        + " - "
                                        + staff.fullName;

                                staffSelect.appendChild(option);
                            });

                        })
                        .catch(function (error) {

                            console.error(error);

                            staffSelect.innerHTML =
                                    '<option value="">Unable to load Staff</option>';
                        });
            }

        </script>

    </body>

</html>