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
			String username = (String) session.getAttribute("username");
			
			//query to get auction information
			String query = "SELECT auction_id, price, bid_inc FROM auctions WHERE auction_id = " + auc_id;
			ResultSet result = stmt.executeQuery(query);
			
			//query to check if bid already exists
			String query2 = "SELECT auction_id, username FROM auto_bids WHERE auction_id =" + auc_id + " AND username = '" + username + "'";
			ResultSet result2 = stmt2.executeQuery(query2);
			
			if (result2.next()) { //if bid already exists
				%>
				<br>
				You've Already Set A Bid On This Auction.
				<br>
				<form method = "post" action = "AutoBid.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%	
			} else if (!result.next()) { //if auction does not exist
				
				%>
				<br>
				That Auction Does Not Exist.
				<br>
				<form method = "post" action = "AutoBid.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%		
				
			} else if (bid_limit <= result.getFloat("price")) { //if bid limit is below price
				
				%>
				<br>
				Bid Limit Is Too Low.
				<br>
				<form method = "post" action = "AutoBid.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%
				
			} else if (bid_inc < result.getFloat("bid_inc")) { //if bid increment is less than minimum increment
				
				%>
				<br>
				Bid Increment Is Too Low.
				<br>
				<form method = "post" action = "AutoBid.jsp">
				<input type = "submit" value = "Go back">
				</form>
				<%
				
			} else { //add auto bid
				
				String add = "insert into auto_bids values (" + auc_id + ",'" + username + "'," + bid_limit + "," + bid_inc + ")";
				PreparedStatement ps = con.prepareStatement(add);
				int r = ps.executeUpdate();
				
				if (r > 0) {
					out.print("Your Bid Was Added");
					
				} else {
					out.print("Bid Could Not be Added");
					
				}
				
				%>
				<br>
				<form method = "post" action = "AutoBid.jsp">
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