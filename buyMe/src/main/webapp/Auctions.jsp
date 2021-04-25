<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.sql.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auctions</title>
</head>
<body>
	<%
		try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			String auctions = "SELECT * FROM auctions";
			ResultSet result = stmt.executeQuery(auctions);
			%>
			<table>
			<tr>
			<th>Auction ID</th>
			<th>Item Name</th>
			<th>Price</th>
			<th>Closing Date</th>
			<th>Bid Increment</th>
			</tr>
			<%
			
			while (result.next()) { //prints all available auctions
				
				int id = result.getInt("auction_id");
				String item = result.getString("item_title");
				float price = result.getFloat("price");
				java.sql.Date date = result.getDate("closing");
				float bid_inc = result.getFloat("bid_inc");
				%>
				<tr>
				<td><%out.print(id);%></td>
				<td><%out.print(item);%></td>
				<td><%out.print(price);%></td>
				<td><%out.print(date);%></td>
				<td><%out.print(bid_inc); %></td>
				</tr>
				<%
			}
			
			%>
			</table>
			<form method = "post" action = "AutoBid.jsp">
			<input type = "submit" value = "Go back">
			</form>
			<%
			db.closeConnection(con);
			
		} catch (Exception e) {
			out.print("Something went wrong");
		}
	
	
	
	
	%>

</body>
</html>