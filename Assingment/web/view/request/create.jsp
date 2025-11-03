<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>📝 Đơn xin nghỉ phép</title>
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

        .container {
            max-width: 550px;
            margin: 60px auto;
            background: white;
            border-radius: 12px;
            padding: 35px 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        h3 {
            text-align: center;
            color: #e1251b;
            margin-bottom: 25px;
            font-size: 22px;
        }

        .user-info {
            margin-bottom: 25px;
            background: #f9f9f9;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 15px;
            color: #444;
            border-left: 4px solid #e1251b;
        }

        label {
            display: block;
            margin-top: 12px;
            font-weight: 600;
            color: #333;
        }

        input[type="date"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            resize: none;
            height: 80px;
        }

        button {
            margin-top: 25px;
            width: 100%;
            background-color: #e1251b;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #c92018;
        }

        .back-home {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #e1251b;
            font-weight: bold;
            text-align: center;
            width: 100%;
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
    <h2>📝 Đơn xin nghỉ phép</h2>
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
    <h3>Nhập thông tin đơn nghỉ phép</h3>

    <div class="user-info">
        👤 <b>Người dùng:</b> <c:out value="${sessionScope.user.displayname}" /> <br>
        🏷 <b>Vai trò:</b> Nhân viên <br>
        🏢 <b>Phòng ban:</b> Phòng IT
    </div>

    <form action="create" method="post">
        <label for="reason">Lý do nghỉ:</label>
        <textarea name="reason" id="reason" placeholder="Nhập lý do nghỉ phép..." required></textarea>

        <label for="from">Từ ngày:</label>
        <input type="date" name="from" id="from" required>

        <label for="to">Đến ngày:</label>
        <input type="date" name="to" id="to" required>

        <button type="submit">Gửi yêu cầu</button>
    </form>

    <a href="../home.jsp" class="back-home">🏠 Quay về Trang chủ</a>
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
