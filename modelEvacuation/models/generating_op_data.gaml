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
	geometry shape <- envelope(road_shapefile);
	
	string individual_shapefile_name <- "new_indiv_locations.shp";
	string road_shapefile_name <- "new_road_locations.shp";
	
	init{
		create Building from:building_shapefile{
			centro <- centroid(self);
		}
		write "start cleaning roads";
		create Road from: clean_network(road_shapefile.contents, 30.0, true, true);
		write "end cleaning roads";
		create PopTile from:pop_shapefile with:[nb_inhabitants::float(get("Ind"))];
		
		ask PopTile{
			buildings_contained_in_tiles[self]<- Building where (each.centro overlaps self);
			float sum_area <- sum(buildings_contained_in_tiles[self] collect (each.shape.area));
			loop b over:buildings_contained_in_tiles[self]{
				ask b{color <- myself.color;}
				create Individual number: int(b.shape.area/sum_area*nb_inhabitants) returns: created_indiv{
					home <- b.centro;
					location <- any_location_in(b);
				}
				Individual_living_location[b.centro]<- created_indiv;
			}
		}
		write "saving cleaned road";
		save Road to: "../includes/"+road_shapefile_name type: "shp";
		write "saving individuals";
		save Individual to: "../includes/"+individual_shapefile_name type: "shp";
		write "done";
	}
	
}

species Building{
	point centro;
	aspect default{
		draw shape color:first(PopTile where (buildings_contained_in_tiles[each] contains self)).color border:#black;
	}
}

species Road{
	bool one_way;
	int nb_way;
}

species PopTile{
	float nb_inhabitants;
	rgb color <- rnd_color(255);
	aspect default{
		draw shape color:color border:#black;
	}
}

species Individual{
	int age;
	point home;
	
	aspect default{
		draw circle(4) color:#black;
	}
}

experiment generatingopdata type: gui {
	output {
		display map type: opengl draw_env:true synchronized:true{
			species PopTile aspect:default;
			species Building aspect:default;
			species Individual aspect:default;
		}
	}
}
