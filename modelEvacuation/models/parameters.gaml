/**
* Name: parameters
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model parameters

global{

	float step <- 10 #s;
	
	date starting_date <- date(2021,10,12,0,0,0);
	
	font default <- font("Helvetica", 24, #bold);
	rgb text_color <- #white;
	rgb background <- world.color.darker.darker;
	
	//Shapefile of the siren location
	file siren_shapefile <- file("../includes/Sirene_Cannes_GAMA.shp");
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/Buildings_Cannes_GAMA.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/Road_Cannes_GAMA.shp");
	geometry shape <- envelope(road_shapefile);
	
	float radius_siren_buffer <- 1.5#km;
	
	map<string, float> alert_chain_delay_member <- ["CENALT"::8#mn,"COGIC"::10#mn,"Préfecture"::10#mn,"Commune"::10#mn];
}

