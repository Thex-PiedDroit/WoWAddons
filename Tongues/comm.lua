Tonguesc = LibStub("AceComm-3.0");
--LibStub("AceComm-3.0"):Embed(Tongues)

local tserial = LibStub("AceSerializer-3.0");

	---some of this taken from GHI and Modified
	Tonguesc:RegisterComm("Tongues2", function(...) Tonguesc:TonguesRecieveRawMessage(...) end);


function Tonguesc:TonguesSendMessage(channel, player, messageDataPack)
	Tonguesc:SendCommMessage("Tongues2", tserial:Serialize(messageDataPack), channel, player);
end

function Tonguesc:TonguesSendPrioritizedMessage(prio, channel, player, messageDataPack)
	Tonguesc:SendCommMessage("Tongues2", tserial:Serialize(messageDataPack), channel, player, prio);
end

function Tonguesc:TonguesRecieveRawMessage(cprefix, text, distribution, sender)
	local sucess, t = tserial:Deserialize(text);
	Tonguesc:TonguesReceiveMessage(cprefix, distribution, sender, t);
end




Tongues_ShowComm = false;
function Tonguesc:TonguesReceiveMessage(cprefix, distribution, sender, messageDataPack)

	local TP = "<Tongues>";
	local TPLen = string.len(TP);

	--meta = string.match(meta, "^<Tongues>([%a%A]+)");
	--print(meta);
	local trans = messageDataPack.trans;
	local language = messageDataPack.language or "";
	local fluency = tonumber(messageDataPack.fluency) or 0;
	local frame = messageDataPack.frame or 0;
	local speakType = messageDataPack.speakType or "";
	local channel = messageDataPack.channel or "";
	local companionName = messageDataPack.companionName or "";
	local message = messageDataPack.message or "";

	local newMessageDataPack = {};

	--REQUEST TRANSLATION------------------------------------------------------------------
	if (trans == "RT") then

		local language = string.match(language, "([%a%A]+):?");

		--REMOVE TAG--
		--pre = string.match(pre, "^:RT(:[%a%A]+)");
		--print("after tag " ..pre);

		--local prepstring = "<Tongues>:TR:channel=" .. channel .. ":frame=" .. frame .. ":" .. "[" .. language .. "] " .. Tongues.PreviousSentMsg
		--prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN)
		--SendAddonMessage("Tongues", prepstring, "WHISPER", arg4)
		newMessageDataPack.trans = "TR";
		newMessageDataPack.channel = channel;
		newMessageDataPack.frame = frame;
		newMessageDataPack.language = language;
		newMessageDataPack.message = Tongues.PreviousSentMsg;
		print("1");
		Tonguesc:TonguesSendMessage("WHISPER", sender, newMessageDataPack);

	--TRANSLATION RESPONSE RECEIVED--------------------------------------------------------
	elseif (trans == "TR") then
		--REMOVE TAG--
		--trans = string.match(meta, "^:TR(:[%a%A]+)");

		local colorTable = {};
		local prefix = "";
		local postfix = "";

		if channel == "CHAT_MSG_SAY" then
			postfix = " says";
			colorTable = Tongues.Colors.SAY;
		elseif channel == "CHAT_MSG_YELL" then
			postfix = " yells";
			colorTable = Tongues.Colors.YELL;
		elseif channel == "CHAT_MSG_PARTY" then
			prefix = "[Party] ";
			colorTable = Tongues.Colors.PARTY;
		elseif channel == "CHAT_MSG_GUILD" then
			prefix = "[Guild] ";
			colorTable = Tongues.Colors.GUILD;
		elseif channel == "CHAT_MSG_OFFICER" then
			prefix = "[Officer] ";
			colorTable = Tongues.Colors.OFFICER;
		elseif channel == "CHAT_MSG_RAID" then
			prefix = "[Raid] ";
			colorTable = Tongues.Colors.RAID;
		elseif channel == "CHAT_MSG_RAID_WARNING" then
			colorTable = Tongues.Colors.RAID_WARNING;
		elseif channel == "CHAT_MSG_BATTLEGROUND" then
			prefix = "[Battleground] ";
			colorTable = Tongues.Colors.BATTLEGROUND;
		elseif channel == "CHAT_MSG_PARTY_LEADER" then
			prefix = "[Party Leader]";
			colorTable = Tongues.Colors.PARTY_LEADER;
		end

		sender = Tongues.GetCharacterWho(sender);
		local prepstring = prefix .. sender .. postfix .. ": " .. "[" .. language .. "] " .. message;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);


		if frame ~= 2 then		--ignore combat frame

			if UnitClass("player") == "Mage" and UnitBuff("player", "Arcane Language") and TonguesmageKnownLang == true then
				--We are using Arcane languages, do NOTHING, ABSOLUTLY NOTHING
				prepstring = prefix .. sender .. postfix .. ": " .. message;
				prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			else
				_G["ChatFrame" .. frame]:AddMessage(prepstring, colorTable[1], colorTable[2], colorTable[3]);
			end
		end

	-- REQUEST VERSION
	elseif (trans == "RV") then
		--local prepstring = "<Tongues>:VR:version=" .. Tongues.Version .. ":";
		--prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
		newMessageDataPack.trans = "VR";
		newMessageDataPack.version = Tongues.Version;
		print("2");
		Tonguesc:TonguesSendMessage("WHISPER", sender, newMessageDataPack);

	-- VERSION RECEIVED
	elseif (trans == "VR") then
		--REMOVE TAG--
		--arg2 = string.match(arg2, "^:VR(:[%a%A]+)");
		local version = messageDataPack.version or "";

		SELECTED_CHAT_FRAME:AddMessage("(My Tongues version is v" .. version .. ")", 1, 1, 0);

	-- REQUEST LEARN
	elseif (trans == "RL") then

		--POP FACTION
		local faction = messageDataPack.faction or "";

		--POP RACE
		local race = messageDataPack.race or "";

		--POP CLASS
		local class = messageDataPack.class or "";

		local learn = 1;
		if  (Tongues.Language[language] ~= nil and Tongues.Language[language].Difficulty ~= nil)
			and (Tongues.Settings.Character.Fluency[language] == nil or Tongues.Settings.Character.Fluency[language] >= fluency)
			and sender ~= UnitName("player") then

			local d = Tongues.Language[language].Difficulty["default"] or 0;
			local f = Tongues.Language[language].Difficulty[faction] or 0;
			local r = Tongues.Language[language].Difficulty[race] or 0;
			local c = Tongues.Language[language].Difficulty[class] or 0;
			local result = d + f + r + c;

			newMessageDataPack.trans = "LR";
			newMessageDataPack.language = language;
			newMessageDataPack.learn = learn;

			--local seed = math.random(0,2147483647)+(GetTime()*1000);
			--if result <= 0 then result = 100 end
			local randomres = math.random(1, (result + 1));
			if math.random(1, (result + 1)) >= randomres and not (TTimerFrame:IsShown()) then

				if not TTimerFrame:IsShown() then
					print("3");
					Tonguesc:TonguesSendMessage("WHISPER", sender, newMessageDataPack);
					TTimerFrame:Show();
				end
			else
				if result < 1 then
					result = 1;
				end
				local randomres = math.random(1, result + 1);

				if math.random(1, result+1) >= randomres and (math.random(1, 100) > 50) and not TTimerFrame:IsShown() then

					if not TTimerFrame:IsShown() then
						print("4");
						Tonguesc:TonguesSendMessage("WHISPER", sender, newMessageDataPack);
						TTimerFrame:Show();
					end
				end
			end
		end

	-- LEARN RECEIVED
	elseif (trans == "LR") then
		--REMOVE TAG--

		--POP LEARN
		local learn = tonumber(messageDataPack.learn or "0");

		if Tongues.Settings.Character.Fluency[language] == nil then
			Tongues.Settings.Character.Fluency[language] = 0;
		end;

		Tongues.Settings.Character.Fluency[language] = Tongues.Settings.Character.Fluency[language] + learn;

		if Tongues.Settings.Character.Fluency[language] > 100 then
			Tongues.Settings.Character.Fluency[language] = 100;
		elseif Tongues.Settings.Character.Fluency[language] < 0 then
			Tongues.Settings.Character.Fluency[lanaguage] = 0;
		end

		Lib_UIDropDownMenu_Initialize(Tongues.UI.MainMenu.Speak.LanguageDropDown.Frame, Tongues.UpdateLanguageDropDown);
		SELECTED_CHAT_FRAME:AddMessage(language .. " skill up +" .. learn, 0.5, 0.5, 1);

	-- REQUEST PETSPEAK
	elseif (trans == "PR") then

		local prepstring = "<Tongues>:RP:fluency=" .. fluency .. ":frame=" .. frame .. ":language=" .. language .. ":petname=" .. UnitName("pet") .. ":petspeaktype=" .. companionSpeakType .. ":" .. Tongues.PreviousPetSentMsg;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);

		newMessageDataPack.trans = "RP";
		newMessageDataPack.fluency = fluency;
		newMessageDataPack.frame = frame;
		newMessageDataPack.language = language;
		newMessageDataPack.companionName = UnitName("pet");
		newMessageDataPack.companionSpeakType = companionSpeakType;
		newMessageDataPack.message = Tongues.PreviousPetSentMsg;
		print("5");
		Tonguesc:TonguesSendMessage("WHISPER", sender, newMessageDataPack);


	-- PETSPEAK RECEIVED
	elseif (trans == "RP") then

		if petspeak ~= nil then
			local prepstring = ""
			if  (language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil) then
				prepstring = "[" .. petname .. "] " .. companionSpeakType .. ": " .. message;
			else
				prepstring = "[" .. petname .. "] " .. companionSpeakType .. ": " .. "[" .. language .. "] " .. message;
			end;

			prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			_G["ChatFrame" .. frame]:AddMessage(prepstring, 1, 1, 0.5);
		end;

	----MOUNT SPEAK TRANSLATION
	elseif (trans == "RMN") then

		local prepstring = "<Tongues>:RP:fluency=" .. fluency .. ":frame=" .. frame .. ":language=" .. language .. ":mountname=" .. companionName .. ":mountspeaktype=" .. companionSpeakType .. ":" .. Tongues.PreviousMountSentMsg;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
		newMessageDataPack.trans = "MNR";
		newMessageDataPack.fluency = fluency;
		newMessageDataPack.frame = frame;
		newMessageDataPack.language = language;
		newMessageDataPack.companionName = companionName;
		newMessageDataPack.companionSpeakType = companionSpeakType;
		newMessageDataPack.message = Tongues.PreviousMountSentMsg;
		print("6");
		Tonguesc:TonguesSendMessage("WHISPER", sender, "MNR", fluency, frame, language, companionName, companionSpeakType, Tongues.PreviousMountSentMsg);

	-- MOUNTSPEAK RECEIVED
	elseif (trans == "MNR") then

		if message ~= nil then
			local prepstring = ""
			if  (language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil) then

				prepstring = "[" ..UnitName("player")"'s " .. companionName .. "] " .. companionSpeakType .. ": " .. message;

			elseif sender == UnitName("player") and ((language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil)) then

				prepstring = "[" .. companionName .. "] " .. companionSpeakType .. ": " .. message;

			elseif sender == UnitName("player") then
				prepstring = "[" .. companionName .. "] " .. companionSpeakType .. ": " .. "[" .. language .. "] " .. message;

			else
				prepstring = "[" .. UnitName("player")"'s " .. companionName .. "] " .. companionSpeakType .. ": " .. "[" .. language .. "] " .. message;
			end;

			prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			_G["ChatFrame" .. frame]:AddMessage(prepstring, 1, 1, 0.5);
		end;
	end;
end
