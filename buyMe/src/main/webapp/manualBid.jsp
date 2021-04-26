<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Your Bid</title>
</head>
<body>
	
	<%
	if(session.getAttribute("usern") == null) {
		out.print("No Account Found.");
		%>
		<%--Return to home button--%>
		<form method="post" action="home.jsp">
  		<input type="submit" value="Return to Home Page" />
		</form>
		<%
	}
	else{
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		//Create a SQL statement
		Statement stmt = con.createStatement();
	
	
		
		//make sure the auctionID exists, is not expired, is not placed by the bider, and the increase price is above current price. 
		try{
			//get the auction id passed and price
			String givenAuctionID = request.getParameter("auctionID");
			int auctionID = Integer.parseInt(givenAuctionID); 
			String givenBidPrice = request.getParameter("bidPrice");
			float bidPrice = Float.parseFloat(givenBidPrice);
			
			//get the highest bid number and add 1 to create a new bidID.  
			String str = "SELECT max(bidID) as f FROM manual_bid"; 
			ResultSet result = stmt.executeQuery(str);
			result.next(); 
			int bidNumber = result.getInt("f"); 
			bidNumber++; 
			
			int decision = 0;
			
			//query the auctionID to make sure it exists find the guy who auctioned 
			String queryAuction = "select auctionID from auction where auctionID = " + auctionID + ";"; 
			ResultSet existing = stmt.executeQuery(queryAuction); 
			//not in auction table, then not a valid ID
			if(!existing.next()) {
				out.println("There is no auction relating to the given auction ID");
				decision = 1; 
			}
			
			
			//query the winners table to see if the auction is over or not. 
			String queryWinner = "select auctionID from winner where auctionID = " + auctionID + ";"; 
			ResultSet winner = stmt.executeQuery(queryWinner);
			//the auction has a winner, therefore not active.  
			if(winner.next() && decision == 0) {
				out.println("The auction relating to the given auction ID has already ended.");
				decision = 2; 
			}
			
		
			//query the actionID to find if the bid price is high enough. 
			if(decision == 0) {
				String queryPrices = "select currentPrice, bidIncrement from auction where auctionID = " + auctionID; 
				ResultSet prices = stmt.executeQuery(queryPrices);
				
				prices.next(); 
				
				float currentPrice = prices.getFloat("currentPrice");
				float bidIncrement = prices.getFloat("bidIncrement");
				//out.println("price: " + currentPrice + " | bidIncrement: " + bidIncrement);
				//the bid is not high enough  
				if(bidPrice < currentPrice + bidIncrement) {
					out.println("Your bid of " + bidPrice + " is not high enough, the current price is " + currentPrice + " and has a minimum increase of " + bidIncrement);
				}
				//the bid is valid, place the bid and notify others 
				else{
					//insert the new bid into the manual bid table 
					String insertBid = "insert into manual_bid values( '" + auctionID +"', '"+ session.getAttribute("usern") +"', " + bidPrice + ", " + bidNumber + ");";
					PreparedStatement ps = con.prepareStatement(insertBid); 
					int r = ps.executeUpdate();
					//the bid was set 
					if(r > 0) {
						//update the price of the item in the auction table 
						String updatePrice = "update auction set currentPrice = " + bidPrice + ", highestBidder = '" + session.getAttribute("usern") + "' where auctionID =" + auctionID;
						stmt.executeUpdate(updatePrice);
						
						out.println("Your bid has been succesfully added at a price of " + bidPrice);
						
						//find the previous highest bider and alert them that they have been outbid, 
						String userOutbidQuery = "select username from manual_bid where auctionID = " + auctionID + " and bidPrice = " + currentPrice; //currentPrice is now the old price
						ResultSet userResult = stmt.executeQuery(userOutbidQuery);
						//there is someone to alert. 
						if(userResult.next()) {
							
							//the person who the alert is going to. 
							String biderUsername = userResult.getString("username"); 
						
							//CHEECK IF IT IS THE SAME PERSON??? 
							//out.println("must alert: " + biderUsername);
							
							//add the alert to the table to be displayed to the user. 
							String addAlert = "insert into alert values("+auctionID+", '"+ biderUsername +"', '"+ "Your bid of "+ currentPrice +" has been outbid to "+bidPrice+"." +"');"; 
							PreparedStatement pinsert = con.prepareStatement(addAlert); 
							pinsert.executeUpdate(); 
							
						}
						//no one else has bid on the item and no one needs to be alerted. 
						else{
							
						}
						
						
					}
					else{
						out.println("Bid could not be placed.");
					}
				}
			}
			
			//return to account 
			%>
			<%--Return to home button--%>
			<form method="post" action="EndUserCustomer.jsp">
	  		<input type="submit" value="Return to Account" />
			</form>
			<%
			
			
		}
		catch(Exception e) {
			out.println("Bid could not be placed!");
		}
		
	}
		
	%>

</body>
</html>