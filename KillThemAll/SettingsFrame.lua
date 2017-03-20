
local g_standAloneSettingsFrame = CreateFrame("Frame", "KTA_StandAloneSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local g_interfaceSettingsFrame = {};

g_interfaceEventsListener = {};



local function CreateLabel(panel, name)
	local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(name);
	return label;
end
local function CreateCheck(panel, key, width, height)
	local chkOpt = CreateFrame("CheckButton", "KTA_" .. key, panel, "OptionsCheckButtonTemplate");
	chkOpt:SetWidth(width);
	chkOpt:SetHeight(height);
	return chkOpt;
end
local function CreateSlider(panel, name, width, height, min, max, step)
	local sliderOpt = CreateFrame("Slider", "KTA_" .. name, panel, "OptionsSliderTemplate");
	sliderOpt:SetWidth(width);
	sliderOpt:SetHeight(height);
	sliderOpt:SetMinMaxValues(min, max);
	sliderOpt:SetValueStep(step);
	_G[sliderOpt:GetName() .. "Low"]:SetText(min);
	_G[sliderOpt:GetName() .. "High"]:SetText(max);
	_G[sliderOpt:GetName() .. "Text"]:SetText(name);
	return sliderOpt;
end

local function CreateEditBox(panel, name, width, height, onlyNumeric, onEnterPressedCallback)
	local editBox = CreateFrame("EditBox", "KTA_" .. name, panel, "InputBoxTemplate");
	editBox:SetAutoFocus(false);
	editBox:SetWidth(width);
	editBox:SetHeight(height);
	editBox:SetNumeric(onlyNumeric);

	editBox:SetScript("OnEnterPressed", function()
		onEnterPressedCallback();

		editBox:ClearFocus();
		editBox:HighlightText(100,100);	-- Force highlight removal
	end);
	editBox:SetScript("OnEscapePressed", function()
		editBox:ClearFocus();
		editBox:HighlightText(100,100);	-- Force highlight removal
	end);

	return editBox;
end

function MakeFrameMovable(panel, motion)

	panel:EnableMouse(true)
	panel:SetMovable(true)
	panel:SetClampedToScreen(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", panel.StartMoving)
	panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
end


local InitDelayEditBoxes = nil;	-- Forward declaration

function InitSettingsFrames()

------------------- STAND ALONE FRAME -------------------

	g_standAloneSettingsFrame:SetSize(600, 500);
	g_standAloneSettingsFrame:SetPoint("CENTER", UIParent, "CENTER");

	MakeFrameMovable(g_standAloneSettingsFrame);
	g_standAloneSettingsFrame:Hide();



------------------- INTERFACE SETTINGS PANEL -------------------
	g_interfaceSettingsFrame.panel = CreateFrame( "Frame", "KTA_InterfaceSettingsFrame", UIParent);
	g_interfaceSettingsFrame.panel.name = "KillThemAll Settings";


	-- DEACTIVATED
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Deactivated");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 80, -48);
	g_interfaceSettingsFrame.chkDeact = CreateCheck(g_interfaceSettingsFrame.panel, "chkDeactivate", 20, 20);
	g_interfaceSettingsFrame.chkDeact:SetPoint("TOPLEFT", 60, -45);
	g_interfaceSettingsFrame.chkDeact:SetChecked(g_ktaOptions.deactivated);

	g_interfaceSettingsFrame.chkDeact:SetScript("OnClick", function()
		g_ktaOptions.deactivated = not g_ktaOptions.deactivated;
	end);


	-- MUTE DURING COMBAT
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Mute during Combat");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 80, -68);
	g_interfaceSettingsFrame.chkCombat = CreateCheck(g_interfaceSettingsFrame.panel, "chkMuteInCombat", 20, 20);
	g_interfaceSettingsFrame.chkCombat:SetPoint("TOPLEFT", 60, -65);
	g_interfaceSettingsFrame.chkCombat:SetChecked(g_ktaOptions.muteDuringCombat);

	g_interfaceSettingsFrame.chkCombat:SetScript("OnClick", function()
		g_ktaOptions.muteDuringCombat = not g_ktaOptions.muteDuringCombat;
	end);


	-- MIN MAX DELAY
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Min delay");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 60, -98);
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Max delay");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 140, -98);
	InitDelayEditBoxes();


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_interfaceSettingsFrame.panel);
end


-- MIN MAX DELAY FUNCTION
InitDelayEditBoxes = 	function()

	-- MIN DELAY
	local onMinDelayEnterPressedCallback = function()

		local newValue = g_interfaceSettingsFrame.boxMin:GetNumber();
		if newValue == g_ktaOptions.minDelay then
			return;

		elseif not SetDelay(newValue, g_ktaOptions.maxDelay) then
			g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
		end
	end

	g_interfaceSettingsFrame.boxMin = CreateEditBox(g_interfaceSettingsFrame.panel, "boxMinDelay", 60, 20, true, onMinDelayEnterPressedCallback);
	g_interfaceSettingsFrame.boxMin:SetPoint("TOPLEFT", 65, -115);

	g_interfaceSettingsFrame.boxMin:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
	end);

	g_interfaceSettingsFrame.boxMin:SetScript("OnEditFocusLost", function()
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
	end);

		-- MAX DELAY
	local onMaxDelayEnterPressedCallback = function()

		local newValue = g_interfaceSettingsFrame.boxMax:GetNumber();
		if newValue == g_ktaOptions.maxDelay then
			return;

		elseif not SetDelay(g_ktaOptions.minDelay, newValue) then
			g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
		end
	end

	g_interfaceSettingsFrame.boxMax = CreateEditBox(g_interfaceSettingsFrame.panel, "boxMaxDelay", 60, 20, true, onMaxDelayEnterPressedCallback);
	g_interfaceSettingsFrame.boxMax:SetPoint("TOPLEFT", 145, -115);

	g_interfaceSettingsFrame.boxMax:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);

	g_interfaceSettingsFrame.boxMax:SetScript("OnEditFocusLost", function()
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);


	AddListenerEvent(g_interfaceEventsListener, "OnDelayChanged", function()
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);
end
