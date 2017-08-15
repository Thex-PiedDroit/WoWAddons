
--[[
voteData =
{
	sPollGUID,
	newAnswers {},	-- Answers added by the voter
	vote {}		-- List of answerIDs
}

-- Answers each have "unique" IDs =>
		Initial answers have IDs "1", "2", "3"...
		Additional answers have IDs like "A1", "A2", "B1", "C1", "C2"... where the letters are the names of the characters who added those answers.
			Exemple: "Illydann-Eitrigg1", "Illydann-Eitrigg2", "Atasmanatilt-Draenor1", "Xxdestructozorxx-Eitrigg1", "Xxdestructozorxx-Eitrigg2"
]]

g_cerberus.HookThisFile();


function SendVoteAway(self)

	self:Disable();

	local voteData = GetVoteData();
	local pollData = GetPollData(voteData.sPollGUID);

	SendPollMessage({ voteData = voteData }, "Vote", "WHISPER", pollData.sPollMasterFullName, pollData.sPollMasterRealm);
end

function BroadcastVote(voteData, sExcludedGuyFromBroadcast)

	local pollData = GetPollData(voteData.sPollGUID);
	SendPollMessage({ voteData = voteData, bIsBroadcast = true, sExcludedGuyFromBroadcast = sExcludedGuyFromBroadcast }, "Vote", pollData.sPollType);
end


function HandleVoteMessageReception(voteMessage, sSenderFullName, sSenderRealm)

	if voteMessage.bIsBroadcast and
		((sSenderFullName ~= nil and sSenderFullName == Me())
		or (voteMessage.sExcludedGuyFromBroadcast == Me())) then
		return;
	end

	local voteData = voteMessage.voteData;
	local pollData = GetPollData(voteData.sPollGUID);

	local bCurrentlyVoting = IsCurrentlyVotingForPoll(voteData.sPollGUID);

	local bRegisteredVote = false;
	if not bCurrentlyVoting then
		RegisterVote(voteData);
		AddVoteToResultsDisplay(voteData);
		bRegisteredVote = true;
	end

	if pollData.sPollMasterFullName == Me() then
		if not bRegisteredVote then
			RegisterVote(voteData);
		end
		local resultsMessageData =
		{
			sPollGUID = voteData.sPollGUID,
			pollAnswers = pollData.answers,
			results = pollData.results
		}
		SendPollMessage({ resultsData = resultsMessageData }, "Results", "WHISPER", sSenderFullName, sSenderRealm);
		BroadcastVote(voteData, sSenderFullName);
	elseif bCurrentlyVoting then
		LoadAdditionalAnswersForVoting(voteData.newAnswers);
	end
end
