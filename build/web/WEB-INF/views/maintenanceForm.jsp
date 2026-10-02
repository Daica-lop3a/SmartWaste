<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Maintenance"%>
<%@page import="model.WasteBin"%>
<%@page import="model.AppUser"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Timestamp"%>

<%
    Maintenance maintenance
            = (Maintenance) request.getAttribute(
                    "MAINTENANCE");

    List<WasteBin> bins
            = (List<WasteBin>) request.getAttribute(
                    "LIST_BIN");

    List<AppUser> technicians
            = (List<AppUser>) request.getAttribute(
                    "LIST_TECHNICIAN");

    AppUser user
            = (AppUser) session.getAttribute("user");

    String role
            = user != null
                    ? user.getRoleId()
                    : "";

    boolean isEdit
            = "EDIT".equals(
                    request.getAttribute("MODE"));

    boolean isTechnician
            = "TEC".equals(role);

    String error
            = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>
            <%=isEdit
                    ? "Edit Maintenance"
                    : "Create Maintenance"%>
        </title>

        <style>

            body {
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
                margin: 30px;
            }

            .container {
                width: 650px;
                margin: auto;
                background-color: white;
                padding: 25px;
                border-radius: 8px;
            }

            h2 {
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
            }

            input,
            select,
            textarea {
                width: 100%;
                padding: 9px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            textarea {
                height: 120px;
                resize: vertical;
            }

            input[readonly],
            select:disabled {
                background-color: #eee;
            }

            .error {
                color: #dc3545;
                margin-bottom: 15px;
                font-weight: bold;
            }

            .btn {
                display: inline-block;
                padding: 9px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                margin-right: 5px;
            }

            .btn-save {
                background-color: #198754;
                color: white;
            }

            .btn-cancel {
                background-color: #6c757d;
                color: white;
            }

            .readonly-note {
                color: #777;
                font-size: 13px;
                margin-top: 4px;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h2>
                <%=isEdit
                        ? "Edit Maintenance"
                        : "Create Maintenance"%>
            </h2>

            <% if (error != null) {%>

            <div class="error">
                <%=error%>
            </div>

            <% }%>

            <form method="post"
                  action="<%=request.getContextPath()%>/maintenance/save">

                <!-- ================================================= -->
                <!-- MAINTENANCE ID -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Maintenance ID:</label>

                    <input type="text"
                           name="maintenanceID"
                           value="<%=maintenance != null
                                   && maintenance.getMaintenanceID() != null
                                   ? maintenance.getMaintenanceID()
                           : ""%>"
                           <%=isEdit ? "readonly" : ""%>
                           required>

                </div>


                <!-- ================================================= -->
                <!-- WASTE BIN -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Waste Bin:</label>

                    <% if (isTechnician) {%>

                    <!-- TEC cannot change bin -->

                    <input type="text"
                           value="<%=maintenance != null
                               ? maintenance.getBinID()
                               : ""%>"
                           readonly>

                    <input type="hidden"
                           name="binID"
                           value="<%=maintenance != null
                               ? maintenance.getBinID()
                               : ""%>">

                    <div class="readonly-note">
                        Technician cannot change the waste bin.
                    </div>

                    <% } else { %>

                    <select name="binID"
                            required>

                        <option value="">
                            -- Select Waste Bin --
                        </option>

                        <% if (bins != null) { %>

                        <% for (WasteBin bin : bins) {%>

                        <option value="<%=bin.getBinID()%>"
                                <%=maintenance != null
                                        && bin.getBinID().equals(
                                                maintenance.getBinID())
                                        ? "selected"
                                        : ""%>>

                            <%=bin.getBinID()%>
                            -
                            <%=bin.getLocation()%>

                        </option>

                        <% } %>

                        <% } %>

                    </select>

                    <% } %>

                </div>


                <!-- ================================================= -->
                <!-- TECHNICIAN -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Technician:</label>

                    <% if (isTechnician) {%>

                    <!-- TEC cannot change technician -->

                    <input type="text"
                           value="<%=maintenance != null
                               ? maintenance.getTechnicianID()
                               : user.getUserId()%>"
                           readonly>

                    <input type="hidden"
                           name="technicianID"
                           value="<%=maintenance != null
                               ? maintenance.getTechnicianID()
                               : user.getUserId()%>">

                    <div class="readonly-note">
                        Technician cannot change the assigned technician.
                    </div>

                    <% } else { %>

                    <select name="technicianID"
                            required>

                        <option value="">
                            -- Select Technician --
                        </option>

                        <% if (technicians != null) { %>

                        <% for (AppUser technician
                                    : technicians) {%>

                        <option value="<%=technician.getUserId()%>"
                                <%=maintenance != null
                                        && technician.getUserId().equals(
                                                maintenance.getTechnicianID())
                                        ? "selected"
                                        : ""%>>

                            <%=technician.getUserId()%>
                            -
                            <%=technician.getFullName()%>

                        </option>

                        <% } %>

                        <% } %>

                    </select>

                    <% } %>

                </div>


                <!-- ================================================= -->
                <!-- MAINTENANCE TYPE -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Maintenance Type:</label>

                    <% if (isTechnician) {%>

                    <input type="text"
                           value="<%=maintenance != null
                               ? maintenance.getMaintenanceType()
                               : ""%>"
                           readonly>

                    <input type="hidden"
                           name="maintenanceType"
                           value="<%=maintenance != null
                               ? maintenance.getMaintenanceType()
                               : ""%>">

                    <div class="readonly-note">
                        Technician cannot change the maintenance type.
                    </div>

                    <% } else {%>

                    <select name="maintenanceType"
                            required>

                        <option value="">
                            -- Select Type --
                        </option>

                        <option value="Repair"
                                <%=maintenance != null
                                        && "Repair".equals(
                                                maintenance.getMaintenanceType())
                                ? "selected"
                                : ""%>>
                            Repair
                        </option>

                        <option value="Inspection"
                                <%=maintenance != null
                                        && "Inspection".equals(
                                                maintenance.getMaintenanceType())
                                ? "selected"
                                : ""%>>
                            Inspection
                        </option>

                        <option value="Replacement"
                                <%=maintenance != null
                                        && "Replacement".equals(
                                                maintenance.getMaintenanceType())
                                ? "selected"
                                : ""%>>
                            Replacement
                        </option>

                        <option value="Sensor_Check"
                                <%=maintenance != null
                                        && "Sensor_Check".equals(
                                                maintenance.getMaintenanceType())
                                ? "selected"
                                : ""%>>
                            Sensor Check
                        </option>

                    </select>

                    <% }%>

                </div>


                <!-- ================================================= -->
                <!-- STATUS -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Status:</label>

                    <select name="status"
                            required>

                        <option value="">
                            -- Select Status --
                        </option>

                        <option value="Pending"
                                <%=maintenance != null
                                        && "Pending".equals(
                                                maintenance.getStatus())
                            ? "selected"
                            : ""%>>
                            Pending
                        </option>

                        <option value="In_Progress"
                                <%=maintenance != null
                                        && "In_Progress".equals(
                                                maintenance.getStatus())
                            ? "selected"
                            : ""%>>
                            In Progress
                        </option>

                        <option value="Completed"
                                <%=maintenance != null
                                        && "Completed".equals(
                                                maintenance.getStatus())
                            ? "selected"
                            : ""%>>
                            Completed
                        </option>

                        <option value="Cancelled"
                                <%=maintenance != null
                                        && "Cancelled".equals(
                                                maintenance.getStatus())
                            ? "selected"
                            : ""%>>
                            Cancelled
                        </option>

                    </select>

                </div>


                <!-- ================================================= -->
                <!-- SCHEDULED DATE -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Scheduled Date:</label>

                    <input type="datetime-local"
                           name="scheduledDate"
                           value="<%=maintenance != null
                                   && maintenance.getScheduledDate() != null
                                   ? maintenance.getScheduledDate()
                                           .toString()
                                           .replace(" ", "T")
                                   .substring(0, 16)
                           : ""%>">

                </div>


                <!-- ================================================= -->
                <!-- COMPLETED DATE -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Completed Date:</label>

                    <input type="datetime-local"
                           name="completedDate"
                           value="<%=maintenance != null
                                   && maintenance.getCompletedDate() != null
                                   ? maintenance.getCompletedDate()
                                           .toString()
                                           .replace(" ", "T")
                                   .substring(0, 16)
                           : ""%>">

                    <div class="readonly-note">
                        If status is Completed and this field is empty,
                        the system will use the current time.
                    </div>

                </div>


                <!-- ================================================= -->
                <!-- DESCRIPTION -->
                <!-- ================================================= -->

                <div class="form-group">

                    <label>Description:</label>

                    <textarea name="description"><%=maintenance != null
                            && maintenance.getDescription() != null
                            ? maintenance.getDescription()
                            : ""%></textarea>

                </div>


                <!-- ================================================= -->
                <!-- BUTTON -->
                <!-- ================================================= -->

                <button class="btn btn-save"
                        type="submit">

                    <%=isEdit ? "Update" : "Create"%>

                </button>

                <a class="btn btn-cancel"
                   href="<%=request.getContextPath()%>/maintenance">

                    Cancel

                </a>

            </form>

        </div>

    </body>

</html>