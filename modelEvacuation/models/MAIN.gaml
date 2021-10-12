/**
* Name: mod
* Based on the internal empty template. 
* Author: loics
* Tags: 
*/
model TsunamiAtTheCroisette

import "Road.gaml"
import "Building.gaml"
import "Individual.gaml"

global {
	font default <- font("Helvetica", 24, #bold);
	rgb text_color <- #white;
	rgb background <- world.color.darker.darker;
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/Buildings_Cannes_GAMA.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/Road_Cannes_GAMA.shp");
	//Shape of the environment
	geometry shape <- envelope(road_shapefile);
	//Step value
	float step <- 1 #mn;
	//Graph of the road network
	graph road_network;

	init {
		//Initialization of the building using the shapefile of buildings
		create Building from: building_shapefile;
		//Initialization of the road using the shapefile of roads
		write "start cleaning roads";
		create Road from: clean_network(road_shapefile.contents, 30.0, true, true);
		road_network <- as_edge_graph(Road);
		write "end cleaning roads";
		create Individual number: 1000 {
			speed <- 10 #km / #h;
			location <- any_location_in(one_of(Road));
			dest <- any_location_in(one_of(Road));
			//do pickRandomDestination;
		}

	}

}

experiment xp type: gui {
	output {
		layout #split toolbars: false consoles: true navigator:false parameters: false;
		
		display map type: opengl draw_env:false{
			species Road aspect: default;
			species Building aspect: default;
			species Individual aspect: default;
			
			overlay position: {5, 4} size: {200 #px, 140 #px} rounded: true transparency:0.2{
				draw ("Day " + int((current_date - starting_date) / #day)) font: default at: {15 #px, 10 #px} anchor: #top_left color: text_color;
				string dispclock <- current_date.hour < 10 ? "0" + current_date.hour : "" + current_date.hour;
				dispclock <- current_date.minute < 10 ? dispclock + "h0" + current_date.minute : dispclock + "h" + current_date.minute;
				draw dispclock font: default at: {15 #px, 60 #px} anchor: #top_left color: text_color;
				draw "step: " + step + " sec" font: default at: {15 #px, 105 #px} anchor: #top_left color: text_color;
			}
		}

	}

}

