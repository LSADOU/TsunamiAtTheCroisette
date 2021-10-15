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
		ask nb_siren_down among Siren{do die;}
		create Siren number:new_siren from:new_siren_shapefile;
		create CellBroadcast number: nb_cellbroadcast;
		area_to_evacuate <- first(to_evacuate_shapefile);
		safe_area <- first(safe_area_shapefile);
		safe_spots <- safe_places_shapefile;
		//Initialization of the building using the shapefile of buildings
		write "Creating building...";
		create Building from: building_shapefile;
		create Building from: beach_shapefile returns: b;
		beaches <- b;
		create Building from: seas_shapefile returns: s;
		seas <- s;
		write ""+length(beaches)+" beaches and "+ length(seas)+" swimming areas imported";
		//Initialization of the road using the shapefile of roads
		write "Creating roads...";
		create Road from: road_shapefile;
		road_network <- as_edge_graph(Road);
		
		//Initialization of the individuals using initial activities distribution
		write "Creating individuals...";
		create Individual number: 5000{
			is_safe <- false;
			behaviour <- rnd_choice(behaviour_distrib);
			string place <- rnd_choice(place_distrib);
			switch place{
				match "beach"{
					activity <- place;
					self.color <- #yellow;
					location <- any_location_in(one_of(beaches));
					if flip(0.2){do getAlert;}
					if flip(0.1){do getInformation;}
					has_cellphone <- flip(0.6);
				}
				match "water"{
					activity <- place;
					self.color <- #blue;
					location <- any_location_in(one_of(seas));
					if flip(0.3){do getAlert;}
					if flip(0.1){do getInformation;}
					has_cellphone <- false;
				}
				match "building"{
					activity <- place;
					self.color <- #grey;
					location <- any_location_in(one_of(Building-seas-beaches));
					has_cellphone <- flip(0.9);
				}
				match "road"{
					activity <- place;
					self.color <- #cyan;
					location <- any_location_in(one_of(Road));
					has_cellphone <- flip(0.8);
				}
			}
		}
		
	}
	
	reflex send_alert when:current_date>alert_date{
		ask Siren{
			do alert;
		}
		ask CellBroadcast{
			do alert;
		}
	}
	
	reflex tsunami_is_here when: current_date>tsunami_date and not save_result_in_csv{
		int nb_dead_people <- 0;
		loop i over: Individual{
			nb_dead_people <- (i overlaps area_to_evacuate)or(seas one_matches(i overlaps each))?nb_dead_people+1:nb_dead_people;
		}
		write ""+ "****** END OF SIMULATION *******" color:#red;
		write ""+nb_dead_people+" are dead" color:#red;
		do pause;
	}
	
	reflex save_result when: current_date>=tsunami_date-1#sec and save_result_in_csv{
		int nb_dead_people <- 0;
		loop i over: Individual{
			nb_dead_people <- (i overlaps area_to_evacuate)or(seas one_matches(i overlaps each))?nb_dead_people+1:nb_dead_people;
		}
		string results <- ""+ int(self)+","+alert_chain_delay+","+nb_siren_down+","+nb_cellbroadcast+","+new_siren+","+nb_dead_people;
		save results to: "../outputs/explo.csv" type:text rewrite: false;
		write results;
	}

}

experiment explo type: batch  repeat: 10 until:current_date>tsunami_date{
	
	parameter save_result_in_csv var: save_result_in_csv <- true;
	parameter alert_chain_delay var: alert_chain_delay <- 10#mn among:[10#mn,15#mn,18#mn];
	parameter nb_siren_down var: nb_siren_down <- 0 among:[0,1];
	parameter nb_cellbroadcast var: nb_cellbroadcast <- 0 among:[0,1];
	parameter new_siren var: new_siren <- 0 among:[0,1];
	
	init{
		string header_csv <- "id_exp,alert_chain_delay,nb_siren_down,nb_cellbroadcast,new_siren,nb_dead_people";	
		save header_csv to: "../outputs/explo.csv" type:text rewrite: true;
		write "The file ../outputs/explo.csv has been erased to write new data" color:#green;
	}
}

experiment START_TSUNAMI type: gui {
	
	float minimum_cycle_duration <- 1.0;
	
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
			overlay position: {5, 4} size: {250 #px, 340 #px} rounded: true transparency: 0.2 {
				draw ("" + current_date.day + "/" + current_date.month + "/" + current_date.year) font: default at: {15 #px, 10 #px} anchor: #top_left color: text_color;
				string dispclock <- current_date.hour < 10 ? "0" + current_date.hour : "" + current_date.hour;
				dispclock <- current_date.minute < 10 ? dispclock + ":0" + current_date.minute : dispclock + ":" + current_date.minute;
				dispclock <- current_date.second < 10 ? dispclock + ":0" + current_date.second : dispclock + ":" + current_date.second;
				draw dispclock font: default at: {15 #px, 60 #px} anchor: #top_left color: text_color;
				
				string dispAlertTime <- alert_date.hour < 10 ? "0" + alert_date.hour : "" + alert_date.hour;
				dispAlertTime <- alert_date.minute < 10 ? dispAlertTime + ":0" + alert_date.minute : dispAlertTime + ":" + alert_date.minute;
				dispAlertTime <- alert_date.second < 10 ? dispAlertTime + ":0" + alert_date.second : dispAlertTime + ":" + alert_date.second;
				draw "Alert at: "+dispAlertTime font: default at: {15 #px, 110 #px} anchor: #top_left color: text_color;
				
				string dispTsunamiTime <- tsunami_date.hour < 10 ? "0" + tsunami_date.hour : "" + tsunami_date.hour;
				dispTsunamiTime <- tsunami_date.minute < 10 ? dispTsunamiTime + ":0" + tsunami_date.minute : dispTsunamiTime + ":" + tsunami_date.minute;
				dispTsunamiTime <- tsunami_date.second < 10 ? dispTsunamiTime + ":0" + tsunami_date.second : dispTsunamiTime + ":" + tsunami_date.second;
				draw "Tsunami at: "+dispTsunamiTime font: default at: {15 #px, 160 #px} anchor: #top_left color: text_color;
				
				draw "step: " + step + " sec" font: default at: {15 #px, 210 #px} anchor: #top_left color: text_color;
			}

		}

	}

}

