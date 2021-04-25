<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.sql.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>AutoBid</title>
</head>
<body>

	<%
		try {
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			Statement stmt2 = con.createStatement();
			
			int auc_id = Integer.parseInt(request.getParameter("auc_id"));
			float bid_limit = Float.parseFloat(request.getParameter("bid_limit"));
			float bid_inc = Float.parseFloat(request.getParameter("bid_inc"));
			String username = (String) session.getAttribute("usern");
			
			//query to get auction information
			String query = "SELECT auctionID, currentPrice, bidIncrement FROM auction WHERE auctionID = " + auc_id;
			ResultSet result = stmt.executeQuery(query);
			
			//query to check if bid already exists
			String query2 = "SELECT auctionID, username, bidLimit, bidIncrement FROM auto_bid WHERE auctionID =" + auc_id + " AND username = '" + username + "'";
			ResultSet result2 = stmt2.executeQuery(query2);
			
			if (!result.next()) { //if auction does not exist
				
				%>
				<br>
				That Auction Does Not Exist.
				<br>
				<form method = "post" action = "EndUserCustomer.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%		
				 
				//if bid limit is below or equal to price + increment
			} else if (bid_limit <= result.getFloat("currentPrice") + result.getFloat("bidIncrement")) {
				
				%>
				<br>
				Bid Limit Is Too Low.
				<br>
				<form method = "post" action = "EndUserCustomer.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%
				
			} else if (bid_inc < result.getFloat("bidIncrement")) { //if bid increment is less than minimum increment
				
				%>
				<br>
				Bid Increment Is Too Low.
				<br>
				<form method = "post" action = "EndUserCustomer.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%
				
			} else if (result2.next()) { //if bid already exists then update
				
				String update = "UPDATE auto_bid SET bidLimit = '" + bid_limit + "', bidIncrement = '" + bid_inc + "' WHERE auctionID = " + auc_id + " AND username = '" + username + "'";
				Statement updateStmt = con.createStatement();
				updateStmt.executeUpdate(update);
				
				%>
				<br>
				Your Bid Was Updated.
				<br>
				<form method = "post" action = "EndUserCustomer.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%	
				
			} else { //add auto bid
				
				String add = "insert into auto_bid values ('" + username + "'," + auc_id + "," + bid_limit + "," + bid_inc + ")";
				PreparedStatement ps = con.prepareStatement(add);
				int r = ps.executeUpdate();
				
				if (r > 0) {
					out.print("Your Bid Was Added");
					
				} else {
					out.print("Bid Could Not be Added");
					
				}
				
				%>
				<br>
				<form method = "post" action = "EndUserCustomer.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%
				
			}
			
			db.closeConnection(con);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>

</body>
</html>