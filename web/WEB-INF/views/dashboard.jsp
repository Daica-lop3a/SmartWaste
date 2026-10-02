<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.AppUser"%>
<%@page import="model.WasteBin"%>
<%@page import="java.util.List"%>

<%
    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String currentRole
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>SmartWaste Dashboard</title>

        <style>

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #f5f7fa;
                color: #333;
            }

            /* ========================= */
            /* HEADER */
            /* ========================= */

            .header {
                background-color: #1f2937;
                color: white;
                padding: 20px 30px;
            }

            .header h1 {
                margin: 0;
                font-size: 28px;
            }

            .header p {
                margin: 5px 0 0;
                color: #d1d5db;
            }

            .user-info {
                float: right;
                margin-right: 10px;
                margin-top: 8px;
                color: #d1d5db;
                font-size: 14px;
            }

            .logout {
                float: right;
                color: white;
                text-decoration: none;
                background-color: #dc2626;
                padding: 8px 15px;
                border-radius: 5px;
            }

            .logout:hover {
                background-color: #b91c1c;
            }

            /* ========================= */
            /* CONTAINER */
            /* ========================= */

            .container {
                padding: 30px;
            }

            .section-title {
                margin: 30px 0 15px;
                font-size: 22px;
            }

            /* ========================= */
            /* CARDS */
            /* ========================= */

            .cards {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            .card {
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            .card-title {
                font-size: 15px;
                color: #6b7280;
                margin-bottom: 10px;
            }

            .card-value {
                font-size: 30px;
                font-weight: bold;
            }

            /* ========================= */
            /* CARD COLORS */
            /* ========================= */

            .blue {
                border-left: 5px solid #2563eb;
            }

            .green {
                border-left: 5px solid #16a34a;
            }

            .yellow {
                border-left: 5px solid #eab308;
            }

            .red {
                border-left: 5px solid #dc2626;
            }

            .orange {
                border-left: 5px solid #f97316;
            }

            .gray {
                border-left: 5px solid #6b7280;
            }

            /* ========================= */
            /* QUICK ACCESS */
            /* ========================= */

            .quick-access {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 15px;
                margin-bottom: 30px;
            }

            .quick-btn {
                display: block;
                padding: 18px;
                color: white;
                text-decoration: none;
                text-align: center;
                border-radius: 8px;
                font-weight: bold;
                transition: 0.2s;
            }

            .quick-btn:hover {
                opacity: 0.85;
                transform: translateY(-2px);
            }

            .btn-user {
                background-color: #374151;
            }

            .btn-area {
                background-color: #6b7280;
            }

            .btn-bin {
                background-color: #2563eb;
            }

            .btn-collection {
                background-color: #16a34a;
            }

            .btn-alert {
                background-color: #dc2626;
            }

            .btn-maintenance {
                background-color: #f97316;
            }

            /* ========================= */
            /* BIN MONITORING */
            /* ========================= */

            .bin-card {
                min-height: 250px;
            }

            .bin-bar-container {
                margin-top: 10px;
                background-color: #e5e7eb;
                height: 12px;
                border-radius: 6px;
                overflow: hidden;
            }

            .bin-bar {
                height: 100%;
                background-color: #2563eb;
            }

            .bin-info {
                margin-top: 10px;
            }

            .bin-detail-btn {
                display: inline-block;
                margin-top: 10px;
                padding: 8px 14px;
                background-color: #2563eb;
                color: white;
                text-decoration: none;
                border-radius: 6px;
            }

            .bin-detail-btn:hover {
                background-color: #1d4ed8;
            }

            /* ========================= */
            /* MAINTENANCE SUMMARY */
            /* ========================= */

            .maintenance-summary {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            /* ========================= */
            /* RESPONSIVE */
            /* ========================= */

            @media (max-width: 1100px) {

                .cards {
                    grid-template-columns: repeat(2, 1fr);
                }

                .quick-access {
                    grid-template-columns: repeat(2, 1fr);
                }

                .maintenance-summary {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 600px) {

                .cards {
                    grid-template-columns: 1fr;
                }

                .quick-access {
                    grid-template-columns: 1fr;
                }

                .maintenance-summary {
                    grid-template-columns: 1fr;
                }

                .container {
                    padding: 15px;
                }

                .header {
                    padding: 20px;
                }

                .user-info {
                    display: none;
                }
            }

        </style>

    </head>

    <body>

        <!-- ===================================================== -->
        <!-- HEADER -->
        <!-- ===================================================== -->

        <div class="header">

            <a class="logout"
               href="<%= request.getContextPath()%>/logout">
                Logout
            </a>

            <div class="user-info">
                Role:
                <strong><%=currentRole%></strong>
            </div>

            <h1>SmartWaste Dashboard</h1>

            <p>
                Smart Waste Management System
            </p>

        </div>


        <div class="container">


            <!-- ================================================= -->
            <!-- QUICK ACCESS -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Quick Access
            </h2>

            <div class="quick-access">

                <!-- ========================= -->
                <!-- USER MANAGEMENT -->
                <!-- ADM ONLY -->
                <!-- ========================= -->

                <% if ("ADM".equals(currentRole)) {%>

                <a class="quick-btn btn-user"
                   href="<%=request.getContextPath()%>/user">

                    User Management

                </a>

                <% } %>


                <!-- ========================= -->
                <!-- AREA -->
                <!-- ADM / MGR -->
                <!-- ========================= -->

                <% if ("ADM".equals(currentRole)
                    || "MGR".equals(currentRole)) {%>

                <a class="quick-btn btn-area"
                   href="<%=request.getContextPath()%>/area">

                    Areas

                </a>

                <% }%>


                <!-- ========================= -->
                <!-- WASTE BIN -->
                <!-- ALL ROLES -->
                <!-- ========================= -->

                <a class="quick-btn btn-bin"
                   href="<%=request.getContextPath()%>/wastebin">

                    Waste Bins

                </a>


                <!-- ========================= -->
                <!-- COLLECTION -->
                <!-- ADM / MGR / STF -->
                <!-- ========================= -->

                <% if ("ADM".equals(currentRole)
                    || "MGR".equals(currentRole)
                    || "STF".equals(currentRole)) {%>

                <a class="quick-btn btn-collection"
                   href="<%=request.getContextPath()%>/collection">

                    Collection Requests

                </a>

                <% }%>


                <!-- ========================= -->
                <!-- ALERT -->
                <!-- ALL ROLES -->
                <!-- ========================= -->

                <a class="quick-btn btn-alert"
                   href="<%=request.getContextPath()%>/alert">

                    Alerts

                </a>


                <!-- ========================= -->
                <!-- MAINTENANCE -->
                <!-- ADM / MGR / TEC -->
                <!-- ========================= -->

                <% if ("ADM".equals(currentRole)
                    || "MGR".equals(currentRole)
                    || "TEC".equals(currentRole)) {%>

                <a class="quick-btn btn-maintenance"
                   href="<%=request.getContextPath()%>/maintenance">

                    Maintenance

                </a>

                <% }%>

            </div>


            <!-- ================================================= -->
            <!-- WASTE BIN -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Waste Bins
            </h2>

            <div class="cards">

                <div class="card blue">

                    <div class="card-title">
                        Total Bins
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute("totalBins")%>
                    </div>

                </div>


                <div class="card green">

                    <div class="card-title">
                        Active Bins
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute("activeBins")%>
                    </div>

                </div>


                <div class="card red">

                    <div class="card-title">
                        Full Bins
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute("fullBins")%>
                    </div>

                </div>


                <div class="card gray">

                    <div class="card-title">
                        Maintenance
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute("maintenanceBins")%>
                    </div>

                </div>

            </div>


            <!-- ================================================= -->
            <!-- LIVE WASTE BIN MONITORING -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Live Waste Bin Monitoring
            </h2>

            <div class="cards">

                <%
                    List<WasteBin> binList
                            = (List<WasteBin>) request.getAttribute("LIST_BIN");

                    if (binList != null
                            && !binList.isEmpty()) {

                        for (WasteBin bin : binList) {

                            double fill
                                    = bin.getCurrentFill();

                            String fillClass
                                    = "green";

                            if (fill >= 80) {

                                fillClass = "red";

                            } else if (fill >= 50) {

                                fillClass = "yellow";
                            }
                %>


                <!-- ================================================= -->
                <!-- BIN CARD -->
                <!-- ================================================= -->

                <div class="card bin-card <%=fillClass%>"
                     id="bin-<%=bin.getBinID()%>">

                    <div class="card-title">

                        <%=bin.getBinCode()%>

                    </div>


                    <div class="card-value bin-fill">

                        <%=fill%>%

                    </div>


                    <!-- Progress Bar -->

                    <div class="bin-bar-container">

                        <div class="bin-bar"
                             style="width: <%=fill%>%;">
                        </div>

                    </div>


                    <div class="bin-info">

                        <p>
                            Location:
                            <%=bin.getLocation()%>
                        </p>

                        <p>
                            Status:
                            <strong>
                                <%=bin.getStatus()%>
                            </strong>
                        </p>

                    </div>


                    <!-- View Details -->

                    <a class="bin-detail-btn"
                       href="<%=request.getContextPath()%>/wastebin/detail?binID=<%=bin.getBinID()%>">

                        View Details

                    </a>

                </div>


                <%
                    }

                } else {
                %>


                <div class="card">

                    <div class="card-title">
                        Waste Bins
                    </div>

                    <div class="card-value">
                        No data
                    </div>

                </div>


                <%
                    }
                %>

            </div>


            <!-- ================================================= -->
            <!-- COLLECTION REQUEST -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Collection Requests
            </h2>

            <div class="cards">

                <div class="card blue">

                    <div class="card-title">
                        Total Requests
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "totalRequests")%>
                    </div>

                </div>


                <div class="card yellow">

                    <div class="card-title">
                        Pending
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "pendingRequests")%>
                    </div>

                </div>


                <div class="card orange">

                    <div class="card-title">
                        In Progress
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "inProgressRequests")%>
                    </div>

                </div>


                <div class="card green">

                    <div class="card-title">
                        Completed
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "completedRequests")%>
                    </div>

                </div>

            </div>


            <!-- ================================================= -->
            <!-- ALERT -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Alerts
            </h2>

            <div class="cards">

                <div class="card blue">

                    <div class="card-title">
                        Total Alerts
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "totalAlerts")%>
                    </div>

                </div>


                <div class="card red">

                    <div class="card-title">
                        Unresolved Alerts
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "unresolvedAlerts")%>
                    </div>

                </div>

            </div>


            <!-- ================================================= -->
            <!-- MAINTENANCE -->
            <!-- ================================================= -->

            <h2 class="section-title">
                Maintenance
            </h2>

            <div class="maintenance-summary">

                <div class="card blue">

                    <div class="card-title">
                        Total Maintenance
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "totalMaintenance")%>
                    </div>

                </div>


                <div class="card yellow">

                    <div class="card-title">
                        Pending
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "pendingMaintenance")%>
                    </div>

                </div>


                <div class="card orange">

                    <div class="card-title">
                        In Progress
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "inProgressMaintenance")%>
                    </div>

                </div>


                <div class="card green">

                    <div class="card-title">
                        Completed
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute(
                        "completedMaintenance")%>
                    </div>

                </div>

            </div>


            <!-- ================================================= -->
            <!-- MAINTENANCE BUTTON -->
            <!-- ================================================= -->

            <% if ("ADM".equals(currentRole)
                || "MGR".equals(currentRole)
                || "TEC".equals(currentRole)) {%>

            <div style="margin-top: 15px;">

                <a class="quick-btn btn-maintenance"
                   style="display: inline-block;
                   padding: 10px 18px;"
                   href="<%=request.getContextPath()%>/maintenance">

                    View Maintenance

                </a>

            </div>

            <% }%>


        </div>


        <!-- ===================================================== -->
        <!-- AUTO UPDATE BIN STATUS -->
        <!-- ===================================================== -->

        <script>

            function updateBinStatus() {

                fetch(
                        '<%=request.getContextPath()%>/api/bin/status'
                        )

                        .then(response => response.json())

                        .then(data => {

                            data.forEach(bin => {

                                const card =
                                        document.getElementById(
                                                'bin-' + bin.binID
                                                );

                                if (card) {

                                    const fill =
                                            card.querySelector(
                                                    '.bin-fill'
                                                    );

                                    const bar =
                                            card.querySelector(
                                                    '.bin-bar'
                                                    );

                                    if (fill) {

                                        fill.textContent =
                                                bin.currentFill + '%';
                                    }

                                    if (bar) {

                                        bar.style.width =
                                                bin.currentFill + '%';
                                    }

                                }

                            });

                        })

                        .catch(error => {

                            console.log(
                                    'Cannot update bin status:',
                                    error
                                    );

                        });

            }


            // Update every 5 seconds

            setInterval(
                    updateBinStatus,
                    5000
                    );

        </script>

    </body>

</html>