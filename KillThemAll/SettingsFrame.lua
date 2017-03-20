
local g_standAloneSettingsFrame = CreateFrame("Frame", "KTA_StandAloneSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local g_interfaceSettingsFrame = {};



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

function MakeFrameMovable(panel, motion)

	panel:EnableMouse(true)
	panel:SetMovable(true)
	panel:SetClampedToScreen(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", panel.StartMoving)
	panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
end


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


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_interfaceSettingsFrame.panel);
end
