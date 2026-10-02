<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.WasteBin"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Sensor Test</title>

    <style>

        body {
            margin: 0;
            padding: 30px;
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
        }

        .container {
            width: 500px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h2 {
            margin-top: 0;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        select,
        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background-color: #2563eb;
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background-color: #1d4ed8;
        }

        .back {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #2563eb;
        }

    </style>

</head>

<body>

<div class="container">

    <h2>Sensor Test</h2>

    <form method="post"
          action="<%=request.getContextPath()%>/api/bin/update-fill">

        <!-- ========================= -->
        <!-- SELECT WASTE BIN -->
        <!-- ========================= -->

        <div class="form-group">

            <label>
                Waste Bin
            </label>

            <select name="binID" required>

                <option value="">
                    -- Select Waste Bin --
                </option>

                <%
                    List<WasteBin> bins =
                            (List<WasteBin>)
                            request.getAttribute("LIST_BIN");

                    if (bins != null) {

                        for (WasteBin bin : bins) {
                %>

                <option value="<%=bin.getBinID()%>">

                    <%=bin.getBinCode()%>
                    -
                    <%=bin.getLocation()%>

                </option>

                <%
                        }
                    }
                %>

            </select>

        </div>


        <!-- ========================= -->
        <!-- FILL PERCENT -->
        <!-- ========================= -->

        <div class="form-group">

            <label>
                Fill Percent (%)
            </label>

            <input type="number"
                   name="fillPercent"
                   min="0"
                   max="100"
                   required
                   placeholder="Enter value from 0 to 100">

        </div>


        <!-- ========================= -->
        <!-- SUBMIT -->
        <!-- ========================= -->

        <button type="submit">

            Send Sensor Data

        </button>

    </form>


    <a class="back"
       href="<%=request.getContextPath()%>/dashboard">

        ← Back to Dashboard

    </a>

</div>

</body>

</html>