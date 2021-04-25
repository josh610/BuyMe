<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

			
		<%--Return to home button--%>
		<form method="post" action="EndUserCustomer.jsp">
	  	<input type="submit" value="Return to Account" />
		</form> <div></div> 
<% 

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		//Create a SQL statement
		Statement stmt = con.createStatement();

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
		
		//get the info that was passed, then create a auction if valid input 
		try{
			float bidIncrement = Float.parseFloat( request.getParameter("bidIncrement"));  
			float reserve = Float.parseFloat( request.getParameter("reserve")); 
		 	LocalDate date = LocalDate.parse(request.getParameter("date"));
		 	LocalTime time = LocalTime.parse(request.getParameter("time"));
		 	
		 	//make sure the bidIncrement >= 1 and reserve >= 0 and that the auction ends in the future. 
		 	LocalDate currentDate = LocalDate.now(); 
		 	LocalTime currentTime = LocalTime.now(); 
		 	
		 	//being made before today
			if(date.compareTo(currentDate) < 0) {
				out.println("An auction cannot be created in the past, must end at least today.");
				return; 
			}
			
		 	//being made today at a past time
			if(date.compareTo(currentDate) == 0 && time.compareTo(currentTime) < 0) {
				out.println("An auction cannot be created in the past.");
				return; 
			}
		 			
			if(bidIncrement < 1) {
				out.println("Each bid must increment by at least $1.");
				return; 
			}
		 	
			if(reserve < 0) {
				out.println("A reserve cannot be negative."); 
				return; 
			}
		 	
			out.println("Your Auction has been made."); %> <div> </div><% 
			
		 	out.print("date: " + date); %> <div> </div><% 
			out.print("time: " + time); %> <div> </div><% 
			out.print("bid Increment: " + bidIncrement); %> <div> </div><% 
			out.print("reserve: " + reserve); %> <div> </div><% 
			String name = request.getParameter("name");
			String category = request.getParameter("category");
			String description = request.getParameter("description");
			out.print("name: " + name); %> <div> </div><% 
			out.print("category: " + category); %> <div> </div><% 
			out.print("description: " + description); %> <div> </div><% 
			%>Auction made on: <%= (new java.util.Date()).toLocaleString()%><div> </div> <% 
			
			//get the highest auction number and add 1 to create a new AuctionID.  
			String str = "SELECT max(auctionID) as f FROM auction"; 
			ResultSet result = stmt.executeQuery(str);
			result.next(); 
			int auctionNumber = result.getInt("f"); 
			auctionNumber++; 
			out.print("actionID: " + auctionNumber); %> <div> </div><% 
			
			//Do the same to get a unique Item ID
			String str2 = "SELECT max(itemID) as g FROM item"; 
			ResultSet result2 = stmt.executeQuery(str2);
			result2.next(); 
			int itemNumber = result2.getInt("g"); 
			itemNumber++; 
			out.print("itemID: " + itemNumber); %> <div> </div><% 
			
			//create the insert. Always insert at a price of 0. 
			String insertAuctionInfo = "INSERT INTO AUCTION VALUES( " + auctionNumber + ", '" + date + "', '" + time +"', " + bidIncrement + ", " + 0 +", " + reserve + " , NULL)" ; 
			//set the relationship between the auction and the user
			String insertAuctionCreatesRelation = "INSERT INTO CREATES VALUES(" + auctionNumber + ", '" + session.getAttribute("usern") + "')"; 
			//insert the item into the item table
			String insertItem = "INSERT INTO ITEM VALUES(" + itemNumber + ", '" + name + "', '" + category + "', '" + description + "')" ;
			//set the relationship between the auction and the item
			String insertAuctionSellsRelation = "INSERT INTO SELLS VALUES(" + itemNumber + ", " + auctionNumber + ")";  
			
			//execute the statements
			stmt.executeUpdate(insertAuctionInfo);
			stmt.executeUpdate(insertAuctionCreatesRelation);
			stmt.executeUpdate(insertItem);
			stmt.executeUpdate(insertAuctionSellsRelation);
			
		}
		catch(Exception e){
			out.print("The data for the action was either invalid or missing.");
	
		}
	}
	
	%>

</body>
</html>