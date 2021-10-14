/**
* Name: parameters
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/
model parameters

global {
	float step <- 1 #s;
	date starting_date <- date(2021, 10, 12, 12, 14, 50);
	float alert_chain_delay <- 15#mn;
	date alert_date <- date(2021, 10, 12, 12, 0, 0) + alert_chain_delay;
	float tsunami_time <- 20#mn;
	date tsunami_date <- date(2021, 10, 12, 12, 0, 0)+tsunami_time;
	font default <- font("Helvetica", 24, #bold);
	rgb text_color <- #white;
	rgb background <- world.color.darker.darker;

	//Shapefile of the siren location
	file siren_shapefile <- file("../includes/Sirene/Sirene_Cannes_GAMA.shp");
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/BatimentsV4/BatimentsV4.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/new_road_locations.shp");
	//Shapefile of the roads
	file to_evacuate_shapefile <- file("../includes/Zone_evacuation/evacuation_area_GAMA.shp");
	//Shapefile of the safe Area 
	file safe_area_shapefile <- file("../includes/Safe_area/Safe_area.shp");
	//Shapefile of the beaches
	file beach_shapefile <- file("../includes/Plage/Plage_GAMA.shp");
	//Shapefile of the swimming area
	file seas_shapefile <- file("../includes/Mer/mer_GAMA.shp");
	//Shapefile of the safes refuges
	file safe_places_shapefile <- file("../includes/safe_refuge/Evacuation_refuge.shp");
	geometry shape <- envelope(road_shapefile);
	
	float radius_siren_buffer <- 1.5#km;
	float delay_get_info <- 4#mn;
	
	map<string, float> alert_chain_delay_member <- ["CENALT"::5#mn,"COGIC"::6#mn,/*"Préfecture"::10#mn,*/"Commune"::6#mn];
	map<string,float> behaviour_distrib <- ["local"::0.4,"amused"::0.1, "altruist"::0.1];
	map<string,float> place_distrib <- ["beach"::0.4,"water"::0.1, "building"::0.3,"road"::0.2];
	
}

