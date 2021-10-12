/**
* Name: AlertChainMember
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model AlertChainMember

/* Insert your model definition here */

import "MAIN.gaml"

species AlertChainMember{
	
	string name;
	int delay;
	date receiving_alert_date;
	date sending_authorization_date;
	AlertChainMember member_to_alert;
	bool has_to_start_alert<-false;
	bool transmitted_alert<-false;
	
	action receiving_alert{
		if(has_to_start_alert){
			ask Siren{
				do alert;
			}
		}else{
			receiving_alert_date<-current_date;
			sending_authorization_date<-receiving_alert_date+delay;
			write ""+name+" received alert at:"+receiving_alert_date;
			write ""+name+" will send alert at:"+sending_authorization_date;
		}
		
	}
	
	reflex sending_authorization when: sending_authorization_date!=nil and sending_authorization_date<=current_date and not transmitted_alert{
		write ""+name+" sent the alert at:"+current_date;
		ask member_to_alert{
			do receiving_alert;
		}
		transmitted_alert <- true;
	}
	
	aspect default{
		draw name at:location+point(-10,-100) color:#black;
		draw square(150) color:#black;
		if transmitted_alert{
			draw line([self,member_to_alert]) end_arrow:100 color:#black width: 5;
		}
	}
	
}