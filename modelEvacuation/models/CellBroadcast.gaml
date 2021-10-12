/**
* Name: CellBroadcast
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model TsunamiAtTheCroisette

/* Insert your model definition here */

import "MAIN.gaml"
import "Individual.gaml"

species CellBroadcast{
	
	action alert{
		ask Individual{
			do getAlert;
		}
	}
}