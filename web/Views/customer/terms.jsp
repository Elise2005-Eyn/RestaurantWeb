<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Điều lệ đặt bàn</title>
    <style>
        .terms-container {
            width: 60%;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }
        .terms-container h2 {
            text-align: center;
        }
        .terms-container textarea {
            width: 100%;
            height: 300px;
            resize: none;
            padding: 10px;
            margin-bottom: 20px;
        }
        .btn-submit {
            display: block;
            width: 200px;
            margin: 0 auto;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .msg {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="terms-container">
    <h2>Điều lệ trước khi đặt bàn</h2>
    
    <form action="terms" method="post">
        <textarea readonly>
1. Khách hàng cần cung cấp đầy đủ thông tin liên hệ.
2. Không huỷ đặt bàn quá sát giờ.
3. Nhà hàng có quyền từ chối khách vi phạm điều lệ.
4. ...
        </textarea>
        <br>
        <label>
            <input type="checkbox" name="agree"> Tôi đồng ý với Điều lệ đặt bàn
        </label>
        <br><br>
        <div class="msg">
            ${msg != null ? msg : ""}
        </div>
        <button type="submit" class="btn-submit">Tiếp tục đặt bàn</button>
    </form>
</div>
</body>
</html>
