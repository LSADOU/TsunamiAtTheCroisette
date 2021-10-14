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
import "Siren.gaml"
import "AlertChainMember.gaml"
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
		area_to_evacuate <- first(to_evacuate_shapefile);
		safe_area <- first(safe_area_shapefile);
		loop times: 10 {
			safe_spots << any_location_in(safe_area);
		}
		//Initialization of the building using the shapefile of buildings
		create Building from: building_shapefile {
			if not ((self overlaps area_to_evacuate) or (self overlaps safe_area)) {
				do die;
			} else {
				if string(get("name")) contains "plage" {
					beaches << self;
				}else if string(get("name")) contains "mer"{
					write string(get("name"));
					seas << self;
				}
			}
		}
		
		//Initialization of the road using the shapefile of roads
		create Road from: road_shapefile {
			if not ((shape overlaps area_to_evacuate) or (self overlaps safe_area)) {
				do die;
			}
		}
		road_network <- as_edge_graph(Road);
		
		//Initialization of the individuals using initial activities distribution
		loop act over: init_activity_distrib.keys{
			create Individual number: init_activity_distrib[act] {
				activity <- act;
				switch activity{
					match "driving"{location <- any_location_in(one_of(Road));}
					match "doing thing"{location <- any_location_in(one_of(Building));}
					match "walking"{location <- any_location_in(one_of(Road));}
					match "sunbathing"{location <- any_location_in(one_of(beaches));}
					match "swimming"{location <- any_location_in(one_of(seas));}
				}
				float pick <- rnd(1.0);
				loop b over:behaviour_distrib.keys{
					if behaviour_distrib[b] >= pick{
						behaviour <- b;
						break;
					}
				}
			}
		}
		
		
		point start <- point(500, -500);
		loop alert_chain_member_name over: alert_chain_delay_member.keys {
			create AlertChainMember {
				location <- start;
				name <- alert_chain_member_name;
				delay <- alert_chain_delay_member[alert_chain_member_name];
			}
			start <- start + point(1000, 0);
		}
		AlertChainMember temp;
		loop cm over: reverse(AlertChainMember) {
			if (cm = last(AlertChainMember)) {
				temp <- cm;
			} else {
				ask cm {
					member_to_alert <- temp;
				}
				temp <- cm;
			}
		}

		ask last(AlertChainMember) {
			has_to_start_alert <- true;
		}

		ask first(AlertChainMember) {
			do receiving_alert;
		}

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
			/*graphics "evacuation area limit" {
				draw area_to_evacuate empty: true color: #red border: #red width: 10;
			}*/
			graphics "safe spots" {
				loop sp over:safe_spots{
					draw square(100) at: sp color: #red;
				}
				
			}

			species Individual aspect: default;
			species AlertChainMember aspect: default;
			//list safe_spots aspect: default;
			overlay position: {5, 4} size: {200 #px, 140 #px} rounded: true transparency: 0.2 {
				draw ("" + current_date.day + "/" + current_date.month + "/" + current_date.year) font: default at: {15 #px, 10 #px} anchor: #top_left color: text_color;
				string dispclock <- current_date.hour < 10 ? "0" + current_date.hour : "" + current_date.hour;
				dispclock <- current_date.minute < 10 ? dispclock + "h0" + current_date.minute : dispclock + "h" + current_date.minute;
				draw dispclock font: default at: {15 #px, 60 #px} anchor: #top_left color: text_color;
				draw "step: " + step + " sec" font: default at: {15 #px, 105 #px} anchor: #top_left color: text_color;
			}

		}

	}

}

