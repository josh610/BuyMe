<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Report</title>
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
		<h1>Best Selling Items</h1>
		<div
		style="height:100px;width:400px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String bsQuery =
				"SELECT i.name name, i.category cat FROM item i, auction a, sells s " + 
				"WHERE i.itemID=s.itemID AND s.auctionID=a.auctionID " +
				"AND (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate < curdate() " +
				"GROUP BY i.name, i.category " +
				"ORDER BY SUM(a.currentPrice) DESC " +
				"LIMIT 5;";
			//out.print(bsQuery);
			ResultSet bestSellers = stmt.executeQuery(bsQuery);
			%>
		
			<table>
			<%
			while(bestSellers.next()){
				%>
				<tr>
				<td>
					<%=bestSellers.getString("name")%>
					<%="(" + bestSellers.getString("cat") + ")"%>
				</td>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Problem loading.");
		}
		%>
		</div>
		<br><br>
		
		
		
		<h1>Best Selling Users</h1>
		<div
		style="height:100px;width:400px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String usersQuery =
				"SELECT acc.username name FROM account acc, auction auc, creates c " + 
				"WHERE acc.username=c.username AND c.auctionID=auc.auctionID " +
				"AND (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate > curdate() " +
				"AND acc.type='user' " +
				"GROUP BY acc.username " +
				"ORDER BY SUM(auc.currentPrice) DESC " +
				"LIMIT 5;";
			//out.print(usersQuery);
			ResultSet bestUsers = stmt.executeQuery(usersQuery);
			%>
		
			<table>
			<%
			while(bestUsers.next()){
				%>
				<tr>
				<td>
					<%=bestUsers.getString("name")%>
				</td>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Problem loading.");
		}
		%>
		</div>
		<br><br>
		
		<h1>Earnings Per Item</h1>
		<table>
			<tr>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Item</th>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Earnings</th>
			</tr>
		</table>
			
		<div
		style="height:100px;width:300px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String itemEarningsQuery =
				"SELECT i.name name, SUM(a.currentPrice) earnings FROM item i, auction a, sells s " + 
				"WHERE i.itemID=s.itemID AND s.auctionID=a.auctionID " +
				"AND (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate < curdate() " +
				"GROUP BY i.name " +
				"ORDER BY SUM(a.currentPrice) DESC;";
			//out.print(itemEarningsQuery);
			ResultSet itemEarnings = stmt.executeQuery(itemEarningsQuery);
			%>
		
			<table>
			<%
			while(itemEarnings.next()){
				%>
				<tr>
					<th
					style="width:150px;">
					<%=itemEarnings.getString("name")%>
					</th>
					<th
					style="width:150px;">
					<%=itemEarnings.getString("earnings")%>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Problem loading.");
		}
		%>
		</div>
		<br><br>
		
		<h1>Earnings Per Category</h1>
		<table>
			<tr>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Item</th>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Earnings</th>
			</tr>
		</table>
			
		<div
		style="height:100px;width:300px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String catEarningsQuery =
				"SELECT i.category cat, SUM(a.currentPrice) earnings FROM item i, auction a, sells s " + 
				"WHERE i.itemID=s.itemID AND s.auctionID=a.auctionID " +
				"AND (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate < curdate() " +
				"GROUP BY i.category " +
				"ORDER BY SUM(a.currentPrice) DESC;";
			//out.print(catEarningsQuery);
			ResultSet catEarnings = stmt.executeQuery(catEarningsQuery);
			%>
		
			<table>
			<%
			while(catEarnings.next()){
				%>
				<tr>
					<th
					style="width:150px;">
					<%=catEarnings.getString("cat")%>
					</th>
					<th
					style="width:150px;">
					<%=catEarnings.getString("earnings")%>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Problem loading.");
		}
		%>
		</div>
		<br><br>
		
		<h1>Earnings Per User</h1>
		<table>
			<tr>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Item</th>
				<th
				style="width:150px;font:16px/26px Georgia, Garamond, Serif;">
				Earnings</th>
			</tr>
		</table>
			
		<div
		style="height:100px;width:300px;border:1px solid #ccc;overflow:auto;">
		<%
		try{
			Statement stmt = con.createStatement();
			String userEarningsQuery =
				"SELECT acc.username name, SUM(auc.currentPrice) earnings " +
				"FROM auction auc, creates c, account acc " + 
				"WHERE c.auctionID=auc.auctionID AND c.username=acc.username " +
				"AND (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate < curdate() " +
				"GROUP BY acc.username " +
				"ORDER BY SUM(auc.currentPrice) DESC;";
			//out.print(userEarningsQuery);
			ResultSet userEarnings = stmt.executeQuery(userEarningsQuery);
			%>
		
			<table>
			<%
			while(userEarnings.next()){
				%>
				<tr>
					<th
					style="width:150px;">
					<%=userEarnings.getString("name")%>
					</th>
					<th
					style="width:150px;">
					<%=userEarnings.getString("earnings")%>
					</th>
				</tr>
			<%
			}
			%>
			</table>
			<%
		}
		catch(Exception e){
			out.print("Problem loading.");
		}
		%>
		</div>
		<br><br>
		

		<%
		try{
			Statement stmt = con.createStatement();
			String earningsQuery =
				"SELECT SUM(currentPrice) sum FROM auction " + 
				"WHERE (closingDate=curdate() AND closingTime < curtime()) " +
				"OR closingDate < curdate();";
			//out.print(earningsQuery);
			ResultSet earnings = stmt.executeQuery(earningsQuery);
			earnings.next();
			%><h1>Total Earnings: $<%=earnings.getString("sum")%></h1><%
		}
		catch(Exception e){
			out.print("Problem loading total earnings.");
		}
		
		db.closeConnection(con);
	}
	%>
	
	<br><br>
	<%--back button--%>
	<form method="post" action="Admin.jsp">
		<input type="submit" value="Back" />
	</form>
</body>
</html>