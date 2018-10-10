
Cerberus_HookThisFile();

local l_minimapButton = LibStub("LibDBIcon-1.0", true);


function SetMinimapButtonHidden(bHidden)

	g_ktaCurrentSettings.m_minimapButton.hide = bHidden;

	if bHidden then
		l_minimapButton:Hide("KillThemAll");
	else
		l_minimapButton:Show("KillThemAll");
	end
end


function InitMinimapButton(settingsPanel)

	local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
	local minimapLDB = ldb:NewDataObject("KillThemAll",
	{
		type = "launcher",
		icon = "Interface/Icons/Spell_shadow_auraofdarkness",
		OnClick = function(clickedFrame, sButton)

			if sButton == "LeftButton" then
				ToggleDeactivated();
				KTA_Print("KillThemAll is now " .. ((g_ktaCurrentSettings.m_bDeactivated and "deactivated") or "activated"));

			elseif sButton == "RightButton" then
				OpenSettingsPanel();
			end
		end,
	});

	function minimapLDB:OnTooltipShow()
		self:AddLine("|c" .. g_cAddonColor .. "KillThemAll|r");
		self:AddLine("|cFFFFFFFFLeft click: activate/deactivate|r");
		self:AddLine("|cFFFFFFFFRight click: open settings|r");
	end
	function minimapLDB:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
		GameTooltip:ClearLines();
		dataobj.OnTooltipShow(GameTooltip);
		GameTooltip:Show();
		dataobj.hide = true;
		dataobj:Hide();
	end
	function minimapLDB:OnLeave()
		GameTooltip:Hide();
	end

	g_ktaCurrentSettings.m_minimapButton = g_ktaCurrentSettings.m_minimapButton or {};
	l_minimapButton:Register("KillThemAll", minimapLDB, g_ktaCurrentSettings.m_minimapButton);
	SetMinimapButtonHidden(g_ktaCurrentSettings.m_minimapButton.hide);
end
