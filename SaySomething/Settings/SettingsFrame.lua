
g_SaySomethingSettingsFrame = {};


function InitSaySomethingSettingsFrame()

	-- CONTAINING FRAME
	g_SaySomethingSettingsFrame.panel = CreateFrame("Frame", "SaySomethingSettingsFrame", UIParent);
	g_SaySomethingSettingsFrame.panel.name = "SaySomething";



	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_SaySomethingSettingsFrame.panel);
end
