<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f9f9f9; }
            .container {
                width: 60%;
                margin: 80px auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 { color: #333; }
            ul { list-style: none; padding: 0; }
            li { margin: 10px 0; }
            a { text-decoration: none; color: #0066cc; font-weight: bold; }
            a:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Xin chào, ${user.username}!</h2>
            <p>Chào mừng bạn đến với hệ thống quản lý nghỉ phép.</p>

            <h3>Menu chức năng</h3>
            <ul>
                <li><a href="request/create">Tạo yêu cầu nghỉ phép mới</a></li>
                <li><a href="request/list">Xem danh sách yêu cầu nghỉ phép</a></li>
                <li><a href="logout">Đăng xuất</a></li>
            </ul>
        </div>
    </body>
</html>
