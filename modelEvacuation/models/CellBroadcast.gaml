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
			if has_cellphone{
				do getAlert;
				do getInformation;
			}
		}
	}
}