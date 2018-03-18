
--[[
voteData =
{
	sPollGUID,
	sVoterBTag,
	sVoterFullName,
	newAnswers = {},	-- Answers added by the voter
	vote = {}		-- List of answerIDs
}

-- Answers each have "unique" IDs =>
		Initial answers have IDs "1", "2", "3"...
		Additional answers have IDs like "A1", "A2", "B1", "C1", "C2"... where the letters are the names of the characters who added those answers.
			Exemple: "Illydann-Eitrigg1", "Illydann-Eitrigg2", "Atasmanatilt-Draenor1", "Xxdestructozorxx-Eitrigg1", "Xxdestructozorxx-Eitrigg2"
]]


Cerberus_HookThisFile();

function SendVoteAway(self)

	self:Disable();

	local voteData = GetVoteData();
	local pollData = GetPollData(voteData.sPollGUID);

	SendPollMessage({ voteData = voteData }, "Vote", "WHISPER", pollData.sPollMasterFullName, pollData.sPollMasterRealm);
	g_pollCraftData.savedPollsData[pollData.sPollGUID].bIVoted = true;
	TickVoteForPoll(pollData.sPollGUID, true, pollData.sPollMasterFullName == Me());
end


function HandleVoteMessageReception(voteMessage, sSenderFullName, sSenderRealm)

	if voteMessage.bIsBroadcast and
		((sSenderFullName ~= nil and sSenderFullName == Me())
		or (voteMessage.sExcludedGuyFromBroadcast == Me())) then
		return;
	end

	local voteData = voteMessage.voteData;
	local pollData = GetPollData(voteData.sPollGUID);
	if pollData == nil then
		return;
	end

	RegisterVote(voteData);
	local bShouldAddVoteToDisplay = true;

	if pollData.sPollMasterFullName == Me() then

		local resultsMessageData =
		{
			sPollGUID = voteData.sPollGUID,
			pollAnswers = pollData.answers,
			results = pollData.results
		}

		SendPollMessage({ resultsData = resultsMessageData }, "Results", "WHISPER", sSenderFullName, sSenderRealm);
		SendPollMessage({ voteData = voteData, bIsBroadcast = true, sExcludedGuyFromBroadcast = sSenderFullName }, "Vote", pollData.sPollType);	-- Broadcast the vote to everyone else
		bShouldAddVoteToDisplay = false;	-- Because we receive the results before going further
	end

	if IsCurrentlyVotingForPoll(voteData.sPollGUID) then
		LoadAdditionalAnswersForVoting(voteData.newAnswers);
	elseif bShouldAddVoteToDisplay then
		AddVoteToResultsDisplay(voteData);
	end
end
