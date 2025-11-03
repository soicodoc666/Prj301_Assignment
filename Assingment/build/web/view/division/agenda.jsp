<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>📅 Agenda - Tình hình nhân sự</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f5f6f8;
            margin: 0;
            padding: 0;
        }

        /* Header */
        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        header h2 {
            margin: 0;
            font-size: 22px;
        }

        .user-menu {
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .avatar-small {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: url('https://i.ibb.co/4pDNDk1/avatar.png') center/cover;
            border: 2px solid white;
        }

        /* Dropdown menu */
        .dropdown {
            display: none;
            position: absolute;
            top: 65px;
            right: 0;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            min-width: 200px;
            z-index: 10;
        }

        .dropdown a {
            display: block;
            padding: 12px 16px;
            color: #333;
            text-decoration: none;
            border-bottom: 1px solid #eee;
        }

        .dropdown a:hover {
            background-color: #f9f9f9;
        }

        .dropdown a:last-child {
            border-bottom: none;
            color: #e1251b;
            font-weight: bold;
        }

        /* Main content */
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            padding: 25px 35px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        form.filter {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            justify-content: center;
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

        .back-home {
            display: inline-block;
            background-color: #e1251b;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .back-home:hover {
            background-color: #c92018;
        }

        footer {
            text-align: center;
            margin-top: 40px;
            color: #777;
            font-size: 13px;
        }
    </style>
</head>
<body>
<header>
    <h2>📅 Agenda - Tình hình nhân sự</h2>
    <div class="user-menu" onclick="toggleMenu()">
        <span>Xin chào, <c:out value="${sessionScope.user.displayname}" /></span>
        <div class="avatar-small"></div>
        <div class="dropdown" id="dropdownMenu">
            <a href="../profile">Thông tin tài khoản</a>
            <a href="../request/history">Lịch sử tạo đơn</a>
            <a href="../logout">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="container">
    <a href="../home" class="back-home">🏠 Quay về Trang chủ</a>

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

<footer>
    © 2025 - Hệ thống Quản lý Nghỉ phép | FPT University
</footer>

<script>
    function toggleMenu() {
        const menu = document.getElementById('dropdownMenu');
        menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
    }

    window.onclick = function(e) {
        const menu = document.getElementById('dropdownMenu');
        if (!e.target.closest('.user-menu')) {
            menu.style.display = 'none';
        }
    }
</script>
</body>
</html>
