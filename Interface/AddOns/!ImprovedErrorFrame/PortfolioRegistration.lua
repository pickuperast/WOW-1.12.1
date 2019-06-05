-- <= == == == == == == == == == == == == =>
-- => Option Registration
-- <= == == == == == == == == == == == == =>

if (not ImprovedErrorFrame) then
	ImprovedErrorFrame = {}
end

local Portfolio = LibStub and LibStub("Portfolio", true)
if not Portfolio then return end

local optionTable = {
	id = "ImprovedErrorFrame",
	addon = "!ImprovedErrorFrame",
	subText = IEF_OPTION_HELP;
	options = {
		{
			id = "IEFBlink",
			text = IEF_BLINK_TEXT,
			tooltipText = IEF_BLINK_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "1",
			callback = function(value)
							ImprovedErrorSettings.blinkNotification = value == "1";
							ImprovedErrorFrame.changeBlink();
						end;
		},
		{
			id = "IEFCount",
			text = IEF_COUNT_TEXT,
			tooltipText = IEF_COUNT_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "1",
			callback = function(value)
							ImprovedErrorSettings.displayCount = value == "1";
							ImprovedErrorFrame.changeCount();
						end;
		},
		{
			id = "IEFAlways",
			text = IEF_ALWAYS_TEXT,
			tooltipText = IEF_ALWAYS_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "0",
			callback = function(value)
							ImprovedErrorSettings.alwaysShow = value == "1";
							ImprovedErrorFrame.changeAlways();
						end;
		},
		{
			id = "IEFSound",
			text = IEF_SOUND_TEXT,
			tooltipText = IEF_SOUND_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "1",
			callback = 	function(value)
							ImprovedErrorSettings.gagNoise = value ~= "1";
						end;
		},
		{
			id = "IEFEmpty",
			text = IEF_EMPTY_TEXT,
			tooltipText = IEF_EMPTY_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "0",
			callback = function(value)
							ImprovedErrorSettings.emptyButton = value == "1";
							ImprovedErrorFrame.changeEmpty();
						end;
		},
		{
			id = "IEFStack",
			text = IEF_STACK_TEXT,
			tooltipText = IEF_STACK_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "0",
			callback = function(value)
							ImprovedErrorSettings.stackTraceCapture = value == "1";
						end;
		},
		{
			id = "IEFDebug",
			text = IEF_DEBUG_TEXT,
			tooltipText = IEF_DEBUG_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "0",
			callback = function(value)
							ImprovedErrorSettings.XMLDebug = ImprovedErrorFrame.convertVar(value == "1");
							SetCVar("XMLDebug", ImprovedErrorSettings.XMLDebug);
						end;
		},
		{
			id = "IEFDebugCapture",
			text = IEF_DEBUGCAPTURE_TEXT,
			tooltipText = IEF_DEBUGCAPTURE_HELP,
			type = CONTROLTYPE_CHECKBOX,
			defaultValue = "0",
			callback = function(value)
							ImprovedErrorSettings.debugCapture = value == "1";
						end;
		},
	},
	savedVarTable = "ImprovedErrorSettings",
}

Portfolio.RegisterOptionSet(optionTable)
