
Cerberus_HookThisFile();

g_godsListSettings = {};

--[[global]] AddGodToSettingsList = nil; --[[function(god)]]	-- Global cause other modules might want to use it

local l_panelSize =
{
	x = 500.0,
	y = 40.0
};

local function GetGodsText() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_sGods)); end

function InitGodsListSettings(parent, listLabelAnchor, offset)

	local godsLabel = CreateLabel(parent, "Gods");
	godsLabel:SetPoint("TOPLEFT", listLabelAnchor, "BOTTOMLEFT", offset.x, offset.y);

	local godsListFrame = CreateBackdroppedFrame("KTA_GodsListSettingsFrame", parent, l_panelSize);
	godsListFrame:SetPoint("TOPLEFT", godsLabel, "BOTTOMLEFT", -4.0, -5.0);
	godsListFrame.godsLabel = godsLabel;

	local godsHoverFrame = CreateFrame("Frame", "KTA_GodsHoverFrame", parent);
	godsListFrame.hoverFrames = { godsHoverFrame };
	HookTooltipToElement(godsHoverFrame, GetGodsText);

	g_godsListSettings = godsListFrame;

	for i = 1, #g_allSoundLibraries, 1 do
		AddGodToSettingsList(g_allSoundLibraries[i]);
	end

	godsHoverFrame:SetPoint("TOPLEFT", godsLabel, "TOPLEFT");
	godsHoverFrame:SetPoint("BOTTOMRIGHT", godsListFrame, "BOTTOMRIGHT");
end


local l_godsLabelOrigin =
{
	x = 35.0,
	y = -13.0
};
local l_fGodsCheckButtonsMarginFromBorders = 10.0;
local l_fMarginBetweenButtonsAndLabels = 5.0;
local l_fCheckButtonsSize = 20.0;
local l_iGodsCountPerRow = 3;

local l_iGodsCountInList = 0;

--[[global]] AddGodToSettingsList = function(god)

	local iRowsCountMinusOne = math.floor(l_iGodsCountInList / l_iGodsCountPerRow);
	local offset =
	{
		x = (l_panelSize.x / l_iGodsCountPerRow) * (l_iGodsCountInList % l_iGodsCountPerRow),
		y = (iRowsCountMinusOne * (l_fGodsCheckButtonsMarginFromBorders * 0.5)) + (iRowsCountMinusOne * l_fCheckButtonsSize)
	};

	local godCheckButton = CreateCheckButton(god.m_sDataName .. "_CheckButton", g_godsListSettings, l_fCheckButtonsSize);
	godCheckButton:SetPoint("TOPLEFT", l_fGodsCheckButtonsMarginFromBorders + offset.x, -l_fGodsCheckButtonsMarginFromBorders - offset.y);
	godCheckButton:SetChecked(TableContainsUniqueItem(g_currentGods, god));

	local godNameLabel = CreateLabel(g_godsListSettings, god.m_sDisplayName);
	godNameLabel:SetPoint("LEFT", godCheckButton, "RIGHT", l_fMarginBetweenButtonsAndLabels, 1);
	HookTooltipToElement(godCheckButton, GetGodsText, g_godsListSettings.hoverFrames[1]);
	table.insert(g_godsListSettings.hoverFrames, godCheckButton);

	godCheckButton:SetScript("OnClick", function()
		if TableContainsUniqueItem(g_currentGods, god, true) then
			RemoveGods({ god.m_sDataName }, true);
		else
			AddGods({ god.m_sDataName }, true);
		end
	end);

	local iGodIndex = l_iGodsCountInList + 1;
	if g_godsListSettings.godsCheckButtonsList == nil then
		g_godsListSettings.godsCheckButtonsList = {};
	end

	AddListenerEvent(g_interfaceEventsListener, "OnGodsChanged", function()
		godCheckButton:SetChecked(TableContainsUniqueItem(g_currentGods, god));
	end);

	g_godsListSettings.godsCheckButtonsList[iGodIndex] = godCheckButton;
	g_godsListSettings:SetHeight((l_fGodsCheckButtonsMarginFromBorders * 2) + l_fCheckButtonsSize + offset.y);

	l_iGodsCountInList = l_iGodsCountInList + 1;
end
