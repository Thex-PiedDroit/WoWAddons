
Cerberus_HookThisFile();


function PrintCommandTooltip(tooltipItem, bNoToolTip)

	if tooltipItem ~= nil then
		print(tooltipItem.sCommandSignature);

		if not bNoToolTip then
			KTA_Print(tooltipItem.sTooltip);
		end
	end
end

function PrintHelp(sCmd, args, sParameters)

	local bNoToolTip = sParameters == "noToolTip";
	local tooltipToPrint = nil;

	if sCmd == nil then
		return;
	end

	tooltipToPrint = g_allCommands[sCmd];


	if sCmd == "SETDEFAULT" then

		local arg1 = (args ~= nil and #args > 0 and args[1]);

		if arg1 ~= nil and arg1 ~= "" then

			if tooltipToPrint[arg1] ~= nil then
				tooltipToPrint = tooltipToPrint[arg1];
			end
		end

	elseif sCmd == "DISPLAY" then

		if args ~= nil and #args > 0 then

			if TableContains(args, "DEFAULT") then
				tooltipToPrint = tooltipToPrint["DEFAULT"];
			end

			local tooltipItemBackup = tooltipToPrint;

			if TableContains(args, { "GOD", "GODS" }) then
				tooltipToPrint = tooltipItemBackup["GODS"];
				PrintCommandTooltip(tooltipToPrint, bNoToolTip);
				tooltipToPrint = nil;
			end

			if TableContains(args, "DELAY") then
				tooltipToPrint = tooltipItemBackup["DELAY"];
				PrintCommandTooltip(tooltipToPrint, bNoToolTip);
				tooltipToPrint = nil;
			end

			if TableContains(args, { "SOUNDCHANNEL", "CHANNEL" }) then
				tooltipToPrint = tooltipItemBackup["SOUNDCHANNEL"];
				PrintCommandTooltip(tooltipToPrint, bNoToolTip);
				tooltipToPrint = nil;
			end
		end

	elseif sCmd == "DEBUG" or sCmd == "DBG" then

		local sArg1 = (args ~= nil and #args > 0 and args[1]);

		if sArg1 ~= nil and sArg1 ~= "" then

			if tooltipToPrint[sArg1] ~= nil then
				tooltipToPrint = tooltipToPrint[sArg1];
			end
		end
	end

	PrintCommandTooltip(tooltipToPrint, bNoToolTip);
end

local l_allCommandsAlphabeticalyOrdered = {};

function PrintAllCommands()

	KTA_Print("All commands:");
	if #l_allCommandsAlphabeticalyOrdered == 0 then
		for _, value in pairs(g_allCommands) do
			table.insert(l_allCommandsAlphabeticalyOrdered, value);
		end

		sort(l_allCommandsAlphabeticalyOrdered, function(lhs, rhs) return lhs.sCommandSignature < rhs.sCommandSignature end);
	end

	for i = 1, #l_allCommandsAlphabeticalyOrdered do
		PrintCommandTooltip(l_allCommandsAlphabeticalyOrdered[i], true);
	end
end

_G["SLASH_KillThemAll1"] = "/kta";

local function RemoveHelpFromArgs(sCmd, args, iHelpIndex)

	if sCmd == "HELP" then
		sCmd = args[1];
		table.remove(args, 1);
	else
		table.remove(args, iHelpIndex);
	end

	return sCmd, args;
end

local function HandleHelpCommand(sCmd, args)

	local bHelpCall, iHelpIndex = TableContains(args, "HELP");
	if not bHelpCall then
		bHelpCall = sCmd == "HELP";
	end

	if bHelpCall then
		if iHelpIndex == nil and #args == 0 then
			PrintAllCommands();
		else
			PrintHelp(RemoveHelpFromArgs(sCmd, args, iHelpIndex));
		end

		return true;
	end

	return false;
end

function SlashCmdList.KillThemAll(sMessage)

	if sMessage == nil or sMessage == "" then
		return;
	end

	sMessage, _ = SecureCmdOptionParse(sMessage);	-- Test for any macro conditionals
	if sMessage == nil then
		return;	-- Conditionals were not met
	end

	print(sMessage);	-- For input feedback


	local sCmd, sArgs = GetFirstWordAndRest(string.upper(sMessage));
	local args = GetWords(sArgs);

	local bHelpCommandHandled = HandleHelpCommand(sCmd, args);
	if bHelpCommandHandled then
		return;
	end

	local command = g_allCommands[sCmd];
	local argumentsToPass = nil;

	if sCmd == "SETSOUNDCHANNEL" then
		argumentsToPass = args[1];

	elseif sCmd == "SETDEFAULT" then

		local arg1 = (args ~= nil and #args > 0 and args[1]);
		if arg1 ~= nil and command[arg1] ~= nil then
			command = command[arg1];
		end

		if arg1 == "GODS" or arg1 == "GOD" or arg1 == "DELAY" then
			argumentsToPass = SubTable(args, 2);
		elseif arg1 == "SOUNDCHANNEL" or arg1 == "CHANNEL" then
			argumentsToPass = args[2];
		end

	elseif sCmd == "DISPLAY" then

		local bDefaultAsked, iWordDefaultIndex = TableContains(args, "DEFAULT");
		if bDefaultAsked then
			table.remove(args, iWordDefaultIndex);
			command["DEFAULT"].m_Func(args);
			command = nil;

		else
			local commandBackup = command;

			if TableContains(args, "DELAY") then
				commandBackup["DELAY"].m_Func();
				command = nil;
			end
			if TableContains(args, { "GOD", "GODS" }) then
				commandBackup["GODS"].m_Func();
				command = nil;
			end
			if TableContains(args, { "SOUNDCHANNEL", "CHANNEL" }) then
				commandBackup["SOUNDCHANNEL"].m_Func();
				command = nil;
			end
		end

		if command ~= nil then
			command["DELAY"].m_Func();
			command["GODS"].m_Func();
			command["SOUNDCHANNEL"].m_Func();
		end

		return;		-- To avoid "Unknown command"

	elseif sCmd == "DEBUG" or sCmd == "DBG" then

		local arg1 = (args ~= nil and #args > 0 and args[1]);
		if arg1 ~= nil and command[arg1] ~= nil then
			command = command[arg1];
		end
	end


	if command ~= nil then
		if argumentsToPass == nil then
			argumentsToPass = args;
		end
		command.m_Func(argumentsToPass);
	else
		KTA_Print("Unknown command: " .. sCmd);
		PrintAllCommands();
	end
end
