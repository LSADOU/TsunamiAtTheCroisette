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
	bool has_knowledge_about_evacuation;
	bool has_cellphone;
	point dest;
	point evacuation_point;
	string activity <- "sunbathing" among:["driving","doing thing","walking","sunbathing","swimming"];
	string behaviour <- "local" among: ["local","amused", "tourist", "altruist"];

	action getAlert {
		if not is_alerted{
			dest <- any_location_in(closest_to(Road,self));
		}
		is_alerted <- true;
	}

	action getInformation { 
		has_knowledge_about_evacuation <- true;
		evacuation_point <- closest_to(safe_spots, self);
	}
	
	reflex activity when: not is_alerted{
		switch activity{
			match "driving"{
				if dest!=nil{
					if distance_to(dest,self)<2{
						dest <- nil;
					}else{
						do goto target:dest on:road_network speed:30#km/#h;
					}
				}else{
					dest <- any_location_in(safe_area+area_to_evacuate);
				}
			}
			match "doing thing"{
				//DO NOTHING ACTUALLY
			}
			match "walking"{
				if dest!=nil{
					if distance_to(dest,self)<2{
						dest <- nil;
					}else{
						do goto target:dest on:road_network speed:2#m/#s;
					}
				}else{
					dest <- any_location_in(safe_area+area_to_evacuate);
				}
			}
			match "sunbathing"{
				if dest!=nil{
					if distance_to(dest,self)<2{
						activity <- "swimming";
						dest <- nil;
					}else{
						do goto target:dest speed:1#m/#s;
					}
				}else{
					if flip(0.1){
						dest <- any_location_in(closest_to(seas,self));
					}
				}
			}
			match "swimming"{
				if dest!=nil{
					if distance_to(dest,self)<2{
						activity <- "sunbathing";
						dest <- nil;
					}else{
						do goto target:dest;
					}
				}else{
					if flip(0.1){
						dest <- any_location_in(closest_to(beaches,self));
					}else{
						do wander amplitude:5#m speed:1#m/#s;
					}
				}
			}
		}
	}
	
	reflex panic when: is_alerted and not has_knowledge_about_evacuation{
		switch behaviour{
			match "local"{
				
			}
			match "amused"{
				
			}
			match "tourist"{
				
			}
			match "full knowledge"{
				
			}
		}
	}
	
	reflex evacuate when: is_alerted and has_knowledge_about_evacuation {
		if dest!=nil{
			if distance_to(dest,self)<2{
				dest <- nil;
				evacuation_point <- closest_to(safe_spots,self);
			}else{
				do goto target:dest speed:3#m/#s;
			}
		}else{
			if activity= "driving"{
				do goto target:evacuation_point on:road_network speed:30#km/#h;
			}else{
				do goto target:evacuation_point on:road_network speed:3#m/#s;
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
		rgb c;
		switch activity{
			match "driving"{c <- #pink;}
			match "doing thing"{c <- #grey;}
			match "walking"{c <- #purple;}
			match "sunbathing"{c <- #yellow;}
			match "swimming"{c <- #blue;}
		}
		rgb c2;
		c2 <- is_alerted ? #red : c;
		c2 <- is_alerted and has_knowledge_about_evacuation? #magenta : c;
		draw circle(10) color: c border: c2;
	}

}