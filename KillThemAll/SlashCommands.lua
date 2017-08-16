
g_cerberus.HookThisFile();
local g_NoToolTip = false;

function PrintTooltip(str)

	if not g_NoToolTip then
		KTA_Print(str);
	end
end

function PrintHelp(cmd, args, parameters)

	g_NoToolTip = parameters == "noToolTip";

	if cmd == "SETDELAY" then
		print("/kta SetDelay [<min:seconds> <max:seconds>] | [default|0]");

		PrintTooltip("Will change the timespan between two whispers. Giving \"default\" or 0 as only parameter will reset to default values.\nExample: \"/kta SetDelay 300 600\".");

	elseif cmd == "SETGODS" or cmd == "SETGOD" then

		local godNames = "";

		for i = 1, #AllSoundLibraries, 1 do
			godNames = godNames .. AllSoundLibraries[i].dataName .. "|";
		end

		print("/kta SetGods <GodName:" .. godNames .. "All|None|Default>");

		PrintTooltip("Will change the god(s) who whispers to you. Multiple gods can be set at the same time by naming them one by one. Giving \"default\" will reset to default value. This won't affect whispers frequency.\nExample: \"/kta SetGods Cthun YoggSaron\".");

	elseif cmd == "ADDGODS" or cmd == "ADDGOD" or cmd == "ADD" then

		local godNames = "";

		for i = 1, #AllSoundLibraries, 1 do
			godNames = godNames .. AllSoundLibraries[i].dataName .. "|";
		end
		print("/kta AddGods <GodName: " .. godNames .. "All>");

		PrintTooltip("Will add god(s) to the currently whispering gods. This won't affect whispers frequency.\nExample: \"/kta AddGods Cthun YoggSaron\".");

	elseif cmd == "REMOVEGODS" or cmd == "REMOVEGOD" or cmd == "REMOVE" then

		local godNames = "";

		for i = 1, #AllSoundLibraries, 1 do
			godNames = godNames .. AllSoundLibraries[i].dataName .. "|";
		end

		print("/kta RemoveGods <GodName:" .. godNames .. "All>");

		PrintTooltip("Will remove god(s) from the currently whispering gods. If all removed, no god will whisper until new ones are added. This won't affect whispers frequency.\nExample: \"/kta RemoveGods CTHUN YOGGSARON\".");

	elseif cmd == "SETSOUNDCHANNEL" or cmd == "SETCHANNEL" then

		print("/kta SetSoundChannel <SoundChannel: Master|Sound|Music|Ambience|Dialog|Default>");

		PrintTooltip("Will change the sound channel the soundfiles will be played on.\nExample: \"/kta SetSoundChannel Dialog\".");

	elseif cmd == "SETDEFAULT" then

		if args ~= nil and args[1] ~= "" then

			if args[1] == "GOD" or args[1] == "GODS" then

				local godNames = "";

				for i = 1, #AllSoundLibraries, 1 do
					godNames = godNames .. AllSoundLibraries[i].dataName .. "|";
				end

				print("/kta SetDefault GODS <GodName: " .. godNames .. "All|None>");

				PrintTooltip("Will change the default gods to set when using the \"/kta reset\" or \"/kta setGod default\" command. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault Gods CTHUN YOGGSARON\".");
				return;

			elseif args[1] == "DELAY" then

				print("/kta SetDefault Delay [<min:seconds> <max:seconds>]");

				PrintTooltip("Will change the default delay to set when using the \"/kta reset\" or \"/kta setDelay default\" command. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault Delay 300 600\".");
				return;
				
			elseif args[1] == "SOUNDCHANNEL"  or args[1] == "CHANNEL" then
			
				print("/kta SetDefault SoundChannel <SoundChannel: Master|Sound|Music|Ambience|Dialog|Default>");
				
				PrintTooltip("Will change the default sound channel to set when using the \"/kta reset\" or \"/kta SetSoundChannel default\" command. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault SoundChannel Dialog\".");
				return;
			end
		end

		print("/kta SetDefault [Delay|Gods|SoundChannel]");

		PrintTooltip("Will change the default values to set when using the \"/kta reset\" or \"/kta [setGods|setDelay|setSoundChannel] default\" command. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.");

	elseif cmd == "RESET" then

		print("/kta Reset");

		PrintTooltip("Will reset all gods and values to default ones. You can change the default values and gods by using the \"/kta SetDefault\" command.");

	elseif cmd == "DISPLAY" then

		if args ~= nil then

			if TableContains(args, "DEFAULT") then

				if TableContains(args, "GODS") or TableContains(args, "GOD") then
					print("/kta Display default gods");
					PrintTooltip("Will display the current default god(s) to set when using the \"/kta setDefault gods\" command.");
					return;
				elseif TableContains(args, "DELAY") then
					print("/kta Display default delay");
					PrintTooltip("Will display the current default delay to set when using the \"/kta setDefault delay\" command.");
					return;
				elseif TableContains(args, "SOUNDCHANNEL") or TableContains(args, "CHANNEL") then
					print("/kta Display Default soundChannel");
					PrintTooltip("Will display the default sound channel to set when using the \"/kta setDefault delay\" command.");
					return;
				end

				print("/kta Display default [God|Delay|SoundChannel]");
				PrintTooltip("Will display the current default values to set when using the \"/kta setDefault\" command.");
				return;
			else
				if TableContains(args, "DELAY") then
					print("/kta Display delay");
					PrintTooltip("Will display the timespan between which whispers might happen.");
				end
				if TableContains(args, "GODS") or TableContains(args, "GOD") then
					print("/kta Display gods");
					PrintTooltip("Will display which gods are currently able to whisper to you.");
				end
				if TableContains(args, "SOUNDCHANNEL") or TableContains(args, "CHANNEL") then
					print("/kta Display soundChannel");
					PrintTooltip("Will display the current sound channel the soundfiles will be played on.");
				end
				return;
			end
		end

		print("/kta Display [Delay|Gods|SoundChannel|Default]");
		PrintTooltip("Will display current parameters. If no parameter provided, all parameters will be listed.");

	elseif cmd == "SETTINGS" or cmd == "OPTIONS" then

		print("/kta Settings");
		PrintTooltip("Opens up the settings panel");

	elseif cmd == "DEBUG" or cmd == "DBG" then

		if args ~= nil and args[1] ~= "" then
			if args[1] == "CLEARMEMORY" then
				print("/kta Debug ClearMemory");
				PrintTooltip("Will erase all saved variables as on first addon use (this includes default variables values, which will be reset on next launch).");
				return;
			elseif args[1] == "NOSAVE" then
				print("/kta Debug NoSave");
				PrintTooltip("Will prevent the addon from saving variables at the end of this session (affected are delay and gods list.");
				return;
			elseif args[1] == "SAVE" then
				print("/kta Debug Save");
				PrintTooltip("Will make the game save variables at the end of this session. This is the default behaviour on session start.");
				return;
			end
		end

		print("/kta Debug [clearMemory] | [noSave|dontSave] | [save]");
		PrintTooltip("Several functions used for debugging purpose. You should normally not need to use any.");
	end
