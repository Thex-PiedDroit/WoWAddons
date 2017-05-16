
g_graphicalSpellSayingItemWidth = 150;
g_iconSize = 80;
local ICON_AND_TEXT_MARGIN = 10;

function CreateGraphicalSpellSayingItem(panel, data)

	local newGraphicalSpellSayingItem = {};

	mainFrame = CreateFrame("Frame", nil, panel);
	mainFrame:SetSize(g_graphicalSpellSayingItemWidth, g_iconSize);

	local icon = CreateFrame("Frame", "SpellIcon", mainFrame);
	icon:SetPoint("TOPLEFT");
	icon:SetSize(g_iconSize, g_iconSize);
	icon.spellTexture = mainFrame:CreateTexture("SpellTexture", "ARTWORK");
	icon.spellTexture:SetPoint("TOPLEFT");


	if data ~= nil then
		local spellName, _, iconTexture = GetSpellInfo(data.spellID);

		icon.spellTexture:SetTexture(iconTexture, false);

		newGraphicalSpellSayingItem.spellName = CreateLabel(mainFrame, spellName);
		newGraphicalSpellSayingItem.spellName:SetPoint("TOPLEFT", g_iconSize + ICON_AND_TEXT_MARGIN, 0);

		newGraphicalSpellSayingItem.sentencesCount = CreateLabel(mainFrame, #sentences .. " sentences");
		newGraphicalSpellSayingItem.sentencesCount:SetPoint("TOPLEFT", g_iconSize + ICON_AND_TEXT_MARGIN, -15);

		-- Have to do the mutes here	local mutes = {};
	else
		icon.spellTexture:SetTexture("Interface/Icons/Spell_chargepositive", false);
	end

	newGraphicalSpellSayingItem.mainFrame = mainFrame;
	icon.spellTexture:SetSize(g_iconSize, g_iconSize);
	newGraphicalSpellSayingItem.icon = icon;

	return newGraphicalSpellSayingItem;
end
