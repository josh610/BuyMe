<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>AutoBid</title>
</head>
<body>

<form method = "post" action = "Auctions.jsp">
<input type = "submit" value = "See Available Auctions">
</form>
<br>
<form method = "get" action = "AutoBidAdded.jsp">
<td>Auction ID</td><td><input type = "text" name = "auc_id"></td>
<td>Bid Upper Limit</td><td><input type = "text" name = "bid_limit"></td>
<td>Bid Increment</td><td><input type = "text" name = "bid_inc"></td>

<input type = "submit" value = "Set Auto Bid">
</form>
<br>
<form action="home.jsp" method="post">
<input type = "submit" value = "Log out">
</form>

</body>
</html>