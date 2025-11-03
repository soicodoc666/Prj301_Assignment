<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Quản lý nghỉ phép</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f5f6f8;
            margin: 0;
            padding: 0;
        }

        /* Header mới với avatar và dropdown */
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

        .container {
            max-width: 1000px;
            margin: 60px auto;
            text-align: center;
        }

        h3 {
            font-size: 26px;
            color: #333;
            margin-bottom: 40px;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            justify-items: center;
        }

        .menu-item {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            width: 220px;
            height: 150px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            font-size: 17px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        .menu-item i {
            font-size: 36px;
            color: #e1251b;
            margin-bottom: 10px;
        }

        footer {
            text-align: center;
            margin-top: 50px;
            color: #777;
            font-size: 13px;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <header>
        <h2>🏢 Hệ thống Quản lý Nghỉ phép</h2>
        <div class="user-menu" onclick="toggleMenu()">
            <span>Xin chào, <c:out value="${sessionScope.user.displayname}" /></span>
            <div class="avatar-small"></div>
            <div class="dropdown" id="dropdownMenu">
                <a href="profile">Thông tin tài khoản</a>
                <a href="request/history">Lịch sử tạo đơn</a>
                <a href="logout">Đăng xuất</a>
            </div>
        </div>
    </header>

    <div class="container">
        <h3>Chọn chức năng bạn muốn thực hiện</h3>

        <div class="menu">
            <a href="request/create" class="menu-item">
                <i class="fa-solid fa-file-circle-plus"></i>
                Tạo đơn nghỉ phép
            </a>

            <a href="request/list" class="menu-item">
                <i class="fa-solid fa-list-check"></i>
                Xem đơn đã tạo
            </a>

            <a href="iam/history" class="menu-item">
                <i class="fa-solid fa-clock-rotate-left"></i>
                Lịch sử đăng nhập
            </a>

            <a href="division/agenda" class="menu-item">
                <i class="fa-solid fa-calendar-days"></i>
                Agenda (Lịch làm việc)
            </a>
        </div>
    </div>

    <footer>
        © 2025 - Hệ thống Quản lý Nghỉ phép | FPT University
    </footer>

    <script>
        function toggleMenu() {
            const menu = document.getElementById('dropdownMenu');
            menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
        }

        // Đóng menu khi click ra ngoài
        window.onclick = function(e) {
            const menu = document.getElementById('dropdownMenu');
            if (!e.target.closest('.user-menu')) {
                menu.style.display = 'none';
            }
        }
    </script>
</body>
</html>
