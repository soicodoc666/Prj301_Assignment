<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
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

            .user-menu {
                position: relative;
                display: flex;
                align-items: center;
                cursor: pointer;
            }

            .avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: url('https://cdn-icons-png.flaticon.com/512/149/149071.png') center/cover no-repeat;
                border: 2px solid white;
                margin-left: 10px;
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
            <div class="user-menu" onclick="toggleMenu()">
                Xin chào, <c:out value="${user.displayname}"/>
                <div class="avatar"></div>
                <div id="dropdownMenu" class="dropdown hidden">
                    <a href="${pageContext.request.contextPath}/auth/info">Thông tin tài khoản</a>
                    <a href="${pageContext.request.contextPath}/logout" class="logout">Đăng xuất</a>
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
                <label>Tên hiển thị:</label>
                <span>${user.displayname}</span>
            </div>

            <c:if test="${not empty user.employee}">
                <div class="info-item">
                    <label>Họ và tên nhân viên:</label>
                    <span>${user.employee.name}</span>
                </div>

                <c:if test="${not empty user.employee.dept}">
                    <div class="info-item">
                        <label>Phòng ban:</label>
                        <span>${user.employee.dept.name}</span>
                    </div>
                </c:if>

                <c:if test="${not empty user.employee.role}">
                    <div class="info-item">
                        <label>Vai trò:</label>
                        <span>${user.employee.role}</span>
                    </div>
                </c:if>
            </c:if>

            <c:if test="${not empty user.role}">
                <div class="info-item">
                    <label>Vai trò chính (User):</label>
                    <span>${user.role.name}</span>
                </div>
            </c:if>

            <a href="${pageContext.request.contextPath}/home" class="back-btn">⬅ Quay lại trang chủ</a>
        </div>

        <script>
            function toggleMenu() {
                document.getElementById("dropdownMenu").classList.toggle("hidden");
            }

            window.addEventListener("click", function (e) {
                if (!e.target.closest(".user-menu")) {
                    document.getElementById("dropdownMenu").classList.add("hidden");
                }
            });
        </script>

    </body>
</html>
