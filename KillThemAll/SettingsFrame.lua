
local g_standAloneSettingsFrame = CreateFrame("Frame", "KTA_StandAloneSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local g_interfaceSettingsFrame = {};



local function createLabel(panel, name)
	local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(name);
	return label;
end
local function createCheck(panel, key, wth, hgt)
	local chkOpt = CreateFrame("CheckButton", "KTA_" .. key, panel, "OptionsCheckButtonTemplate");
	chkOpt:SetWidth(wth);
	chkOpt:SetHeight(hgt);
	return chkOpt;
end
local function createSlider(panel, name, x, y, min, max, step)
	local sliderOpt = CreateFrame("Slider", "KTA_" .. name, panel, "OptionsSliderTemplate");
	sliderOpt:SetWidth(x);
	sliderOpt:SetHeight(y);
	sliderOpt:SetMinMaxValues(min, max);
	sliderOpt:SetValueStep(step);
	_G[sliderOpt:GetName() .. "Low"]:SetText(min);
	_G[sliderOpt:GetName() .. "High"]:SetText(max);
	_G[sliderOpt:GetName() .. "Text"]:SetText(name);
	return sliderOpt
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


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_interfaceSettingsFrame.panel);
end