end

function PrintAllCommands()

	KTA_Print("All commands:");
	PrintHelp("SETDELAY", nil, "noToolTip");
	PrintHelp("SETGODS", nil, "noToolTip");
	PrintHelp("SETSOUNDCHANNEL", nil, "noToolTip");
	PrintHelp("SETDEFAULT", nil, "noToolTip");
	PrintHelp("RESET", nil, "noToolTip");
	PrintHelp("DISPLAY", nil, "noToolTip");
	PrintHelp("SETTINGS", nil, "noToolTip");
	PrintHelp("DEBUG", nil, "noToolTip");
end

SLASH_KTA1 = "/kta";

function SlashCmdList.KTA(msg)
	
	if msg == nil or msg == "" then
		return;
	end

	print(msg);

	local cmd, strArgs = GetFirstWordAndRest(string.upper(msg));
	local args = GetWords(strArgs);

	local helpCall, helpIndex = TableContains(args, "HELP");
	if helpCall == false then
		helpCall = cmd == "HELP";
	end
	
	if helpCall then
		if helpIndex == nil or helpIndex == 0 then
			PrintAllCommands();
		else
			PrintHelp(cmd, SubTable(args, 1, helpIndex - 1));
		end
		return;
	end


	if cmd == "SETGODS" or cmd == "SETGOD" then
		SetGods(args);

	elseif cmd == "ADDGODS" or cmd == "ADDGOD" or cmd == "ADD" then
		AddGods(args);

	elseif cmd == "REMOVEGODS" or cmd == "REMOVEGOD" or cmd == "REMOVE" then
		RemoveGods(args);

	elseif cmd == "SETDELAY" then
		SetDelay(args[1], args[2]);

	elseif cmd == "SETCHANNEL" or cmd == "SETSOUNDCHANNEL" then
		SetSoundChannel(args[1]);

	elseif cmd == "SETDEFAULT" then

		if args[1] == "GODS" or args[1] == "GOD" then
			SetDefaultGods(SubTable(args, 2));
		elseif args[1] == "DELAY" then
			SetDefaultDelay(args[2], args[3]);
		elseif args[1] == "SOUNDCHANNEL" or args[1] == "CHANNEL" then
			SetDefaultSoundChannel(args[2]);
		else
			KTA_Print("Invalid use of SetDefault command:");
			PrintHelp("SETDEFAULT", nil, "noToolTip");
		end

	elseif cmd == "RESET" then
		ResetValues();

	elseif cmd == "DISPLAY" then

		local displayedSomething = false;

		if TableContains(args, "DEFAULT") then
			tempTable = SubTable(args, 2);
			DisplayDefaultValues(tempTable);
			displayedSomething = true;
		else
			if TableContains(args, "DELAY") then
				PrintDelay();
				displayedSomething = true;
			end
			if TableContains(args, "GODS") or TableContains(args, "GOD") then
				DisplayCurrentGods();
				displayedSomething = true;
			end
			if TableContains(args, "SOUNDCHANNEL") or TableContains(args, "CHANNEL") then
				DisplaySoundChannel();
				displayedSomething = true;
			end
		end

		if not displayedSomething then
			PrintDelay();
			DisplayCurrentGods();
			DisplaySoundChannel();
			return;
		end

	elseif cmd == "SETTINGS" or cmd == "OPTIONS" then

		OpenSettingsPanel();

	elseif cmd == "DEBUG" or cmd == "DBG" then

		if args[1] == "CLEARMEMORY" or args[1] == "CLEARMRY" then
			ClearMemory();

		elseif args[1] == "NOSAVE" or args[1] == "DONTSAVE" then

			g_shouldVariablesBeSaved = false;
			KTA_Print("Variables won't be saved on logout (once). This can be reverted with the \"/kta debug save\" command");

		elseif args[1] == "SAVE" then

			g_shouldVariablesBeSaved = true;
			KTA_Print("Variables will be saved on logout");

		elseif args[1] == "RUN" or args[1] == "RUNCOMMAND" or args[1] == "RUNCMD" or args[1] == "CMD" or args[1] == "R" then

			_, unCapitalizedCmd = GetFirstWordAndRest(msg);
			_, script = GetFirstWordAndRest(unCapitalizedCmd);		-- Get rid of first word in strArgs (since first word here will be "run")
			codeToRun = loadstring(script);
			if codeToRun ~= nil then
				codeToRun();
			else
				KTA_Print("Invalid command");
			end
		end
	else
		KTA_Print("Unknown command: " .. cmd);
		PrintAllCommands();
	end
end
