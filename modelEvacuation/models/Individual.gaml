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
	bool is_evacuating;
	bool is_alerted;
	bool is_safe;
	bool has_cellphone;
	point dest;
	point evacuation_point;
	string behaviour <- "local" among: ["local","amused", "altruist"];
	date received_alert;
	rgb color;

	action getAlert {
		if not is_alerted{
			dest <- closest_to(Road,self).shape.points closest_to self;
		}
		is_alerted <- true;
		received_alert <- current_date;
	}

	action getInformation { 
		is_evacuating <- true;
		evacuation_point <- closest_to(safe_spots, self);
	}
	
	reflex panic when: is_alerted and not is_evacuating{
		switch behaviour{
			match "local"{
				if current_date < received_alert + delay_get_info {
					do getInformation;
				}
			}
			match "amused"{
				do wander amplitude:100#m speed:1#m/#s;
			}
			match "altuist"{
				do getInformation;
			}
		}
	}
	
	reflex evacuate when: is_alerted and is_evacuating and not is_safe{
		if dest!=nil{
			if distance_to(dest,self)<2{
				dest <- nil;
				evacuation_point <- closest_to(safe_spots,self);
			}else{
				do goto target:dest speed:3#m/#s;
			}
		}else{
			if distance_to(evacuation_point,self)<2{
				evacuation_point <- nil;
				is_safe <- true;
			}else{
				do goto target: evacuation_point speed:3#m/#s on: road_network;
			}
		}
		if behaviour = "altruist"{
			ask Individual where (distance_to(self.location, each.location) < 10 #m) {
				do getInformation;	
				if distance_to(self, myself) <5#m{
					do getAlert;
				}
			}
		}		
	}
	
	aspect default {
		color <- is_alerted ? #red : color;
		color <- is_alerted and is_evacuating? #orange : color;
		//color <- evacuation_point != nil ? #white : #black;
		draw circle(10) color: color;
	}

}