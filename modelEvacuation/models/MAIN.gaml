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
import "AlertVector.gaml"
import "Siren.gaml"
import "CellBroadcast.gaml"
import "Safe_Area.gaml"

global {

//Graph of the road network
	graph road_network;
	geometry area_to_evacuate;
	geometry safe_area;
	list<Building> beaches;
	list<Building> seas;
	list<point> safe_spots;
	int safe_people;

	init {
		safe_people <- 0;
		create Siren from: siren_shapefile;
		create CellBroadcast;
		area_to_evacuate <- first(to_evacuate_shapefile);
		safe_area <- first(safe_area_shapefile);
		loop times: 10 {
			safe_spots << any_location_in(safe_area);
		}
		//Initialization of the building using the shapefile of buildings
		write "Creating building...";
		create Building from: building_shapefile {
			if not ((self overlaps area_to_evacuate) or (self overlaps safe_area)) {
				do die;
			} else {
				if string(get("type")) contains "plage" {
					beaches << self;
				}else if string(get("name")) = "mer"{
					write string(get("name"));
					seas << self;
				}
			}
		}
		write ""+length(beaches)+" beaches and "+ length(seas)+" swimming areas imported";
		//Initialization of the road using the shapefile of roads
		write "Creating roads...";
		create Road from: road_shapefile {
			if not ((shape overlaps area_to_evacuate) or (self overlaps safe_area)) {
				do die;
			}
		}
		road_network <- as_edge_graph(Road);
		
		//Initialization of the individuals using initial activities distribution
		write "Creating individuals...";
		
	}
	
	reflex send_alert when:current_date>alert_date{
		ask Siren{
			do alert;
		}
		ask CellBroadcast{
			do alert;
		}
		
	}
	
	reflex tsunami_is_here when: current_date>tsunami_date{
		int nb_dead_people <- 0;
		loop i over: Individual{
			nb_dead_people <- i overlaps area_to_evacuate?nb_dead_people+1:nb_dead_people;
		}
		write ""+ "****** END OF SIMULATION *******" color:#red;
		write ""+nb_dead_people+" are dead" color:#red;
		do pause;
		
	}

}

experiment START_TSUNAMI type: gui {
	output {
		layout #split toolbars: false consoles: true navigator: false parameters: false;
		display map type: opengl draw_env: false {
			image file("../includes/satellite.png");
			species Road aspect: default;
			species Building aspect: default;
			species Siren aspect: default;
			graphics "evacuation area limit" {
				draw area_to_evacuate empty: true color: #red border: #red width: 10;
			}
			graphics "safe spots" {
				loop sp over:safe_spots{
					draw square(100) at: sp color: #red;
				}
				
			}
			species Individual aspect: default;
			
			//list safe_spots aspect: default;
			overlay position: {5, 4} size: {200 #px, 340 #px} rounded: true transparency: 0.2 {
				draw ("" + current_date.day + "/" + current_date.month + "/" + current_date.year) font: default at: {15 #px, 10 #px} anchor: #top_left color: text_color;
				string dispclock <- current_date.hour < 10 ? "0" + current_date.hour : "" + current_date.hour;
				dispclock <- current_date.minute < 10 ? dispclock + "h0" + current_date.minute : dispclock + "h" + current_date.minute;
				draw dispclock font: default at: {15 #px, 60 #px} anchor: #top_left color: text_color;
				draw "step: " + step + " sec" font: default at: {15 #px, 105 #px} anchor: #top_left color: text_color;
			}

		}

	}

}

