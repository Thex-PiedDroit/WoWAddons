
g_cerberus.HookThisFile();

g_godsListSettings = {};

AddGodToList = nil;

local panelWidth = 500;
local godNameheight = 20;
local godsCountPerRow = 4;
local marginBetweenGods = 10;


function InitGodsListSettings(frame)

	frame.lab = CreateLabel(frame.panel, "Gods");
	frame.lab:SetPoint("TOPLEFT", 60, -220);

	g_godsListSettings = CreateFrame("Frame", "KTA_GodsListSettingsFrame", frame.panel);
	g_godsListSettings.name = "KTA_GodsListSettingsFrame";
	g_godsListSettings:SetPoint("TOPLEFT", 60, -240);
	g_godsListSettings:SetWidth(panelWidth);
	g_godsListSettings:SetHeight(40);

	g_godsListSettings:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	});
	g_godsListSettings:SetBackdropColor(0,0,0,1);

	frame.godsListPanel = g_godsListSettings;

	for i = 1, #AllSoundLibraries, 1 do
		AddGodToSettingsList(AllSoundLibraries[i]);
	end
end


local godsLabelOriginX, godsLabelOriginY = 35, -13;
local godsChkOriginX, godsChkOriginY = 10, -10;

AddGodToSettingsList = function(god)

	g_godsListSettings.lab = CreateLabel(g_godsListSettings, god.displayName);

	local godsCountInList = (g_godsListSettings.chkGod ~= nil and #g_godsListSettings.chkGod) or 0;

	local offsetX = (panelWidth / godsCountPerRow) * (godsCountInList % godsCountPerRow);
	local rowsCountMinusOne = math.floor(godsCountInList / godsCountPerRow);
	local offsetY = (rowsCountMinusOne * marginBetweenGods) + (rowsCountMinusOne * 20);
	g_godsListSettings.lab:SetPoint("TOPLEFT", godsLabelOriginX + offsetX, godsLabelOriginY - offsetY);

	local godIndex = godsCountInList + 1;
	if g_godsListSettings.chkGod == nil then
		g_godsListSettings.chkGod = {};
	end
	g_godsListSettings.chkGod[godIndex] = CreateCheck(g_godsListSettings, "chkGod_" .. god.dataName, 20, 20);
	g_godsListSettings.chkGod[godIndex]:SetPoint("TOPLEFT", godsChkOriginX + offsetX, godsChkOriginY - offsetY);
	g_godsListSettings.chkGod[godIndex]:SetChecked(TableContains(g_currentGods, god));

	g_godsListSettings.chkGod[godIndex]:SetScript("OnClick", function()

		if TableContains(g_currentGods, god) then
			RemoveGods({ god.dataName }, true);
		else
			AddGods({ god.dataName }, true);
		end
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnGodsChanged", function()
		g_godsListSettings.chkGod[godIndex]:SetChecked(TableContains(g_currentGods, god));
	end);

	g_godsListSettings:SetHeight(40 + offsetY);
end
