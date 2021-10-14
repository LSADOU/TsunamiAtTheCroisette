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
	bool has_cellphone;
	point dest;
	point evacuation_point;
	string behaviour <- "local" among: ["local","amused", "tourist", "altruist"];
	date received_alert;

	action getAlert {
		if not is_alerted{
			dest <- any_location_in(closest_to(Road,self));
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
	
	reflex evacuate when: is_alerted and is_evacuating {
		if dest!=nil{
			if distance_to(dest,self)<2{
				dest <- nil;
				evacuation_point <- closest_to(safe_spots,self);
			}else{
				do goto target:dest speed:3#m/#s;
			}
		}else{
			
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
		rgb c;
		c <- is_alerted ? #red : c;
		c <- is_alerted and is_evacuating? #magenta : c;
		draw circle(10) color: c;
	}

}