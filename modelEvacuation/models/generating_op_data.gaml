/**
* Name: generatingopdata
* Based on the internal skeleton template. 
* Author: lsadou
* Tags: 
*/

model generatingopdata

global {
	//Shapefile of the buildings
	file building_shapefile <- file("../includes/Batiments/Buildings_Cannes_GAMA.shp");
	//Shapefile of the roads
	file road_shapefile <- file("../includes/Roads/Road_Cannes_GAMA.shp");
	//Shapefile of the population distribution and information
	file pop_shapefile <- file("../includes/Carreau/carreau_pop_V2.shp");
	//This map link a PopTile with all the Building present in this Tile
	map<PopTile,list<Building>> buildings_contained_in_tiles <- [];
	//This map link a position (centroid of a Building) to a list of individidual living at this position;
	map<point,list<Individual>> Individual_living_location <- [];
	
	init{
		create Building from:building_shapefile;
		create Road from:road_shapefile;
		create PopTile from:pop_shapefile;
		
		ask PopTile{
			buildings_contained_in_tiles[self]<- Building where (centroid(each) overlaps self);
			float sum_area <- sum(Building collect (each.shape.area));
			loop b over:buildings_contained_in_tiles[self]{
				create Individual number: int(b.shape.area/sum_area*nb_inhabitants) returns: created_indiv;
				Individual_living_location[centroid(b)]<- created_indiv;
			}
		}
	}
	
}

species Building{
	
}
species Road{
	
}
species PopTile{
	float nb_inhabitants;
}
species Individual{
	int age;
	point home;
}

experiment generatingopdata type: gui {
	output {
	}
}
