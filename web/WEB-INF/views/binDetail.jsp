<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="model.WasteBin"%>
<%@page import="model.BinReading"%>
<%@page import="java.util.List"%>

<%
    WasteBin bin = (WasteBin) request.getAttribute("BIN");
    List<BinReading> readings
            = (List<BinReading>) request.getAttribute("READINGS");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bin Detail</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background: #f5f6f8;
            }

            .container {
                max-width: 900px;
                margin: auto;
            }

            .card {
                background: white;
                padding: 25px;
                border-radius: 10px;
                margin-bottom: 20px;
            }

            .fill {
                font-size: 40px;
                font-weight: bold;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <div class="card">

                <h2>
                    <%= bin.getBinCode()%>
                </h2>

                <div class="fill">
                    <%= bin.getCurrentFill()%>%
                </div>

                <p>
                    Location:
                    <strong><%= bin.getLocation()%></strong>
                </p>

                <p>
                    Status:
                    <strong><%= bin.getStatus()%></strong>
                </p>

                <p>
                    Capacity:
                    <strong><%= bin.getCapacity()%></strong>
                </p>

                <a href="${pageContext.request.contextPath}/collection/create?binID=<%=bin.getBinID()%>"
                   style="display:inline-block;
                   margin-top:15px;
                   padding:10px 16px;
                   background-color:#2563eb;
                   color:white;
                   text-decoration:none;
                   border-radius:6px;">
                    Create Collection Request
                </a>
            </div>


            <div class="card">

                <h2>Sensor History</h2>

                <table>

                    <tr>
                        <th>Time</th>
                        <th>Fill</th>
                    </tr>

                    <%
                        if (readings != null && !readings.isEmpty()) {

                            for (BinReading reading : readings) {
                    %>

                    <tr>
                        <td>
                            <%= reading.getMeasuredAt()%>
                        </td>

                        <td>
                            <%= reading.getFillPercent()%>%
                        </td>
                    </tr>

                    <%
                        }

                    } else {
                    %>

                    <tr>
                        <td colspan="2">
                            No sensor data
                        </td>
                    </tr>

                    <%
                        }
                    %>

                </table>

            </div>

        </div>

    </body>
</html>