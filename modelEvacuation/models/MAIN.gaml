/**
* Name: mod
* Based on the internal empty template. 
* Author: kevinchapuis
* Tags: 
*/


model mod

global {
	
	init {
		loop times: 4 {
			point a_place <- any_location_in(world);
			geometry neighborhood <- (a_place buffer 10.0 ) inter world;
			create mushroom number: 20 {location <- any_location_in(neighborhood);}
		}
		create hunter number:10;
	}
	
	reflex end_sim when:empty(mushroom) {do pause;}
}

species mushroom {
	geometry shape <- circle(2.0);
	aspect default { draw shape color: #red; }
}

species hunter skills: [moving] {
	int time_since_last_found <- 99;
	
	reflex search {
		if time_since_last_found <= 20 { do wander amplitude: 180.0; }
		else {do wander amplitude: 20.0; }
		
		list<mushroom> mushrooms_at_loc <- mushroom overlapping self;
		
		if not(empty(mushrooms_at_loc)) {
			time_since_last_found <- 0;
			ask mushrooms_at_loc { do die; }
		} else {
			time_since_last_found <- time_since_last_found + 1;
		}
	}
	
	aspect default { draw triangle (3) rotate: heading + 90 color: #yellow;}
}

experiment xp type:gui {
	
	float max_turn_angle <- 20.0 parameter:true min: 1.0 max: 360.0;
	
	output {
		display map background: #black {
			species mushroom;
			species hunter;
		}
		display chart {
			chart "evolution of mushroom" type: series { data "nb of mushroom" value: length(mushroom) color: #red; }			
		} 
	}
}

