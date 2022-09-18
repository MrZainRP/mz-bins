## MZ-BINS - a progression based bin-dive function for QB-CORE based FiveM servers

_By Mr_Zain#4139_

## PREVIEW

[![mz-bins](https://i.imgur.com/tVtzHi9.png)](https://www.youtube.com/watch?v=UuNhdnj3rZc "mz-shrooms for FiveM by Mr_Zain#4139")

## Introduction 
- The ultimate, progression based bin-diving function where players are able to interact with bins found around the map to find useful things that the locals have thrown out.
- Some of the items are sellable directly at "Trash 'n Treasure", other items can be broken down or processed into materials for use in crafting and other items have a rare drop rare or a unique purpose. 
- This resource is self-contained in respect of dumpster props that can be interacted with (to which more can be easily added), a crafting location that can be configured in the same way that qb-target locations can be changed by changing the coordinates for the relevant polyzone or PED and a functioning shop - again, the location of which can eb easily changed by changing the qb-target export in the client.lua (be sure to also change the same details in the config.lua to ensure the shop blip location is correct).
- XP modifier via mz-skills applies for successful bin diving, more XP is awarded for successful crafting. 
- The benefit of leveling up is that the shop vendor pays higher for bin-dive sellable items. The config.lua explains the multiplier by reference to calling separate configurations. Changing the prices of items that the vendor will purchase will adjust the impact XP will have on the mz-bins progression. Server owners can tailor this to their economic needs. Further, in an RP-based server this can create a separate sub-economy whereby proficient bin divers can not only bin dive for items but might also seek to buy them from players for more than the vendor would pay a low XP player and profit off the margin - encouraging an RP interaction. 

## DEPENDENCIES

NOTE: You should have each of the dependencies other than qb-lock and mz-skills as part of a conventional qb-core install.

**[mz-skills](https://github.com/MrZainRP/mz-skills)** - to track skill progress. All credit to Kings#4220 for the original qb-skillz now **[B1-skillz](https://github.com/Burn-One-Studios/B1-skillz)**

**[progressbar](https://github.com/qbcore-framework/progressbar)**

**[qb-target](https://github.com/qbcore-framework/qb-target)**

**[qb-skillbar](https://github.com/qbcore-framework/qb-skillbar)**

**[qb-lock](https://github.com/Nathan-FiveM/qb-lock)**

OPTIONAL: (Configured to work with okokNotify as well as base qb-core notifications).

## Installation Instruction

## A. MZ-SKILLS

1. If you do not already have mz-skills running in your server, ensure that mz-skills forms part of your running scripts. 

2. If this is your first time running mz-skills, be sure to run the "skills.sql" sql file and open the database. (This will add a data table to the existing "players" database which will hold the skill value for "Scraping" as well as other jobs)

### B. QB-CORE/SHARED/ITEMS.LUA

3. Add the following items to qb-core/shared/items.lua (NOTE: IF YOU ARE RUNNING MZ-SCRAP THERE IS NO NEED TO ADD THE FIRST 3 ITEMS WHICH WILL ALREADY BE IN YOUR ITEMS.LUA):

```lua
	['screwdriver'] 				 = {['name'] = 'screwdriver', 			  		['label'] = 'Screwdriver', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'screwdriver.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A flathead screwdriver. I mean sure the handle is a bit worn but this thing probably works.'},
	['wd40'] 				 	 	 = {['name'] = 'wd40', 			    			['label'] = 'WD-40', 					['weight'] = 250, 		['type'] = 'item', 		['image'] = 'wd40.png', 				['unique'] = true, 		['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A chemical compound with multiple purposes, including the removal of corrosion.'},
	["pistol1"] 					 = {["name"] = "pistol1", 						["label"] = "Pistol Grip", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "pistol1.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "The barrel of a Walther P-99 Pistol."},
	
	['blankusb'] 				 	 = {['name'] = 'blankusb', 			  	  		['label'] = 'Blank USB', 				['weight'] = 0, 		['type'] = 'item', 		['image'] = 'blankusb.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Non-descript USB, wonder if there is anything on it?'},
	['bottlecaps'] 				 	 = {['name'] = 'bottlecaps', 			  	  	['label'] = 'Bottle caps', 				['weight'] = 300, 		['type'] = 'item', 		['image'] = 'bottlecaps.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Some plastic caps for what looks like a variety of soda bottles.'},
	['brokencup'] 				 	 = {['name'] = 'brokencup', 			  	  	['label'] = 'Broken Cup', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'brokencup.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A nice piece of glasswear... or it would have been if the handle wasn\'t cracked.'},
	['sodacan'] 				 	 = {['name'] = 'sodacan', 			  	  		['label'] = 'Soda Can', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'crushedcan.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'What was once a refreshing beverage is now just a tin can...'},
	['emptybottle'] 				 = {['name'] = 'emptybottle', 					['label'] = 'Empty bottle', 			['weight'] = 300, 		['type'] = 'item', 		['image'] = 'emptybottle.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Makes a satisfying crunch when you press on it, not a single drop left...'},
	['bulletcasing'] 				 = {['name'] = 'bulletcasing', 					['label'] = 'Bullet casing', 			['weight'] = 400, 		['type'] = 'item', 		['image'] = 'bullet_casing.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A used bullet shell... Still in tact though... Interesting.'},
	['actiontoy'] 					 = {['name'] = 'actiontoy', 					['label'] = 'Action figure', 			['weight'] = 350, 		['type'] = 'item', 		['image'] = 'actionfigure.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'An old toy, looks kinda neat - might be valuable?'},
	['ace'] 				 		 = {['name'] = 'ace', 							['label'] = 'Ace of Spades', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ace.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'An old trading card - kinda crusty...'},
	['wallet'] 					 	 = {['name'] = 'wallet', 						['label'] = 'Old Wallet', 				['weight'] = 350, 		['type'] = 'item', 		['image'] = 'wallet.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Feels like leather... Clearly been used and abused though...'},
	["sunglasses"] 			 	     = {["name"] = "sunglasses", 					["label"] = "Sunnies", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "sunglasses.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A pair of what look like expenssive UV spec, designer shades - except they say Gouccy?"},
	["crayons"] 			 	     = {["name"] = "crayons", 						["label"] = "Crayons", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "crayons.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A small set of pastel coloured crayons, used to decorate illustrations. Stay within the lines!"},
	["teddy"] 			 	     	 = {["name"] = "teddy", 						["label"] = "Teddy bear", 				["weight"] = 150, 		["type"] = "item", 		["image"] = "teddy.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A teddy bear that appears to be unwanted, still has the tag on it and everything."},
	["fabric"] 			 	     	 = {["name"] = "fabric", 						["label"] = "Fabric scrap", 			["weight"] = 150, 		["type"] = "item", 		["image"] = "fabric.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Looks like someone has thrown an old strip of fabric, must have bought too much?"},
```
## INVENTORY IMAGES

4. Add the images which appear in the "images" folder to your inventory images folder. If using lj-inventory, add the images to: lj-inventory/html/images/

## RESTART SERVER - ENJOY

5. If you attend to all of the above steps you will need to restart the server in order for the new added items to be recognised by qb-core. Starting the mz-scrap resource without doing this will cause errors. 

6. Please restart your server ensuring that mz-bins is ensured/starts after qb-core starts (ideally it should just form part of your [qb] folder). 

Happy bin diving!
