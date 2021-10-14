/**
* Name: parameters
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/
model parameters

global {
	float step <- 10 #s;
	date starting_date <- date(2021, 10, 12, 0, 0, 0);
	font default <- font("Helvetica", 24, #bold);
	rgb text_color <- #white;
	rgb background <- world.color.darker.darker;

	//Shapefile of the siren location
	file siren_shapefile <- file("../includes/Sirene/Sirene_Cannes_GAMA.shp");
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/Batiments/Buildings_Cannes_GAMAV2.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/new_road_locations.shp");
	//Shapefile of the roads
	file to_evacuate_shapefile <- file("../includes/Zone_evacuation/evacuation_area_GAMA.shp");
	//Shapefile of the safe Area 
	file safe_area_shapefile <- file("../includes/Safe_area/Safe_area.shp");
	geometry shape <- envelope(road_shapefile);
	
	list<int> id_beaches <- [35000,35001,35002];
	
	float radius_siren_buffer <- 1.5#km;
	
	float delay_get_info <- 3#mn;
	
	map<string, float> alert_chain_delay_member <- ["CENALT"::8#mn,"COGIC"::10#mn,/*"Préfecture"::10#mn,*/"Commune"::10#mn];
	map<string,int> init_activity_distrib <- ["driving"::500,"doing thing"::500,"walking"::500,"sunbathing"::1500,"swimming"::250];
	map<string,float> behaviour_distrib <- ["local"::0.4,"amused"::0.1, "tourist"::0.4, "altruist"::0.1];
}

