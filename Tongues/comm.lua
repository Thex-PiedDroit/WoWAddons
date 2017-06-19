Tonguesc = LibStub("AceComm-3.0");
--LibStub("AceComm-3.0"):Embed(Tongues)

local tserial = LibStub("AceSerializer-3.0");

	---some of this taken from GHI and Modified
	Tonguesc:RegisterComm("Tongues2", function(...) Tonguesc:TonguesRecieveRawMessage(...) end);


function Tonguesc:TonguesSendMessage(channel, player, ...)
	Tonguesc:SendCommMessage("Tongues2", tserial:Serialize({...}), channel, player);
end

function Tonguesc:TonguesSendPrioritizedMessage(prio, channel, player, ...)
	Tonguesc:SendCommMessage("Tongues2", tserial:Serialize({...}), channel, player, prio);
end

function Tonguesc:TonguesRecieveRawMessage(cprefix, text, distribution, sender)
	local sucess, t = tserial:Deserialize(text);
	--print("COMM CHECK");
	Tonguesc:TonguesReceiveMessage(cprefix, sender, distribution, unpack(t));
end




Tongues_ShowComm = false;
function Tonguesc:TonguesReceiveMessage(cprefix, sender, distribution, trans, ...)

	local TP = "<Tongues>";
	local TPLen = string.len(TP);

	--meta = string.match(meta, "^<Tongues>([%a%A]+)");
	--print(meta);

	--REQUEST TRANSLATION------------------------------------------------------------------
	if (trans == "RT") then

		--REMOVE TAG--
		--pre = string.match(pre, "^:RT(:[%a%A]+)");
		--print("after tag " ..pre);
		local flu, chan, fram, lang = ...;
		--POP FLUENCY
		local fluency = 0;
		fluency = flu;
		fluency = tonumber(fluency);

		--POP CHANNEL
		local channel = "";
		channel = chan;
		--POP FRAME
		local frame = 0;
		frame = fram;

		--POP LANGUAGE (looks for optional new : at the end)
		local language = "";
		language = string.match(lang, "([%a%A]+):?");

		if language == nil then
			language = "Upgrade";
		end;

		--local prepstring = "<Tongues>:TR:channel=" .. channel .. ":frame=" .. frame .. ":" .. "[" .. language .. "] " .. Tongues.PreviousSentMsg
		--prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN)
		--SendAddonMessage("Tongues", prepstring, "WHISPER", arg4)
		Tonguesc:TonguesSendMessage("WHISPER", sender, "TR", channel, frame, language, Tongues.PreviousSentMsg);

	--TRANSLATION RESPONSE RECEIVED--------------------------------------------------------
	elseif (trans == "TR") then
		--REMOVE TAG--
		--trans = string.match(meta, "^:TR(:[%a%A]+)");
		--print(trans);
		local chan, fram, lang, msgg = ...;

		--POP CHANNEL
		local channel = chan or "";

		local frame = 0;
		frame = fram;

		local colortable = {};
		local prefix = "";
		local postfix = "";

		if channel == "CHAT_MSG_SAY" then
			postfix = " says";
			colortable = Tongues.Colors.SAY;
		elseif channel == "CHAT_MSG_YELL" then
			postfix = " yells";
			colortable = Tongues.Colors.YELL;
		elseif channel == "CHAT_MSG_PARTY" then
			prefix = "[Party] ";
			colortable = Tongues.Colors.PARTY;
		elseif channel == "CHAT_MSG_GUILD" then
			prefix = "[Guild] ";
			colortable = Tongues.Colors.GUILD;
		elseif channel == "CHAT_MSG_OFFICER" then
			prefix = "[Officer] ";
			colortable = Tongues.Colors.OFFICER;
		elseif channel == "CHAT_MSG_RAID" then
			prefix = "[Raid] ";
			colortable = Tongues.Colors.RAID;
		elseif channel == "CHAT_MSG_RAID_WARNING" then
			colortable = Tongues.Colors.RAID_WARNING;
		elseif channel == "CHAT_MSG_BATTLEGROUND" then
			prefix = "[Battleground] ";
			colortable = Tongues.Colors.BATTLEGROUND;
		elseif channel == "CHAT_MSG_PARTY_LEADER" then
			prefix = "[Party Leader]";
			colortable = Tongues.Colors.PARTY_LEADER;
		end

		sender = Tongues.GetCharacterWho(sender);
		local prepstring = prefix .. sender .. postfix .. ": " .. "[" ..lang.. "] " .. msgg;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);


		if frame ~= 2 then		--ignore combat frame

			if UnitClass("player") == "Mage" and UnitBuff("player", "Arcane Language") and TonguesmageKnownLang == true then
				--We are using Arcane languages, do NOTHING, ABSOLUTLY NOTHING
				prepstring = prefix ..sender..postfix .. ": " .. msgg;
				prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			else
				_G["ChatFrame" .. frame]:AddMessage(prepstring, colortable[1], colortable[2], colortable[3]);
			end
		end

	-- REQUEST VERSION
	elseif (trans == "RV") then
		--local prepstring = "<Tongues>:VR:version=" .. Tongues.Version .. ":";
		--prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
		Tonguesc:TonguesSendMessage("WHISPER", sender, "VR", Tongues.Version);

	-- VERSION RECEIVED
	elseif (trans == "VR") then
		--REMOVE TAG--
		--arg2 = string.match(arg2, "^:VR(:[%a%A]+)");
		local vers = ...;
		--POP VERSION
		local version = "";
		version = vers;

		SELECTED_CHAT_FRAME:AddMessage("(My Tongues version is v" .. version .. ")", 1, 1, 0);

	-- REQUEST LEARN
	elseif (trans == "RL") then
		--REMOVE TAG--
		local lang, fact, rac, clas, fram, flu = ...;

		--POP LANGUAGE
		local language = lang or "";

		--POP FACTION
		local faction = fact or "";

		--POP RACE
		local race = rac or "";

		--POP CLASS
		local class = clas or "";

		--POP FRAME
		local frame = fram or 0;

		--POP FLUENCY
		local fluency = tonumber(flu or "0");

		local learn = 1;
		if  (Tongues.Language[language] ~= nil and Tongues.Language[language].Difficulty ~= nil)
			and (Tongues.Settings.Character.Fluency[language] == nil or Tongues.Settings.Character.Fluency[language] >= fluency)
			and sender ~= UnitName("player") then

			local d = Tongues.Language[language].Difficulty["default"] or 0;
			local f = Tongues.Language[language].Difficulty[faction] or 0;
			local r = Tongues.Language[language].Difficulty[race] or 0;
			local c = Tongues.Language[language].Difficulty[class] or 0;
			local result = d + f + r + c;

			--local seed = math.random(0,2147483647)+(GetTime()*1000);
			--if result <= 0 then result = 100 end
			local randomres = math.random(1, (result + 1));
			if math.random(1, (result + 1)) >= randomres and not (TTimerFrame:IsShown()) then

				if not TTimerFrame:IsShown() then
					Tonguesc:TonguesSendMessage("WHISPER", sender, "LR", language, learn);
					TTimerFrame:Show();
				end
			else
				if result < 1 then
					result = 1;
				end
				local randomres = math.random(1, result + 1);

				if math.random(1, result+1) >= randomres and (math.random(1, 100) > 50) and not TTimerFrame:IsShown() then

					if not TTimerFrame:IsShown() then
						Tonguesc:TonguesSendMessage("WHISPER", sender, "LR", language, learn);
						TTimerFrame:Show();
					end
				end
			end
		end

	-- LEARN RECEIVED
	elseif (trans == "LR") then
		--REMOVE TAG--

		local lang, lrn = ...;

		--POP LANGUAGE
		local language = lang or "";

		--POP LEARN
		local learn = tonumber(lrn or "0");

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
		--REMOVE TAG--
		local flu, petn, fram, lang, pst = ...;

		--POP FLUENCY
		local fluency = tonumber(flu or 0);

		--POP PETNAME
		local petname = petn or "";

		--POP FRAME
		local frame = fram or 0;

		--POP LANGUAGE (looks for optional new : at the end)
		local language = lang or "";
		--POP PETSPEAK
		local petspeaktype = pst or "";

		local prepstring = "<Tongues>:RP:fluency=" .. fluency .. ":frame=" .. frame .. ":language=" .. language .. ":petname=" .. UnitName("pet") .. ":petspeaktype=" .. petspeaktype .. ":" .. Tongues.PreviousPetSentMsg;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
		Tonguesc:TonguesSendMessage("WHISPER", sender, "RP", fluency, frame, language, UnitName("pet"), petspeaktype, Tongues.PreviousPetSentMsg);


	-- PETSPEAK RECEIVED
	elseif (trans == "RP") then
		--REMOVE TAG--
		local flu, fram, lang, petn, pst, pmsg = ...;

		--POP FLUENCY
		local fluency = tonumber(flu or "0");

		--POP FRAME
		local frame = fram or 0;

		--POP LANGUAGE (looks for optional new : at the end)
		local language = lang or "";

		--POP PETNAME
		local petname = petn or "";

		--POP PETNAME
		local petspeaktype = pst or "";

		local petspeak = pmsg;
		if petspeak ~= nil then
			local prepstring = ""
			if  (language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil) then
				prepstring = "[" .. petname .. "] " .. petspeaktype .. ": " .. petspeak;
			else
				prepstring = "[" .. petname .. "] " .. petspeaktype .. ": " .. "[" .. language .. "] " .. petspeak;
			end;

			prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			_G["ChatFrame" .. frame]:AddMessage(prepstring, 1, 1, 0.5);
		end;

	----MOUNT SPEAK TRANSLATION
	elseif (trans == "RMN") then
		--REMOVE TAG--
		local flu, mountn, fram, lang, pst = ...;

		--POP FLUENCY
		local fluency = 0;
		fluency = flu;
		fluency = tonumber(fluency);

		--POP PETNAME
		local mountname = "";
		mountname = mountn;

		--POP FRAME
		local frame = 0;
		frame = fram;

		--POP LANGUAGE (looks for optional new : at the end)
		local language = "";
		language = lang;
		--POP PETSPEAK
		local mountspeaktype = "";
		mountspeaktype = pst;

		local prepstring = "<Tongues>:RP:fluency=" .. fluency .. ":frame=" .. frame .. ":language=" .. language .. ":mountname=" .. mountname .. ":mountspeaktype=" .. mountspeaktype .. ":" .. Tongues.PreviousMountSentMsg;
		prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
		Tonguesc:TonguesSendMessage("WHISPER", sender, "MNR", fluency, frame, language, mountname, mountspeaktype, Tongues.PreviousMountSentMsg);

	-- MOUNTSPEAK RECEIVED
	elseif (trans == "MNR") then
		--REMOVE TAG--
		local flu, fram, lang, mountn, pst, pmsg = ...;

		--POP FLUENCY
		local fluency = 0;
		fluency = flu;
		fluency = tonumber(fluency);

		--POP FRAME
		local frame = 0;
		frame = fram;

		--POP LANGUAGE (looks for optional new : at the end)
		local language = "";
		language = lang;

		--POP PETNAME
		local mountname = "";
		mountname = mountn;

		--POP PETNAME
		local mountspeaktype = "";
		mountspeaktype = pst;

		local mountspeak = pmsg;
		if mountspeak ~= nil then
			local prepstring = ""
			if  (language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil) then

				prepstring = "[" ..UnitName("player")"'s " .. mountname .. "] " .. mountspeaktype .. ": " .. mountspeak;

			elseif sender == UnitName("player") and ((language == "Common" and UnitFactionGroup("player") == "Alliance")
				or (language == "Orcish" and UnitFactionGroup("player") == "Horde")
				or (language == nil)) then

				prepstring = "[" ..mountname .. "] " .. mountspeaktype .. ": " .. mountspeak;

			elseif sender == UnitName("player") then
				prepstring = "[" .. mountname .. "] " .. mountspeaktype .. ": " .. "[" .. language .. "] " .. mountspeak;

			else
				prepstring = "[" .. UnitName("player")"'s " .. mountname .. "] " .. mountspeaktype .. ": " .. "[" .. language .. "] " .. mountspeak;
			end;

			prepstring = string.sub(prepstring, 1, TONGUES_MAX_MSG_LEN);
			_G["ChatFrame" .. frame]:AddMessage(prepstring, 1, 1, 0.5);
		end;
	end;
end
