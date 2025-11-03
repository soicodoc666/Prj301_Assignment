<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>📅 Lịch làm việc - Tình hình nhân sự</title>
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
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
        }
        header h2 {
            margin: 0;
            font-size: 22px;
        }
        nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        nav a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 6px 10px;
            border-radius: 5px;
        }
        nav a:hover {
            background-color: rgba(255,255,255,0.2);
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
        form.filter button:hover {
            background: #c92018;
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
        .footer {
            text-align: center;
            color: #777;
            font-size: 13px;
            margin-top: 25px;
        }
    </style>
</head>
<body>
<header>
    <h2>📅 Lịch làm việc - Tình hình nhân sự</h2>
    <nav>
        <a href="../home.jsp">🏠 Trang chủ</a>
        <a href="../request/list">🕓 Lịch sử tạo đơn</a>
        <span>👤 Xin chào, <b>${sessionScope.user.displayname}</b></span>
        <a href="../logout">🚪 Đăng xuất</a>
    </nav>
</header>

<div class="container">
    <form class="filter" action="agenda" method="get">
        <label>Từ ngày:</label>
        <input type="date" name="from" value="${from}">
        <label>Đến ngày:</label>
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
                            ${isLeave ? 'Nghỉ' : 'Làm việc'}
                        </td>
                    </c:forEach>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<div class="footer">
    &copy; 2025 - Quản lý nhân sự | Được phát triển bởi Nhóm IT PRF192
</div>

</body>
</html>
