/**
* Name: Siren
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model TsunamiAtTheCroisette

/* Insert your model definition here */

import "MAIN.gaml"
import "Individual.gaml"
import "parameters.gaml"
import "AlertVector.gaml"

species Siren parent: AlertVector{
	file img <- image_file("../includes/siren.png");
	
	action alert{
		ask Individual where (each.location distance_to self < radius_siren_buffer){
			do getAlert;
		}
	}
	
	aspect default{
		draw circle(radius_siren_buffer) empty:true border:#green width:10;
		draw square(100) color:#green;
	}
}

