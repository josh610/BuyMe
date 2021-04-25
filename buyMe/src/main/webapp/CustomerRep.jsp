<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Representative</title>
</head>
<body>
	<%
	if(session.getAttribute("usern") == null) {
		out.print("No Account Found.");
	}
	
	else{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		%>
		<h1>Answer Questions</h1>
		<table>
			<tr>
				<th
				style="width:300px;font:16px/26px Georgia, Garamond, Serif;">
				Question</th>
				<th
				style="width:100px;font:16px/26px Georgia, Garamond, Serif;">
				Answer</th>
			</tr>
		</table>
			
		<div
		style="height:150px;width:400px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String questionQuery =
				"SELECT question, qID FROM question " +
				"WHERE answer IS NULL;";
			ResultSet questions = stmt.executeQuery(questionQuery);
			%>
		
			<table>
			<%
			while(questions.next()){
				%>
				<tr>
					<th
					style="height:40px;width:300px;border:1px solid #ccc;overflow:auto;">
						<%= questions.getString("question") %>
					</th>
					<th>
						<form method="post" action="newAnswer.jsp">
							<input type="text" name="answer">
							<input type="hidden" name="qid" value=<%=questions.getString("qID")%>>
							<input type="submit" value="Submit">
						</form>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Couldn't load questions.");
		}
		%>
		</div>
		<br><br>
		
		
		
		<h1>Edit Users</h1>
		<table>
			<tr>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Username</th>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Password</th>
			</tr>
		</table>
			
		<div
		style="height:120px;width:500px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String usersQuery =
				"SELECT * FROM account " +
				"WHERE type='user' " + 
				"AND NOT username IS NULL;";
			ResultSet users = stmt.executeQuery(usersQuery);
			%>
		
			<table>
			<%
			while(users.next()){
				%>
				<tr>
					<th
					style="height:30px;width:150px;border:1px solid #ccc;">
						<table>
						<tr>
							<%=users.getString("username")%>
						</tr>
						</table>
					</th>
					<th
					style="height:30px;width:150px;border:1px solid #ccc;">
						<table>
						<tr>
							<%=users.getString("password")%>
						</tr>
						<tr>
							<th>
								<%--Edit password--%>
								<form method="post" action="editDelete.jsp">
									<input type="text" name="newData" value="Enter new password">
									<input type="hidden" name="oldData" value=
										<%=users.getString("username") + "'"%>>
									<input type="hidden" name="action" value=
										"UPDATE account SET password='">
									<input type="hidden" name="condition" value=
										"' WHERE username='">
								</form>
							</th>
						</tr>
						</table>
					</th>
					<th>
						<%--Delete user--%>
						<form method="post" action="editDelete.jsp">
							<input type="submit" value="Remove User">
							<input type="hidden" name="newData" value="">
							<input type="hidden" name="oldData" value=
										<%=users.getString("username") + "'"%>>
							<input type="hidden" name="action" value=
								"DELETE FROM account">
							<input type="hidden" name="condition" value=
								" WHERE username='">
						</form>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Couldn't load users.");
		}
		%>
		</div>
		<br><br>
		
		
		
		<h1>Remove Bids and Auctions</h1>
		<table>
			<tr>
				<th
				style="width:250px;font:16px/26px Georgia, Garamond, Serif;">
				Auction ID</th>
				<th
				style="width:250px;font:16px/26px Georgia, Garamond, Serif;">
				Most Recent Bid</th>
			</tr>
		</table>
			
		<div
		style="height:100px;width:500px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String auctionQuery =
				"SELECT auctionID aid FROM auction " +
				"WHERE (closingDate=curdate() AND closingTime > curtime()) " +
				"OR closingDate > curdate()";
			//out.print(auctionQuery);
			ResultSet auctions = stmt.executeQuery(auctionQuery);
			%>
		
			<table>
			<%
			while(auctions.next()){
				%>
				<tr>
					<th
					style="width:250px;border:1px solid #ccc;overflow:auto;">
						<table>
						
							<tr>
								<%=auctions.getString("aid")%>
							</tr>
							<tr>
								<th>
									<%--Delete auction--%>
									<form method="post" action="editDelete.jsp">
										<input type="submit" value="Remove Auction">
										<input type="hidden" name="newData" value="">
										<input type="hidden" name="oldData" value="">
										<input type="hidden" name="action" value=
											"<%=
											"DELETE FROM creates WHERE " +
											"auctionID=" + auctions.getString("aid") + ";" +
											
											"DELETE FROM manual_bid WHERE " +
											"auctionID=" + auctions.getString("aid") + ";" +
											
											"DELETE FROM sells WHERE " +
											"auctionID=" + auctions.getString("aid") + ";" +
											
											"DELETE FROM auction WHERE " +
											"auctionID=" + auctions.getString("aid")
											%>">
										<input type="hidden" name="condition" value="">
									</form>
								</th>
							</tr>
						</table>
					</th>
					<th
					style="width:250px;border:1px solid #ccc;overflow:auto;">
						<table>
						
							<tr>
								<%
								Statement s = con.createStatement();
								String bidQuery =
									"SELECT b.username user, b.bidPrice p FROM auction a, manual_bid b " +
									"WHERE a.auctionID='" + auctions.getString("aid") +
									"' AND (a.auctionID=b.auctionID OR a.auctionID IS NULL)";
								ResultSet highestBid = s.executeQuery(bidQuery);
								%>
								<%
								if(highestBid.next()){
									out.print(highestBid.getString("user") + " - $" + highestBid.getString("p"));
									%>
							</tr>
							<tr>
								<th>
									<%--Delete bid--%>
									<form method="post" action="editDelete.jsp">
										<input type="submit" value="Remove Bid">
										<input type="hidden" name="newData" value="">
										<input type="hidden" name="oldData" value="">
										<input type="hidden" name="action" value="
											<%=
											"DELETE FROM manual_bid " +
											"WHERE auctionID=" + auctions.getString("aid") +
											" AND bidID=" +
												"(SELECT x.id FROM" +
													"(SELECT MAX(t.bidID) id FROM manual_bid t) " +
												"x);" +
													
											"UPDATE auction a SET a.highestBidder=(" +
												"SELECT b.username FROM manual_bid b " +
												"WHERE b.bidID=" +
													"(SELECT x.id FROM" +
														"(SELECT MAX(t.bidID) id FROM manual_bid t) " +
													"x) " +
												"AND b.auctionID='" + auctions.getString("aid") +
												"') " +
											"WHERE a.auctionID='" + auctions.getString("aid") + "';" +
											
											"UPDATE auction a SET a.currentPrice=" +
											"(a.currentPrice - " + highestBid.getString("p") + ") " +
											"WHERE a.auctionID=" + auctions.getString("aid")
											%>">
										<input type="hidden" name="condition" value="">
									</form>
								</th>
							</tr>
							<%
							}
							else{
								out.print("No bids yet");
							}
							%>
						</table>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Couldn't load auctions.");
		}
		%>
		</div>
		<%
		
		db.closeConnection(con);
	}
	%>
	
	<br><br>
	<%--back button--%>
	<form method="post" action="logOut.jsp">
		<input type="submit" value="Log Out" />
	</form>
</body>
</html>