
Cerberus_HookThisFile();

g_godsListSettings = {};

AddGodToSettingsList = nil;

local panelSize =
{
	x = 500,
	y = 40
};

function InitGodsListSettings(parent, listLabelAnchor, offset)

	local godsLabel = CreateLabel(parent, "Gods");
	godsLabel:SetPoint("TOPLEFT", listLabelAnchor, "BOTTOMLEFT", offset.x, offset.y);

	local godsListFrame = CreateBackdroppedFrame("KTA_GodsListSettingsFrame", parent, panelSize);
	godsListFrame:SetPoint("TOPLEFT", godsLabel, "BOTTOMLEFT", -4, -5);

	g_godsListSettings = godsListFrame;

	for i = 1, #g_allSoundLibraries, 1 do
		AddGodToSettingsList(g_allSoundLibraries[i]);
	end
end


local godsLabelOrigin =
{
	x = 35,
	y = -13
};
local godsCheckButtonsMarginFromBorders = 10;
local fMarginBetweenButtonsAndLabels = 5;
local fCheckButtonsSize = 20;
local iGodsCountPerRow = 3;

local iGodsCountInList = 0;

--[[global]] AddGodToSettingsList = function(god)

	local iRowsCountMinusOne = math.floor(iGodsCountInList / iGodsCountPerRow);
	local offset =
	{
		x = (panelSize.x / iGodsCountPerRow) * (iGodsCountInList % iGodsCountPerRow),
		y = (iRowsCountMinusOne * (godsCheckButtonsMarginFromBorders * 0.5)) + (iRowsCountMinusOne * fCheckButtonsSize)
	};

	local godCheckButton = CreateCheckButton(god.m_sDataName .. "_CheckButton", g_godsListSettings, fCheckButtonsSize);
	godCheckButton:SetPoint("TOPLEFT", godsCheckButtonsMarginFromBorders + offset.x, -godsCheckButtonsMarginFromBorders - offset.y);
	godCheckButton:SetChecked(TableContainsUniqueItem(g_currentGods, god));

	local godNameLabel = CreateLabel(g_godsListSettings, god.m_sDisplayName);
	godNameLabel:SetPoint("LEFT", godCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 1);

	godCheckButton:SetScript("OnClick", function()
		if TableContainsUniqueItem(g_currentGods, god, true) then
			RemoveGods({ god.m_sDataName }, true);
		else
			AddGods({ god.m_sDataName }, true);
		end
	end);

	local iGodIndex = iGodsCountInList + 1;
	if g_godsListSettings.godsCheckButtonsList == nil then
		g_godsListSettings.godsCheckButtonsList = {};
	end

	AddListenerEvent(g_interfaceEventsListener, "OnGodsChanged", function()
		godCheckButton:SetChecked(TableContainsUniqueItem(g_currentGods, god));
	end);

	g_godsListSettings.godsCheckButtonsList[iGodIndex] = godCheckButton;
	g_godsListSettings:SetHeight((godsCheckButtonsMarginFromBorders * 2) + fCheckButtonsSize + offset.y);

	iGodsCountInList = iGodsCountInList + 1;
end
