<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        /* Nền trắng sáng nhẹ */
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f8f9fb;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Hộp đăng nhập trung tâm */
        .login-container {
            background-color: #ffffff;
            padding: 45px 40px;
            border-radius: 16px;
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.12);
            width: 380px;
            text-align: center;
        }

        /* Tiêu đề */
        h2 {
            margin-bottom: 25px;
            color: #222;
            font-size: 26px;
            font-weight: 700;
        }

        /* Nhóm input */
        .form-group {
            position: relative;
            margin-bottom: 22px;
        }

        input {
            width: 100%;
            padding: 13px 42px 13px 14px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            transition: 0.25s;
            box-sizing: border-box;
            background-color: #fdfdfd;
        }

        input:focus {
            border-color: #e1251b;
            box-shadow: 0 0 4px rgba(225, 37, 27, 0.25);
            outline: none;
            background-color: #fff;
        }

        /* Icon hiện mật khẩu */
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            font-size: 18px;
            transition: color 0.2s;
        }

        .toggle-password:hover {
            color: #e1251b;
        }

        /* Nút đăng nhập */
        button {
            width: 100%;
            padding: 12px;
            background-color: #e1251b;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        button:hover {
            background-color: #c11f15;
            box-shadow: 0 3px 10px rgba(225, 37, 27, 0.3);
        }

        /* Thông báo lỗi */
        .error {
            color: #e1251b;
            background: #ffeaea;
            padding: 10px 12px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 14px;
            text-align: left;
        }

        /* Footer */
        .footer {
            margin-top: 18px;
            font-size: 13px;
            color: #888;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>

        <% 
            String error = (String) request.getAttribute("error");
            String username = (String) request.getAttribute("username");
            if(error != null){ 
        %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <input type="text" name="username" placeholder="Tên đăng nhập" 
                       value="<%= username != null ? username : "" %>" required>
            </div>

            <div class="form-group">
                <input type="password" id="password" name="password" placeholder="Mật khẩu" required>
                <span class="toggle-password" onclick="togglePassword()">👁</span>
            </div>

            <button type="submit">Đăng nhập</button>
        </form>

        <div class="footer">© 2025 - Hệ thống quản lý nhân sự</div>
    </div>

    <script>
        function togglePassword() {
            const pwd = document.getElementById("password");
            const toggle = document.querySelector(".toggle-password");
            if (pwd.type === "password") {
                pwd.type = "text";
                toggle.textContent = "👁";
            } else {
                pwd.type = "password";
                toggle.textContent = "👁";
            }
        }
    </script>
</body>
</html>
