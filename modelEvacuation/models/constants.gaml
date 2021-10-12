/**
* Name: constants
* Based on the internal empty template. 
* Author: lsadou
* Tags: 
*/


model constants

/* Insert your model definition here */
global{
	string act_studying <- "studying";
	string act_working <- "working";
	string act_home <- "staying at home";
	string act_eating <- "eating";
	string act_leisure <- "leisure";
	list<string> activity_list <- [act_studying,act_working,act_home,act_eating,act_leisure];
	
	
}
	