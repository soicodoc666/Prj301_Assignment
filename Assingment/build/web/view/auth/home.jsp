<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ người dùng</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        /* Header */
        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        header h2 {
            margin: 0;
        }

        .user-menu {
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
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
            max-width: 1100px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }

        .stats {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }

        .card {
            flex: 1;
            background-color: #f9fafb;
            margin: 0 10px;
            padding: 25px;
            border-radius: 8px;
            border: 1px solid #ddd;
            text-align: center;
            transition: 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }

        .card h4 {
            margin: 10px 0;
            color: #333;
        }

        .card p {
            color: #666;
        }

        /* Nút hành động */
        .actions {
            text-align: center;
            margin-top: 30px;
        }

        .btn {
            display: inline-block;
            background-color: #e1251b;
            color: white;
            padding: 12px 25px;
            margin: 0 10px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn:hover {
            background-color: #c91f16;
        }
    </style>
</head>
<body>
<header>
    <h2>My Empire</h2>
    <div class="user-menu" onclick="toggleMenu()">
        <div class="avatar-small"></div>
        <div class="dropdown" id="dropdownMenu">
            <a href="profile">Thông tin tài khoản</a>
            <a href="request/history">Lịch sử tạo đơn</a>
            <a href="logout">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="container">
    <div class="stats">
        <div class="card">
            <h4>Yêu cầu nghỉ phép</h4>
            <p>3 yêu cầu đang chờ duyệt</p>
        </div>
        <div class="card">
            <h4>Ngày nghỉ còn lại</h4>
            <p>10 ngày</p>
        </div>
        <div class="card">
            <h4>Trạng thái tài khoản</h4>
            <p>Hoạt động</p>
        </div>
    </div>

    <div class="actions">
        <a href="request/create" class="btn">➕ Tạo đơn nghỉ phép</a>
        <a href="request/list" class="btn">📄 Xem đơn của tôi</a>
    </div>
</div>

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
