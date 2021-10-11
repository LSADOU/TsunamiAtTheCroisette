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
	//Shapefile of the buildings
	//file building_shapefile <- file("../includes/Cannes_OSM_buildings.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/Cannes_OSM_roads.shp");
	//Shape of the environment
	geometry shape <- envelope(road_shapefile);
	//Step value
	float step <- 1 #mn;
	//Graph of the road network
	graph road_network;
	
	init{
		//Initialization of the building using the shapefile of buildings
		//create Building from: building_shapefile;
		//Initialization of the road using the shapefile of roads
		create Road from: road_shapefile;
		road_network <- as_edge_graph(Road);
		create Individual number:1000 {
			location <- any_location_in(one_of(Road));	
			destination <- any_location_in(one_of(Road));
		}
	}
}




experiment xp type:gui {
	
	output {
		display map {
			species Road aspect:default;
			species Building aspect:default;
			species Individual aspect:default;
		}
	}
}

