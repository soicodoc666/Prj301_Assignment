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
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            margin-left: 20px;
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
</head>
<body>
<header>
    <h2>Tạo đơn nghỉ phép</h2>
    <div>
        <a href="../home">Trang chủ</a>
        <a href="list">Xem đơn</a>
        <a href="../logout">Đăng xuất</a>
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
