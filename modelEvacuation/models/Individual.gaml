/**
* Name: Individual
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/
model TsunamiAtTheCroisette

import "MAIN.gaml"
species Individual skills: [moving] {
	int age;
	bool is_safe;
	bool is_evacuating;
	bool is_alerted;
	bool has_car;
	bool has_knowledge_about_evacuation;
	bool has_cellphone;
	Building home;
	point dest;

	reflex stop when: dest != nil and (self distance_to dest) < 1 {
		dest <- nil;
	}

	reflex moving when: dest != nil {
		do goto target: dest on: road_network;
	}

	reflex randomDestination when: dest = nil {
		dest <- any_location_in(one_of(Road));
		//do pickRandomDestination;
	}

	action pickRandomDestination {
		point d <- any_location_in(one_of(Road));
		list<path> all_shortest_path <- paths_between(road_network, self.location::d, 1);
		if empty(all_shortest_path) {
			location <- d;
		} else {
			dest <- d;
		}

	}

	aspect default {
		draw circle(20) color: #purple;
	}

}