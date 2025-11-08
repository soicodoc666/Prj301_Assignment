<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>📢 Thông báo</title>
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
}
.container {
    max-width: 900px;
    margin: 40px auto;
    background: white;
    padding: 25px 40px;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
h3 {
    color: #e1251b;
    margin-top: 0;
}
.section {
    margin-top: 25px;
}
.noti {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 10px;
    line-height: 1.6;
    transition: background 0.2s;
}
.noti.unseen {
    background: #fff3f3;
}
.noti.seen {
    background: #f2f8ff;
}
.noti small {
    display: block;
    color: #666;
}
button {
    background-color: #e1251b;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 8px 14px;
    cursor: pointer;
    margin-top: 8px;
    font-weight: bold;
}
button:hover {
    background-color: #c01c13;
}
.actions {
    text-align: right;
    margin-bottom: 20px;
}
.empty {
    color: #777;
    text-align: center;
    margin: 25px 0;
}
.back-btn {
    display: inline-block;
    background-color: #e1251b;
    color: white;
    padding: 10px 20px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    transition: background 0.2s;
}
.back-btn:hover {
    background-color: #c01c13;
}
</style>
</head>
<body>

<header>
    <h2>📢 Thông báo của bạn</h2>
    <a href="${pageContext.request.contextPath}/home" class="back-btn">🏠 Quay về trang chủ</a>
</header>

<div class="container">
    <div class="actions">
        <form action="${pageContext.request.contextPath}/division/notification" method="post" style="display:inline;">
            <input type="hidden" name="action" value="markAll"/>
            <button type="submit">Đánh dấu tất cả đã xem</button>
        </form>
    </div>

    <!-- 🔴 Chưa đọc -->
    <div class="section">
        <h3>🔴 Thông báo chưa đọc</h3>
        <c:set var="hasUnseen" value="false" />
        <c:forEach var="n" items="${notifications}">
            <c:if test="${!n.isSeen}">
                <c:set var="hasUnseen" value="true" />
                <div class="noti unseen">
                    <p>${n.message}</p>
                    <small>${n.createdTime}</small>
                    <form action="${pageContext.request.contextPath}/division/notification" method="post">
                        <input type="hidden" name="action" value="markOne"/>
                        <input type="hidden" name="nid" value="${n.nid}"/>
                        <button type="submit">Đã xem</button>
                    </form>
                </div>
            </c:if>
        </c:forEach>
        <c:if test="${!hasUnseen}">
            <div class="empty">Không có thông báo chưa đọc.</div>
        </c:if>
    </div>

    <!-- 🔵 Đã đọc -->
    <div class="section">
        <h3>🔵 Thông báo đã đọc</h3>
        <c:set var="hasSeen" value="false" />
        <c:forEach var="n" items="${notifications}">
            <c:if test="${n.isSeen}">
                <c:set var="hasSeen" value="true" />
                <div class="noti seen">
                    <p>${n.message}</p>
                    <small>${n.createdTime}</small>
                </div>
            </c:if>
        </c:forEach>
        <c:if test="${!hasSeen}">
            <div class="empty">Chưa có thông báo đã đọc.</div>
        </c:if>
    </div>
</div>

</body>
</html>
