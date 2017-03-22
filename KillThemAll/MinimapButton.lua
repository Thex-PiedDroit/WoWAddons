
g_minimapButton = LibStub("LibDBIcon-1.0", true);


function SetMinimapButtonHidden(hidden)

	g_ktaOptions.minimapButton.hide = hidden;

	if hidden then
		g_minimapButton:Hide("KillThemAll");
	else
		g_minimapButton:Show("KillThemAll");
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
			elseif button == "RightButton" then
				InterfaceOptionsFrame_OpenToCategory(settingsPanel);
				InterfaceOptionsFrame_OpenToCategory(settingsPanel);	-- Twice because once only opens the menu, not the right category, for some reason
			end
		end,
	});

	function minimapLDB:OnTooltipShow()
		self:AddLine("|c" .. TEXT_COLOR .. "KillThemAll|r");
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

	g_minimapButton:Register("KillThemAll", minimapLDB, g_ktaOptions.minimapButton);
	SetMinimapButtonHidden(g_ktaOptions.minimapButton.hide);
end
