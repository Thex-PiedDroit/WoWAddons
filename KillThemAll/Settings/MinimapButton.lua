
g_cerberus.HookThisFile();

local minimapButton = LibStub("LibDBIcon-1.0", true);


function SetMinimapButtonHidden(bHidden)

	g_ktaOptions.minimapButton.hide = bHidden;

	if bHidden then
		minimapButton:Hide("KillThemAll");
	else
		minimapButton:Show("KillThemAll");
	end
end


function InitMinimapButton(settingsPanel)

	local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
	local minimapLDB = ldb:NewDataObject("KillThemAll",
	{
		type = "launcher",
		icon = "Interface/Icons/Spell_shadow_auraofdarkness",
		OnClick = function(clickedframe, button)

			if button == "LeftButton" then
				ToggleDeactivated();
				KTA_Print("KillThemAll is now " .. ((g_ktaOptions.bDeactivated and "deactivated") or "activated"));

			elseif button == "RightButton" then
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

	minimapButton:Register("KillThemAll", minimapLDB, g_ktaOptions.minimapButton);
	SetMinimapButtonHidden(g_ktaOptions.minimapButton.hide);
end
