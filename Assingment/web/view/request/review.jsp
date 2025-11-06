<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn nghỉ phép</title>
        <style>
            body {
                font-family: "Segoe UI", sans-serif;
                background-color: #f4f6f8;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 600px;
                margin: 40px auto;
                background: white;
                border-radius: 12px;
                padding: 30px 40px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }
            label {
                font-weight: bold;
                display: block;
                margin-top: 10px;
                color: #222;
            }
            input[type="text"], input[type="date"], textarea {
                width: 100%;
                padding: 10px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }
            textarea {
                resize: vertical;
                min-height: 80px;
            }
            button {
                margin-top: 20px;
                padding: 10px 15px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                transition: all 0.2s ease;
            }
            .btn-update {
                background-color: #007bff;
                color: white;
            }
            .btn-update:hover {
                background-color: #0056b3;
            }

            .btn-delete {
                background-color: #6c757d;
                color: white;
            }
            .btn-delete:hover {
                background-color: #565e64;
            }

            .btn-approve {
                background-color: #28a745;
                color: white;
            }
            .btn-approve:hover {
                background-color: #1e7e34;
            }

            .btn-reject {
                background-color: #dc3545;
                color: white;
            }
            .btn-reject:hover {
                background-color: #b02a37;
            }

            a.back {
                display: inline-block;
                margin-top: 20px;
                color: #e1251b;
                text-decoration: none;
                font-weight: bold;
            }
            .msg-success {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
            }
            .msg-error {
                background-color: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 15px;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Chi tiết đơn nghỉ phép</h2>

            <!-- Thông báo -->
            <c:if test="${not empty success}">
                <div class="msg-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="msg-error">${error}</div>
            </c:if>

            <form action="review" method="post">
                <input type="hidden" name="id" value="${reqLeave.id}">

                <!-- Tiêu đề -->
                <label>Tiêu đề:</label>
                <input type="text" name="title" value="${reqLeave.title}"
                       <c:if test="${!isOwner}">readonly</c:if> required>

                       <!-- Từ ngày -->
                       <label>Từ ngày:</label>
                       <input type="date" name="from"
                              value="${reqLeave.from}"
                       <c:if test="${!isOwner}">readonly</c:if> required>

                       <!-- Đến ngày -->
                       <label>Đến ngày:</label>
                       <input type="date" name="to"
                              value="${reqLeave.to}"
                       <c:if test="${!isOwner}">readonly</c:if> required>

                       <!-- Lý do -->
                       <label>Lý do:</label>
                       <textarea name="reason" rows="4"
                       <c:if test="${!isOwner}">readonly</c:if> required>${reqLeave.reason}</textarea>

                       <!-- Trạng thái -->
                       <label>Trạng thái:</label>
                       <p>
                       <c:choose>
                           <c:when test="${reqLeave.status eq 0}">
                               <span style="color:#f0ad4e; font-weight:bold;">Đang chờ duyệt</span>
                           </c:when>
                           <c:when test="${reqLeave.status eq 1}">
                               <span style="color:#28a745; font-weight:bold;">Đã duyệt</span>
                           </c:when>
                           <c:otherwise>
                               <span style="color:#dc3545; font-weight:bold;">Đã từ chối</span>
                           </c:otherwise>
                       </c:choose>
                </p>

                <!-- Nút hành động -->
                <div>
                    <c:if test="${isOwner}">
                        <button name="action" value="update" class="btn-update">Cập nhật</button>
                        <button name="action" value="delete" class="btn-delete"
                                onclick="return confirm('Bạn có chắc muốn xóa đơn này không?');">Xóa</button>
                    </c:if>

                    <c:if test="${!isOwner && reqLeave.status eq 0}">
                        <button name="action" value="approve" class="btn-approve">Chấp nhận</button>
                        <button name="action" value="reject" class="btn-reject">Từ chối</button>
                    </c:if>
                </div>
            </form>

            <a href="list" class="back">← Quay lại danh sách</a>
        </div>
    </body>
</html>
