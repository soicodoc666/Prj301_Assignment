<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - Quản lý nghỉ phép</title>
        <style>
            body {
                font-family:"Segoe UI",sans-serif;
                background-color:#f5f6f8;
                margin:0;
                padding:0;
            }
            header {
                background-color:#e1251b;
                color:white;
                padding:15px 40px;
                display:flex;
                justify-content:space-between;
                align-items:center;
                position:relative;
            }
            header h2 {
                margin:0;
                font-size:22px;
            }
            .user-menu {
                position:relative;
                cursor:pointer;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .avatar-small {
                width:45px;
                height:45px;
                border-radius:50%;
                background:url('https://i.ibb.co/4pDNDk1/avatar.png') center/cover;
                border:2px solid white;
                position:relative;
            }
            .notification-badge {
                background:red;
                color:white;
                border-radius:50%;
                font-size:12px;
                padding:2px 6px;
                position:absolute;
                top:-5px;
                right:-5px;
            }
            .dropdown {
                display:none;
                position:absolute;
                top:65px;
                right:0;
                background-color:#fff;
                border-radius:8px;
                box-shadow:0 4px 10px rgba(0,0,0,0.15);
                min-width:300px;
                z-index:10;
                max-height:400px;
                overflow-y:auto;
            }
            .dropdown div, .dropdown a, .dropdown form {
                display:block;
                padding:10px 16px;
                color:#333;
                text-decoration:none;
                border-bottom:1px solid #eee;
            }
            .dropdown div:hover, .dropdown a:hover, .dropdown form:hover {
                background-color:#f9f9f9;
            }
            .dropdown .unseen {
                font-weight:bold;
                color:#e1251b;
            }
            .dropdown a:last-child {
                border-bottom:none;
                color:#e1251b;
                font-weight:bold;
            }
            .container {
                max-width:1000px;
                margin:60px auto;
                text-align:center;
            }
            h3 {
                font-size:26px;
                color:#333;
                margin-bottom:40px;
            }
            .menu {
                display:grid;
                grid-template-columns:repeat(auto-fit, minmax(220px,1fr));
                gap:25px;
                justify-items:center;
            }
            .menu-item {
                background-color:white;
                border-radius:12px;
                box-shadow:0 3px 10px rgba(0,0,0,0.1);
                width:220px;
                height:150px;
                display:flex;
                flex-direction:column;
                justify-content:center;
                align-items:center;
                text-decoration:none;
                color:#333;
                font-weight:bold;
                font-size:17px;
                transition:transform 0.2s, box-shadow 0.2s;
            }
            .menu-item:hover {
                transform:translateY(-5px);
                box-shadow:0 6px 15px rgba(0,0,0,0.15);
            }
            .menu-item i {
                font-size:36px;
                color:#e1251b;
                margin-bottom:10px;
            }
            .search-box {
                background-color:white;
                border-radius:12px;
                box-shadow:0 3px 10px rgba(0,0,0,0.1);
                margin-top:50px;
                padding:25px;
                text-align:left;
            }
            input[type="text"] {
                width:80%;
                padding:10px;
                border:1px solid #ccc;
                border-radius:6px;
                font-size:15px;
            }
            button {
                background-color:#e1251b;
                color:white;
                border:none;
                padding:10px 20px;
                border-radius:6px;
                font-size:16px;
                margin-left:10px;
                cursor:pointer;
                font-weight:bold;
            }
            button:hover {
                background-color:#c51d15;
            }
            .info-box {
                margin-top:20px;
                background:#f9f9f9;
                padding:15px;
                border-left:4px solid #e1251b;
                border-radius:8px;
                text-align:left;
                line-height:1.8;
            }
            .error {
                color:red;
                margin-top:10px;
                font-weight:bold;
            }
            footer {
                text-align:center;
                margin-top:50px;
                color:#777;
                font-size:13px;
            }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>
        <header>
            <h2>🏢 Hệ thống Quản lý Nghỉ phép</h2>
            <div class="user-menu" onclick="toggleMenu()">
                <span>Xin chào, <c:out value="${sessionScope.user.displayname}" /></span>
                <div class="avatar-small">
                    <c:if test="${unseenCount > 0}">
                        <div class="notification-badge">${unseenCount}</div>
                    </c:if>
                </div>
                <div class="dropdown" id="dropdownMenu">        
                    <a href="${pageContext.request.contextPath}/auth/info">Thông tin tài khoản</a>
                    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
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
                <a href="division/notification" class="menu-item">
                    <i class="fa-solid fa-bell"></i>
                    Thông báo
                </a>
                <a href="division/agenda" class="menu-item">
                    <i class="fa-solid fa-calendar-days"></i>
                    Agenda (Lịch làm việc)
                </a>
            </div>

            <!-- 🔍 KHU VỰC TÌM KIẾM NHÂN SỰ -->
            <div class="search-box">
                <h3>🔍 Tìm kiếm nhân sự</h3>
                <form action="home" method="get">
                    <input type="text" name="ename" placeholder="Nhập tên nhân viên..." value="${param.ename}">
                    <button type="submit">Tìm kiếm</button>
                </form>

                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>

                <c:if test="${not empty foundEmployees}">
                    <div class="info-box">
                        <h4>Kết quả tìm thấy:</h4>
                        <c:forEach var="emp" items="${foundEmployees}">
                            👤 <b>Tên:</b> ${emp.name}<br>
                            🏢 <b>Phòng ban:</b> ${emp.dept.name}<br>
                            🏷 <b>Vai trò:</b> <c:out value="${emp.role != null ? emp.role : 'Nhân viên'}"/><br>
                            <hr>
                        </c:forEach>
                    </div>
                </c:if>
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
            window.onclick = function (e) {
                const menu = document.getElementById('dropdownMenu');
                if (!e.target.closest('.user-menu')) {
                    menu.style.display = 'none';
                }
            }
        </script>
    </body>
</html>
