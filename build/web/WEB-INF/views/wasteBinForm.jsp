<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.WasteBin"%>
<%@page import="model.Area"%>

<%
    WasteBin bin
            = (WasteBin) request.getAttribute("BIN");

    List<Area> areaList
            = (List<Area>) request.getAttribute("LIST_AREA");

    boolean edit
            = bin != null
            && bin.getBinID() != null
            && !bin.getBinID().trim().isEmpty();

    String error
            = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>
            <%=edit ? "Edit Waste Bin" : "Add Waste Bin"%>
        </title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 40px;
                background: #f5f6f8;
            }

            .container {
                max-width: 600px;
                margin: auto;
                background: white;
                padding: 25px;
                border-radius: 8px;
            }

            h1 {
                margin-top: 0;
            }

            .form-group {
                margin-bottom: 15px;
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
            }

            input,
            select {
                width: 100%;
                padding: 9px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .error {
                color: #dc3545;
                margin-bottom: 15px;
            }

            .buttons {
                margin-top: 20px;
            }

            button,
            a {
                padding: 9px 15px;
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

            .readonly {
                background: #f3f4f6;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h1>
                <%=edit ? "Edit Waste Bin" : "Add Waste Bin"%>
            </h1>


            <% if (error != null) {%>

            <div class="error">
                <%=error%>
            </div>

            <% }%>


            <form action="<%=request.getContextPath()%>/wastebin/save"
                  method="POST">


                <!-- BIN ID -->

                <div class="form-group">

                    <label>Bin ID</label>

                    <input type="text"
                           name="binID"
                           value="<%=bin != null
                                   && bin.getBinID() != null
                                   ? bin.getBinID()
               : ""%>"
                           <%=edit ? "readonly" : ""%>
                           required>

                </div>


                <!-- BIN CODE -->

                <div class="form-group">

                    <label>Bin Code</label>

                    <input type="text"
                           name="binCode"
                           value="<%=bin != null
                                   && bin.getBinCode() != null
                                   ? bin.getBinCode()
               : ""%>"
                           required>

                </div>


                <!-- LOCATION -->

                <div class="form-group">

                    <label>Location</label>

                    <input type="text"
                           name="location"
                           value="<%=bin != null
                                   && bin.getLocation() != null
                                   ? bin.getLocation()
               : ""%>"
                           required>

                </div>


                <!-- CAPACITY -->

                <div class="form-group">

                    <label>Capacity</label>

                    <input type="number"
                           step="0.01"
                           name="capacity"
                           value="<%=bin != null
               ? bin.getCapacity()
               : ""%>"
                           required>

                </div>


                <!-- CURRENT FILL -->

                <div class="form-group">

                    <label>Current Fill</label>

                    <input type="number"
                           value="<%=bin != null
               ? bin.getCurrentFill()
               : "0"%>"
                           class="readonly"
                           readonly>

                </div>


                <!-- STATUS -->

                <div class="form-group">

                    <label>Status</label>

                    <select name="status" required>

                        <option value="">
                            -- Select Status --
                        </option>

                        <option value="Active"
                                <%=bin != null
                                        && "Active".equals(bin.getStatus())
                                        ? "selected"
            : ""%>>
                            Active
                        </option>

                        <option value="Full"
                                <%=bin != null
                                        && "Full".equals(bin.getStatus())
                                        ? "selected"
            : ""%>>
                            Full
                        </option>

                        <option value="Maintenance"
                                <%=bin != null
                                        && "Maintenance".equals(bin.getStatus())
                                        ? "selected"
            : ""%>>
                            Maintenance
                        </option>

                    </select>

                </div>


                <!-- AREA -->

                <div class="form-group">

                    <label>Area</label>

                    <select name="areaID" required>

                        <option value="">
                            -- Select Area --
                        </option>

                        <%
                            if (areaList != null) {

                                for (Area area : areaList) {
                        %>

                        <option value="<%=area.getAreaId()%>"
                                <%=bin != null
                                        && area.getAreaId().equals(bin.getAreaID())
                                        ? "selected"
            : ""%>>

                            <%=area.getAreaName()%>

                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                </div>


                <div class="buttons">

                    <button type="submit"
                            class="btn-save">

                        <%=edit ? "Update Waste Bin" : "Create Waste Bin"%>

                    </button>


                    <a class="btn-cancel"
                       href="<%=request.getContextPath()%>/wastebin">

                        Cancel

                    </a>

                </div>

            </form>

        </div>

    </body>

</html>