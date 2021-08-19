Each file in this folder is a spawn point that could be chosen at random

Here's an example:

sample.json

{
	"author": "Perfectly Normal Beast",
	"description": "sample json",

	"modded_parkour": "none",
	
	"position_x": 0,
	"position_y": 0,
	"position_z": 0,
	
	"yaw": 0
}


The modded_parkour property can have one of three values
	"none"		This point can be safely exited without any mods installed (also don't need the thruster boots)
	"light"		It will take a little modded effort to get to the ground (mods like: wall hang, grappling hook)
	"heavy"		This is basically on top of a skyscraper or in a hole that will need full flight abilities to get out of


If you want a file to be ignored, just end it in an extension other than .json (like sample.json.txt)
(be sure that windows is set to show filename extensions - I doubt linux users have to deal with poor decisions like that)