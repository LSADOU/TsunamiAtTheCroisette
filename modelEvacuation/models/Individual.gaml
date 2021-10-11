/**
* Name: Individual
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model TsunamiAtTheCroisette

import "MAIN.gaml"

species Individual skills:[moving]{
	int age;
	bool is_safe;
	bool is_evacuating;
	bool is_alerted;
	bool has_car;
	bool has_knowledge_about_evacuation;
	bool has_cellphone;
	Building home;
	point destination;
	
	reflex stop when: (self distance_to destination) < 1 {
		destination <- nil;	
	}
	
	reflex moving when:destination!=nil{
		do goto target:destination;
		write sample(destination);
	}
	
	reflex randomDestination when:destination=nil{
		destination <- any_location_in(one_of(Road));
	}
	
	 
	aspect default{
		draw circle(20) color:#purple;
	}
}