<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Your Account</title>
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
		Statement stmt2 = con.createStatement();
		
		String username = session.getAttribute("usern").toString();
		%>
		Your Username: <% out.println(username); 
		%>
		
		<br> </br> 
		List an item:
		<%--Info for the Auction--%>
		<form method="get" action="auctionItem.jsp">
		<td> Bid Increment </td><td><input type ="text" name="bidIncrement"></td> 
		<td> Price Reserve </td><td><input type ="text" name="reserve"></td>
		<td> Expire date(YYYY-MM-DD) </td><td><input type ="date" name="date"></td>
		<td> Expire time(HH:MM)</td><td><input type ="time" name="time"></td> <br> </br> 
	
		<%--Info for the Item--%>	
	
		
	
		<td> Item Name </td><td><input type ="text" name="name"></td>
		<td> Category </td><td><input type ="text" name="category"></td>
		<td> Description </td><td><input type ="text" name="description"></td> <br> </br> 
		
		<input type="submit" value="Create a New Auction">
		</form>
		
		<%
				//update all auto bids and set alerts
										try {
									
									Statement stmt3 = con.createStatement();
									//get all auctions
									String AuctionsQuery = "SELECT auctionID, currentPrice, highestBidder FROM auction WHERE auctionID NOT IN (SELECT auctionID FROM winner);";
									ResultSet AllAuctions = stmt3.executeQuery(AuctionsQuery);
									
									//for each auction, find the highest auto bid and see if it applies
									while (AllAuctions.next()) {
										
										int auctionid = AllAuctions.getInt("auctionID");
										float currentPrice = AllAuctions.getFloat("currentPrice");
										
										Statement stmt4 = con.createStatement();
										//get all autobids for this auction
										String autobidQuery = "SELECT username, bidLimit, bidIncrement FROM auto_bid WHERE auctionID = " + auctionid + " ORDER BY bidLimit DESC;";
										ResultSet autobids = stmt4.executeQuery(autobidQuery);
										
										//if there are autobids
										if (autobids.next()) {
											
											String highestBidder = AllAuctions.getString("highestBidder"); //current highest bidder in auction 
											if (highestBidder == null) highestBidder = "";
											
											String highestAutoBidder = autobids.getString("username"); //highest autobidder
											float bidLimit = autobids.getFloat("bidLimit");
											float bidIncrement = autobids.getFloat("bidIncrement");
											
											boolean changed = false;
											if (autobids.next()) { //if there is another autobidder
												String secondHighestAutoBidder = autobids.getString("username"); //second highest autobidder
												float bidLimit2 = autobids.getFloat("bidLimit");
												float bidIncrement2 = autobids.getFloat("BidIncrement");
												
												if (bidLimit2 > currentPrice) { //if second highest autobidder is greater than current bidder, then it is the current highest bidder
													
													changed = true;
													currentPrice = bidLimit2;
													highestBidder = secondHighestAutoBidder;
												}
											}

											
											//if bid limit is greater than current price + bid increment
											if (bidLimit >= currentPrice + bidIncrement) {

												if (highestAutoBidder.compareTo(highestBidder) != 0) { //if the highest auto bidder is different than the highest bidder

													float newPrice = currentPrice + bidIncrement;
													//change to new price and highest bidder
													String updateAuction = "UPDATE auction SET highestBidder = '" + highestAutoBidder
															+ "', currentPrice = " + newPrice + " WHERE auctionID =" + auctionid;
													Statement updateStmt = con.createStatement();
													updateStmt.executeUpdate(updateAuction);

													//now alert previous bidder that they were outbid as long as highest bidder is not null
													if (highestBidder.compareTo("") != 0) {
														String message = "Your bid of " + currentPrice + " has been outbid to "
																+ newPrice + ".";
														String setAlert = "INSERT INTO alert VALUES(" + auctionid + ", '"
																+ highestBidder + "', '" + message + "');";
														PreparedStatement insert = con.prepareStatement(setAlert);
														insert.executeUpdate();
													}
												}
											} else if (changed = true) { //since highest autobidder cannot make bid, second highest autobidder becomes highest bidder
												

												
												//highestbidder and current price are actually second highest autobidder and its respective price
												String updateAuction = "UPDATE auction SET highestBidder = '" + highestBidder
														+ "', currentPrice = " + currentPrice + " WHERE auctionID =" + auctionid;
												Statement updateStmt = con.createStatement();
												updateStmt.executeUpdate(updateAuction);
												
												//potentially send alert
												String message = "Your automatic bid of " + bidLimit + " cannot surpass current bid of " + currentPrice + ".";
												String alertCheck = "SELECT auctionID, username, message FROM alert WHERE auctionID = " + auctionid + " AND username = '" + highestAutoBidder + "' AND message = '" + message + "'";
												Statement alertStmt = con.createStatement();
												ResultSet alerts = alertStmt.executeQuery(alertCheck);
												
												if (!alerts.next()) {
													String setAlert = "INSERT INTO alert VALUES(" + auctionid + ", '"
															+ highestAutoBidder + "', '" + message + "');";
													PreparedStatement insert = con.prepareStatement(setAlert);
													insert.executeUpdate();
												}
											}
										}
									}

								} catch (Exception e) {
									e.printStackTrace();
								}

								//update the auctions before displaying.
								//will select all of the expired auctions that has not had a winner chosen. 
								try {
									String expiredAuctionsQuery = "select a.auctionID, a.currentPrice, a.reserve, a.highestBidder, c.username from auction a, creates c where a.auctionID not in (select auctionID from winner) and closingDate <= curdate() and closingTime < curtime() and a.auctionID = c.auctionID group by auctionID;";
									ResultSet expiredAuctions = stmt.executeQuery(expiredAuctionsQuery);

									while (expiredAuctions.next()) {
										int currentPrice = expiredAuctions.getInt("a.currentPrice");
										int reserve = expiredAuctions.getInt("a.reserve");
										//check if no one bid on the item or if the currentPrice never met the reserve. If so there is no winner
										if (expiredAuctions.getString("a.highestBidder") == null || currentPrice < reserve) {
											//add to winner with empty null value as the winner. 
											String insertNoWinner = "insert into winner values( "
													+ expiredAuctions.getInt("a.auctionID") + ", null);";
											stmt2.executeUpdate(insertNoWinner);
											//send out an alert to the seller that the bid did not sell
											//there were no bidders. 
											if (expiredAuctions.getString("a.highestBidder") == null) {
												String noWinnerAlert = "insert into alert values ( "
														+ expiredAuctions.getInt("a.auctionID") + ", '"
														+ expiredAuctions.getString("c.username")
														+ "', 'Your auction ended and no one bid on it.')";
												stmt2.executeUpdate(noWinnerAlert);
											}
											//reserve not met. 
											else {
												String noWinnerAlert = "insert into alert values ( "
														+ expiredAuctions.getInt("a.auctionID") + ", '"
														+ expiredAuctions.getString("c.username")
														+ "', 'Your auction ended and did not meet its reserve of $"
														+ expiredAuctions.getFloat("reserve") + "')";
												stmt2.executeUpdate(noWinnerAlert);
											}
										}

										//someone has bid and the reserve is met therefore declare the winner and alert them they have won.
										else {

											//insert the person as the winner 
											String insertWinner = "insert into winner values( "
													+ expiredAuctions.getInt("a.auctionID") + ", '"
													+ expiredAuctions.getString("a.highestBidder") + "' )";
											stmt2.executeUpdate(insertWinner);

											//alert the winner they wont the action. 
											String winnerAlert = "insert into alert values( "
													+ expiredAuctions.getInt("a.auctionID") + ", '"
													+ expiredAuctions.getString("a.highestBidder")
													+ "', 'You have won the auction at the price of $" + currentPrice + "' )";
											stmt2.executeUpdate(winnerAlert);
											//alert the seller their auction has sold
											String sellerAlert = "insert into alert values( "
													+ expiredAuctions.getInt("a.auctionID") + ", '"
													+ expiredAuctions.getString("c.username")
													+ "', 'Your item met the reserve and sold for a price of $" + currentPrice
													+ "' )";
											stmt2.executeUpdate(sellerAlert);
										}

									}
								} catch (Exception e) {
									out.println(e);
								}
				%> 
		
		<br> </br> 
		Bid on the current auctions from other users:<br> </br>
		
		<% 
		
		//query the table 
		String getAuctions = "SELECT a.auctionID, a.closingDate, a.currentPrice, a.bidIncrement, a.closingTime, a.highestBidder, c.username, i.name, i.description from auction a, creates c, item i where closingDate >= CURDATE() and i.itemID = a.auctionID and a.auctionID = c.auctionID group by a.auctionID"; 
		ResultSet auctions = stmt.executeQuery(getAuctions); 
		
		%> 
		<table> 
		<tr> 
		<th>Auction ID | </th>
		<th>Name | </th>
		<th>Description |</th>
		<th>Current Price | </th>	
		<th>Minimum Increment |</th>	
		<th>Expiration Date | </th>
		<th>Expiration Time |</th>
		<th>Seller |</th>
		<th>Highest Bidder</th>
		</tr>		
		<% 
	
		
		while(auctions.next()){
			
			
			//Check if the obtained auctions are today, if so ignore if the time is expired. 
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			if(auctions.getDate("closingDate").toString().compareTo( format.format(new Date())) == 0 || auctions.getString("username").equals(username)) {
				
				String t1 = auctions.getTime("closingTime").toString();
				LocalTime currentTime = LocalTime.now();
				String t2 = currentTime.getHour() + ":" + currentTime.getMinute() + ":" + currentTime.getSecond(); 
				//out.print(t1 + " : " + t2);
					
				
				//If so then the auction is no longer active, do nothing 
				if(t1.compareTo(t2) < 0 || auctions.getString("username").equals(username)) {
					
					
				}
				
				//otherwise output normally
				else{
					%> 
					<tr>
					
						<td><%=auctions.getInt("auctionID")%>
						<td><%=auctions.getString("name")%>
						<td><%=auctions.getString("description")%>
						<td><%=auctions.getFloat("currentPrice")%>
						<td><%=auctions.getFloat("bidIncrement")%>
						<td><%=auctions.getDate("closingDate")%>
						<td><%=auctions.getTime("closingTime")%>
						<td><%=auctions.getString("c.username")%>
						<%
						
						if(auctions.getString("highestBidder") == null) {
							%>  	<td><%="Auction has no bids."%>  <%
						}
						else{
							if(auctions.getString("highestBidder").equals(username)) {
								%>  	<td><%="You are currently the highest bidder."%>  <%
							}
							else{
								%>  	<td><%=auctions.getString("highestBidder")%>  <%
							}
						}
						
						%>
						
						
					</tr>
					
					<% 
					
				}
			}
			
		
			
			//no issues and output normally
			else{
				
				%> 
				<tr>
				
						<td><%=auctions.getInt("auctionID")%>
						<td><%=auctions.getString("name")%>
						<td><%=auctions.getString("description")%>
						<td><%=auctions.getFloat("currentPrice")%>
						<td><%=auctions.getFloat("bidIncrement")%>
						<td><%=auctions.getDate("closingDate")%>
						<td><%=auctions.getTime("closingTime")%>
						<td><%=auctions.getString("c.username")%>
						<%
						
						if(auctions.getString("highestBidder") == null) {
							%>  	<td><%="Auction has no bids."%>  <%
						}
						else{
							if(auctions.getString("highestBidder").equals(username)) {
								%>  	<td><%="You are currently the highest bidder."%>  <%
							}
							else{
								%>  	<td><%=auctions.getString("highestBidder")%>  <%
							}
						}
						
						%>
				
				</tr>
				
				<% 
				
				
				
				
			}
		
		
		}
	
		%>
		</table>
		<br> </br> 
		<form method="get" action="manualBid.jsp">
		<td> Auction ID </td><td><input type ="text" name="auctionID"></td>
		<td> Bid Price </td><td><input type ="text" name="bidPrice"></td>
		<input type="submit" value="Bid on Item">
		</form>
		
		<br>
		<form method = "get" action = "AutoBidAdded.jsp">
		<td>Auction ID</td><td><input type = "text" name = "auc_id"></td>
		<td>Bid Upper Limit</td><td><input type = "text" name = "bid_limit"></td>
		<td>Bid Increment</td><td><input type = "text" name = "bid_inc"></td>
		<input type = "submit" value = "Set Automatic Bid">
		</form>

		 
		<%--Refresh--%>
		<br> </br> 
		<form  method="post" action="EndUserCustomer.jsp">
		Your Alerts:   
  		<input  type="submit" value="Reload" />
  	
		</form>
		
		<table> 
		<tr> 
		<th>AuctionID | </th>
		<th>Alert</th>
		</tr>	
		
		<% 	
		
			//get the alerts 
			String alertQuery = "select auctionID, message from alert where username = '" + username + "'"; 
			ResultSet alerts = stmt.executeQuery(alertQuery);
			while(alerts.next()) {
				
				%> 
				<tr>
				
						<td><%=alerts.getInt("auctionID")%>
						<td><%=alerts.getString("message") %>
				
				</tr>
				
				<% 
				
			}
		
		%>
		</table>

		<br>
		<form  method="post" action="UserQuestions.jsp">
		Need Help?   
  		<input  type="submit" value="Visit Customer Service" />
		</form>
		
		<br><br>
		
		<%--Log Out button--%>
		<form method="post" action="logOut.jsp">
  		<input type="submit" value="Log Out and Return Home" />
		</form>
		<% 
	
	}
	%>
	

</body>
</html>