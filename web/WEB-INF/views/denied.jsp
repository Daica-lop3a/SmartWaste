<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
</head>

<body>

    <h2>Access Denied</h2>

    <p>
        You do not have permission to access this page.
    </p>

    <a href="<%=request.getContextPath()%>/dashboard">
        Back to Dashboard
    </a>

</body>
</html>