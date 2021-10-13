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
	list<point> safe_spots;

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
		}

		create Siren from: siren_shapefile;
		safe_area <- first(safe_area_shapefile);
		loop times: 10 {
			safe_spots << any_location_in(safe_area);
		}

		area_to_evacuate <- first(to_evacuate_shapefile);
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

