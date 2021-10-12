/**
* Name: parameters
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model parameters

global{
	float step <- 1 #mn;
	
	font default <- font("Helvetica", 24, #bold);
	rgb text_color <- #white;
	rgb background <- world.color.darker.darker;
	
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/Buildings_Cannes_GAMA.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/Road_Cannes_GAMA.shp");
	
	
}

