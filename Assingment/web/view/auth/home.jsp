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

        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
            font-size: 22px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info span {
            font-weight: bold;
        }

        .user-info a {
            color: white;
            text-decoration: none;
            background-color: rgba(255, 255, 255, 0.2);
            padding: 6px 14px;
            border-radius: 6px;
            transition: 0.2s;
        }

        .user-info a:hover {
            background-color: rgba(255, 255, 255, 0.35);
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
        <div class="user-info">
            <span>Xin chào, <c:out value="${sessionScope.user.displayname}" /></span>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
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
</body>
</html>
