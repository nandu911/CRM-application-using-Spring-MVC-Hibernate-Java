<%@ taglib uri = "http://java.sun.com/jsp/jstl/core"  prefix = "c"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Customer List</title>
<!-- link to css file -->
<link type="text/css" rel="stylesheet" 
	href="${pageContext.request.contextPath}/resources/css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
window.onload= function searchResult(){
	var tableRows= document.getElementById("myTable").rows.length;
	if( tableRows<=1){
		var para= document.getElementById("searchText");
		para.style.display = 'block';
		para.style.color='red';
	}else{
		document.getElementById("searchText").style.display = 'none';
	}
}
</script>

</head>
<body>
	
	<div id="wrapper">
		<div id="header">
			<h2 onclick="window.location.href='list'; return false;"> CRM - Customer Relationship Manager</h2>
		</div>
	</div>
	
	<div id="container">
		<div id="content">
			<!-- Adding new button : Add Customer -->
			<input type="button" value="Add Customer" 
				onclick="window.location.href='showFormForAdd'; return false;"
				class="add-button"
				/>
				<!-- Adding search bar -->
                <!-- Adding search bar -->
				<form:form action="search" method="POST">
                Search customer: <input type="text" id="searchBar" name="theSearchName" />
                
                <input type="submit" value="Search" class="add-button" />
            </form:form>
            <p id="searchAjax" ></p>
            <p id="searchText" >No records found with the given Name</p>
		<!-- add our html table here -->
		<table id="myTable">
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
				<th>Action</th>
			</tr>
			<!-- loop over and print our customers -->
			<c:forEach var="tempCustomer" items="${customers}">
				<!-- construct an update link with customer id -->
				<c:url var="updateLink" value="/customer/showFormForUpdate" >
					<c:param name="customerId" value="${tempCustomer.id}"/>
				</c:url>
				<!-- construct a delete link with customer id -->
				<c:url var="deleteLink" value="/customer/delete" >
					<c:param name="customerId" value="${tempCustomer.id}"/>
				</c:url>
			<tr>
				<td> ${tempCustomer.firstName} </td>
				<td> ${tempCustomer.lastName} </td>
				<td> ${tempCustomer.email} </td>
				<td>
					<!-- display update link -->
					<a href="${updateLink}"> Update </a>
					|
					<a href="${deleteLink}"
					  onclick="if(!(confirm('Are you sure you want to delete this customer ?'))) return false"	> Delete </a>
				</td>
			</tr>
			
			</c:forEach>
			
		</table>
		
		
		</div>
	
	
	</div>


<script type="text/javascript">
$(document).ready(function(){
			$("#searchBar").keyup(function(){
				$.ajax({
					type: "POST",
			        url: "${pageContext.request.contextPath}/customer/ajax",
			        data: $("#searchBar").val(),	
			        contentType: "application/text",
			        dataType: "text",
			       
			        success: function(response) {
			               	var text=response;
			            	$("#searchAjax").html(text); 	
			        }
			        
			    });	
				
				});
			$("#searchBar").blur(function(){
				$("#searchAjax").hide();
			});
			$("#searchBar").focus(function(){
				$("#searchAjax").show();
			});
			
});
</script>
<script type="text/javascript">
window.onload = function(){
	// Define addresses, define varible for the markers, define marker counter
	var addrs = ['219 4th Ave N Seattle Wa 98109','200 2nd Avenue North Seattle Wa 98109','325 5th Ave N Seattle Wa 98109'];
	var markers = [];
	var marker_num = 0;
	// Process each address and get it's lat long
	var geocoder = new google.maps.Geocoder();
	var center = new google.maps.LatLngBounds();
	for(k=0;k<addrs.length;k++){
		var addr = addrs[k];
		geocoder.geocode({'address':addr},function(res,stat){
			if(stat==google.maps.GeocoderStatus.OK){
				// add the point to the LatLngBounds to get center point, add point to markers
				center.extend(res[0].geometry.location);
				markers[marker_num]=res[0].geometry.location;
				marker_num++;
				// actually display the map and markers, this is only done the last time
				if(k==addrs.length){
					// actually display the map
					var map = new google.maps.Map(document.getElementById("the_map"),{
						'center': center.getCenter(),
						'zoom': 14,
						'streetViewControl': false,
					    'mapTypeId': google.maps.MapTypeId.ROADMAP, // Also try TERRAIN!
					    'noClear':true,
					});
					// go through the markers and display them
					for(p=0;p<markers.length;p++){
						var mark = markers[p];
						new google.maps.Marker({
							'icon':'mapmarker.png',
							//'animation':google.maps.Animation.DROP, // This lags my computer somethin feirce
							'title':addrs[p],
							'map': map,
							'position': mark,
							})
					}
					// zoom map so all points can be seen
					map.fitBounds(center)
					// Styleize the map, doing this with the initial map options never seems to work
					map.setOptions({styles:[
						{
							featureType:"all",
							elementType:"labels",
							stylers:[
								{visibility:"off"},
							]
						},
						{
							featureType:"all",
							elementType:"all",
							stylers:[
								{saturation:-100}
							]
						},
						{
							featureType:"road",
							elementType:"all",
							stylers:[
								{hue:'#FF5500'},
								{saturation:75},
								{lightness:0}
							]
						},
						{
							featureType:"transit",
							elementType:"all",
							stylers:[
								{hue:'#FF5500'},
								{saturation:75},
								{lightness:0}
							]
						},
						{
							featureType:"landscape.man_made",
							elementType:"administrative",
							stylers:[
								{hue:'#FF5500'},
								{saturation:25},
								{lightness:0}
							]
						},
						{
							featureType:"water",
							elementType:"geometry",
							stylers:[
								{visibility:"off"},
								{saturation:-100}
							]
						},
						{
							featureType: "poi",
							stylers: [
								{ lightness: 70 }
							]
						},
						]});
				}
			}else{
				console.log('can\'t find address');
			}
		});
	}
}

</script>
</body>
</html>