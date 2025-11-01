<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin tài khoản</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        /* Avatar menu giống trang home */
        .user-menu {
            position: relative;
            display: flex;
            align-items: center;
        }

        .user-menu .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: url('https://cdn-icons-png.flaticon.com/512/149/149071.png') center/cover no-repeat;
            cursor: pointer;
            border: 2px solid white;
        }

        .dropdown {
            position: absolute;
            top: 50px;
            right: 0;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            display: flex;
            flex-direction: column;
            width: 180px;
            z-index: 100;
        }

        .dropdown a {
            padding: 12px 16px;
            text-decoration: none;
            color: #333;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
        }

        .dropdown a:hover {
            background-color: #f4f4f4;
        }

        .dropdown a.logout {
            color: #e1251b;
            font-weight: bold;
        }

        .hidden {
            display: none;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px 40px;
        }

        .container h3 {
            text-align: center;
            color: #e1251b;
            margin-bottom: 30px;
        }

        .info-item {
            margin-bottom: 20px;
        }

        .info-item label {
            font-weight: bold;
            color: #333;
            display: block;
            margin-bottom: 6px;
        }

        .info-item span {
            display: block;
            color: #555;
            background: #f9fafb;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #eee;
        }

        .back-btn {
            display: block;
            margin: 20px auto 0;
            padding: 10px 25px;
            background-color: #e1251b;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            text-align: center;
            font-weight: bold;
            transition: background-color 0.2s;
        }

        .back-btn:hover {
            background-color: #c61d13;
        }
    </style>
</head>
<body>

<header>
    <h2>Hệ thống Quản lý Nghỉ phép</h2>
    <div class="user-menu">
        <div class="avatar" onclick="toggleMenu()"></div>
        <div id="dropdownMenu" class="dropdown hidden">
            <a href="info.jsp">Thông tin tài khoản</a>
            <a href="../request/list">Lịch sử tạo đơn</a>
            <a href="../logout" class="logout">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="container">
    <h3>Thông tin tài khoản</h3>

    <div class="info-item">
        <label>Tên đăng nhập:</label>
        <span>${user.username}</span>
    </div>

    <div class="info-item">
        <label>Họ và tên:</label>
        <span>${user.fullname}</span>
    </div>

    <div class="info-item">
        <label>Email:</label>
        <span>${user.email}</span>
    </div>

    <div class="info-item">
        <label>Chức vụ / Vai trò:</label>
        <span>${user.role}</span>
    </div>

    <div class="info-item">
        <label>Ngày nghỉ còn lại:</label>
        <span>10 ngày</span>
    </div>

    <a href="../home" class="back-btn">⬅ Quay lại trang chủ</a>
</div>

<script>
function toggleMenu() {
    document.getElementById("dropdownMenu").classList.toggle("hidden");
}
window.addEventListener("click", function(e) {
    if (!e.target.closest(".user-menu")) {
        document.getElementById("dropdownMenu").classList.add("hidden");
    }
});
</script>

</body>
</html>
