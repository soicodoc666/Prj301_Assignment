<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agenda - Tình hình nhân s?</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f5f6f8;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 25px;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            padding: 20px 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        form.filter {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        form.filter input[type="date"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        form.filter button {
            background: #e1251b;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            text-align: center;
            padding: 8px;
        }
        th {
            background-color: #f5f5f5;
        }
        .working { background-color: #c9f7c0; }
        .leave { background-color: #f7c0c0; }
    </style>
</head>
<body>
<header>
    <h2>? Tình hình nhân s? (Agenda)</h2>
</header>

<div class="container">
    <form class="filter" action="agenda" method="get">
        <label>T? ngày:</label>
        <input type="date" name="from" value="${from}">
        <label>??n ngày:</label>
        <input type="date" name="to" value="${to}">
        <button type="submit">Xem</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>Nhân viên</th>
                <c:forEach var="d" items="${days}">
                    <th>${d}</th>
                </c:forEach>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="e" items="${employees}">
                <tr>
                    <td>${e.name}</td>
                    <c:forEach var="d" items="${days}">
                        <c:set var="isLeave" value="false" />
                        <c:forEach var="r" items="${requests}">
                            <c:if test="${r.created_by.id == e.id && d >= r.from && d <= r.to}">
                                <c:set var="isLeave" value="true" />
                            </c:if>
                        </c:forEach>
                        <td class="${isLeave ? 'leave' : 'working'}">
                            ${isLeave ? 'Ngh?' : 'Làm'}
                        </td>
                    </c:forEach>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
