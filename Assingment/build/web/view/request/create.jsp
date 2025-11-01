<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo yêu cầu nghỉ phép</title>
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
            position: relative;
        }

        header h2 {
            margin: 0;
        }

        .account-menu {
            position: relative;
            display: inline-block;
        }

        .account-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #fff;
            background-image: url('https://cdn-icons-png.flaticon.com/512/847/847969.png');
            background-size: cover;
            cursor: pointer;
        }

        .dropdown {
            display: none;
            position: absolute;
            right: 0;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            min-width: 180px;
            z-index: 100;
            overflow: hidden;
        }

        .dropdown a {
            display: block;
            padding: 12px 16px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            border-bottom: 1px solid #eee;
        }

        .dropdown a:hover {
            background-color: #f4f4f4;
        }

        .dropdown a.logout {
            color: #e1251b;
            font-weight: bold;
        }

        .container {
            max-width: 600px;
            margin: 60px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px 40px;
        }

        h3 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: bold;
            margin-bottom: 6px;
            color: #444;
        }

        input[type="date"],
        textarea {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            width: 100%;
        }

        textarea {
            resize: none;
            height: 100px;
        }

        button {
            background-color: #e1251b;
            color: white;
            padding: 12px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s;
        }

        button:hover {
            opacity: 0.9;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #e1251b;
            font-weight: bold;
        }

        .back:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        // JavaScript toggle cho menu tài khoản
        function toggleMenu() {
            const menu = document.getElementById("dropdown");
            menu.style.display = (menu.style.display === "block") ? "none" : "block";
        }

        // Ẩn menu khi click ra ngoài
        window.onclick = function(event) {
            if (!event.target.matches('.account-icon')) {
                const menu = document.getElementById("dropdown");
                if (menu && menu.style.display === "block") {
                    menu.style.display = "none";
                }
            }
        }
    </script>
</head>
<body>
<header>
    <h2>Tạo đơn nghỉ phép</h2>
    <div class="account-menu">
        <div class="account-icon" onclick="toggleMenu()"></div>
        <div class="dropdown" id="dropdown">
            <a href="../profile.jsp">Thông tin tài khoản</a>
            <a href="list">Lịch sử tạo đơn</a>
            <a href="../logout" class="logout">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="container">
    <h3>Nhập thông tin đơn nghỉ phép</h3>

    <form action="create" method="post">
        <label for="reason">Lý do nghỉ:</label>
        <textarea id="reason" name="reason" placeholder="Nhập lý do nghỉ phép..." required></textarea>

        <label for="from">Từ ngày:</label>
        <input type="date" id="from" name="from" required>

        <label for="to">Đến ngày:</label>
        <input type="date" id="to" name="to" required>

        <button type="submit">Gửi yêu cầu</button>
    </form>

    <a href="list" class="back">← Quay lại danh sách yêu cầu</a>
</div>

</body>
</html>
