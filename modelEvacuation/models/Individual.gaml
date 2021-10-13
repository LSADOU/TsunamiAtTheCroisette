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
	point evacuation_point;
	string behaviour <- "panicked" among: ["amused", "panicked", "has_knowledge"];

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

	action getAlert {
		is_alerted <- true;
	}

	action getInformation {
	// Trigger the boolean which enable an agent to leave 
		has_knowledge_about_evacuation <- true;
	}

	reflex reactAlert when: is_alerted {
		switch behaviour {
			match "has_knowledge" {
			//comportement si has knowledge, agent will try to warn other agent and go outside hazard area
				ask Individual where (distance_to(self.location, each.location) < 7 #m) {
					behaviour <- "has_knowledge";
					is_alerted <- true;
				}

				ask Individual where (distance_to(self.location, each.location) < 20 #m) {
					is_alerted <- true;
				}

			}

			match "amused" {
				ask Individual {
				// describe how the agent will behave when in the amused state
				// the agent will do absolutely nothing but wander around at a stated speed
					speed <- 1 #m / #s;
					do wander;
				}

			}

			match "panicked" {
				ask Individual { //do nothing
				}

			}

		}

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

	reflex goOutsideEvacuationArea when: has_knowledge_about_evacuation {
	// Reflex which allows an agent to move to a safe spot located in the safe area.
	// The agent needs to have information / be aware of those safe areas.
	// The agent will use roads
		do goto target: one_of(safe_spots) on: road_network;
	}

	aspect default {
		rgb c <- #cyan;
		c <- is_alerted ? #red : c;
		c <- is_evacuating ? #purple : c;
		draw circle(10) color: c;
	}

}