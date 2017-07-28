
--[[
voteData =
{
	pollGUID,
	newAnswers {},	-- Answers added by the voter
	vote {}		-- List of answerIDs
}

-- Answers each have "unique" IDs =>
		Initial answers have IDs "1", "2", "3"...
		Additional answers have IDs like "A1", "A2", "B1", "C1", "C2"... where the letters are the names of the characters who added those answers.
			Exemple: "Illydann-Eitrigg1", "Illydann-Eitrigg2", "Atasmanatilt-Draenor1", "Xxdestructozorxx-Eitrigg1", "Xxdestructozorxx-Eitrigg2"
]]


function SendVoteAway(self, args)

	self:Disable();

	local voteData = GetVoteData();
	local pollData = GetPollData(voteData.pollGUID);

	SendPollMessage({ voteData = voteData }, "Vote", "WHISPER", pollData.pollMasterFullName, pollData.pollMasterRealm);
end

function BroadcastVote(voteData, excludedGuyFromBroadcast)

	local pollData = GetPollData(voteData.pollGUID);
	SendPollMessage({ voteData = voteData, isBroadcast = true, excludedGuyFromBroadcast = excludedGuyFromBroadcast }, "Vote", pollData.pollType);
end


function HandleVoteMessageReception(voteMessage, senderFullName, senderRealm)

	if voteMessage.isBroadcast and
		((senderFullName ~= nil and senderFullName == PollCraft_Me())
		or (voteMessage.excludedGuyFromBroadcast == PollCraft_Me())) then
		return;
	end

	local voteData = voteMessage.voteData;
	local pollData = GetPollData(voteData.pollGUID);

	local registeredVote = false;
	if not g_currentlyBusy then
		RegisterVote(voteData);
		AddVoteToResultsDisplay(voteData);
		registeredVote = true;
	end

	if pollData.pollMasterFullName == PollCraft_Me() then
		if not registeredVote then
			RegisterVote(voteData);
		end
		local resultsMessageData =
		{
			pollGUID = voteData.pollGUID,
			pollAnswers = pollData.answers,
			results = pollData.results
		}
		SendPollMessage({ resultsData = resultsMessageData }, "Results", "WHISPER", senderFullName, senderRealm);
		BroadcastVote(voteData, senderFullName);
	end

	if g_currentlyBusy then
		LoadAdditionalAnswersForVoting(voteData.newAnswers);
	end
end
