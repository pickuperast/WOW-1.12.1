
StubbyConfig = {
	["addinfo"] = {
		["Auctioneer"] = "Auctioneer|Displays item info and analyzes auction data. Use \"/auctioneer scan\" at AH to collect auction data. [3.3.0.0808 (Platypus)] This AddOn is licenced under the GNU GPL, see GPL.txt for details.",
		["EnhTooltip"] = "EnhTooltip|Used to display enhanced tooltips under the original tooltip or in the original tooltip, contains hooking functions for almost all major in game item tooltips [3.3.0.0787] This AddOn is licenced under the GNU GPL, see GPL.txt for details.",
	},
	["boots"] = {
		["auctioneer"] = {
			["commandhandler"] = "\n		local function cmdHandler(msg)\n			local i,j, cmd, param = string.find(string.lower(msg), \"^([^ ]+) (.+)$\")\n			if (not cmd) then cmd = string.lower(msg) end\n			if (not cmd) then cmd = \"\" end\n			if (not param) then param = \"\" end\n			if (cmd == \"load\") then\n				if (param == \"\") then\n					Stubby.Print(\"Manually loading Auctioneer...\")\n					LoadAddOn(\"Auctioneer\")\n				elseif (param == \"auctionhouse\") then\n					Stubby.Print(\"Setting Auctioneer to load when this character visits the auction house\")\n					Stubby.SetConfig(\"Auctioneer\", \"LoadType\", param)\n				elseif (param == \"always\") then\n					Stubby.Print(\"Setting Auctioneer to always load for this character\")\n					Stubby.SetConfig(\"Auctioneer\", \"LoadType\", param)\n					LoadAddOn(\"Auctioneer\")\n				elseif (param == \"never\") then\n					Stubby.Print(\"Setting Auctioneer to never load automatically for this character (you may still load manually)\")\n					Stubby.SetConfig(\"Auctioneer\", \"LoadType\", param)\n				else\n					Stubby.Print(\"Your command was not understood\")\n				end\n			else\n				Stubby.Print(\"Auctioneer is currently not loaded.\")\n				Stubby.Print(\"  You may load it now by typing |cffffffff/auctioneer load|r\")\n				Stubby.Print(\"  You may also set your loading preferences for this character by using the following commands:\")\n				Stubby.Print(\"  |cffffffff/auctioneer load auctionhouse|r - Auctioneer will load when you visit the auction house\")\n				Stubby.Print(\"  |cffffffff/auctioneer load always|r - Auctioneer will always load for this character\")\n				Stubby.Print(\"  |cffffffff/auctioneer load never|r - Auctioneer will never load automatically for this character (you may still load it manually)\")\n			end\n		end\n		SLASH_AUCTIONEER1 = \"/auctioneer\"\n		SLASH_AUCTIONEER2 = \"/auction\"\n		SLASH_AUCTIONEER3 = \"/auc\"\n		SlashCmdList[\"AUCTIONEER\"] = cmdHandler\n	",
			["triggers"] = "\n		function Auctioneer_CheckLoad()\n			local loadType = Stubby.GetConfig(\"Auctioneer\", \"LoadType\")\n			if (loadType == \"auctionhouse\" or not loadType) then\n				LoadAddOn(\"Auctioneer\")\n			end\n		end\n		function Auctioneer_ShowNotLoaded()\n			BrowseNoResultsText:SetText(\"Auctioneer is not loaded. Type /auctioneer for more info.\");\n		end\n		local function onLoaded()\n			Stubby.UnregisterAddOnHook(\"Blizzard_AuctionUI\", \"Auctioneer\")\n			if (not IsAddOnLoaded(\"Auctioneer\")) then\n				Stubby.RegisterFunctionHook(\"AuctionFrame_Show\", 100, Auctioneer_ShowNotLoaded)\n			end\n		end\n		Stubby.RegisterFunctionHook(\"AuctionFrame_LoadUI\", 100, Auctioneer_CheckLoad)\n		Stubby.RegisterAddOnHook(\"Blizzard_AuctionUI\", \"Auctioneer\", onLoaded)\n		local loadType = Stubby.GetConfig(\"Auctioneer\", \"LoadType\")\n		if (loadType == \"always\") then\n			LoadAddOn(\"Auctioneer\")\n		else\n			Stubby.Print(\"Auctioneer is not loaded. Type /auctioneer for more info.\");\n		end\n	",
		},
	},
	["inspected"] = {
		["Auctioneer"] = true,
		["EnhTooltip"] = true,
	},
	["configs"] = {
		["auctioneer"] = {
			["easypewpew:loadtype"] = "always",
		},
	},
}
