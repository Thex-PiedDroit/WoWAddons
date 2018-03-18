
--[[
pollData =
{
	sPollGUID,
	sPollMasterFullName,
	sPollMasterRealm,
	sPollType,
	bMultiVotes,
	bAllowNewAnswers,
	sQuestion,
	answers = {}
	results =
	{
		[sAnswerGUID] = iX,	-- Where iX is the current amount of votes on that answer. If answer is not in this list, answer has 0 votes
	},
	bIVoted,
	voters = {}	-- List of players BTags
}

-- Polls each have "unique" IDs composed like so: "PlayerGUIDXXXXXXX" where "XXXXXXX" is a random number between 1000000 and 9999999 (not really unique, but close enough)
]]


Cerberus_HookThisFile();

function UpdatePollData(newPollData)

	g_pollCraftData.savedPollsData[newPollData.sPollGUID] = newPollData;	-- TEMP
end

function AddPollDataToMemory(pollData)

	local sPollGUID = pollData.sPollGUID;

	if g_pollCraftData.savedPollsData[sPollGUID] ~= nil then
		UpdatePollData(pollData);
	else
		g_pollCraftData.savedPollsData[sPollGUID] = pollData;
		g_pollCraftData.savedPollsGUIDs[sPollGUID] = true;
	end

	RequestPollsListsUpdate();
end

function RemovePollDataFromMemory(sPollGUID)
	if g_pollCraftData.savedPollsData[sPollGUID] == nil then
		return;
	end

	g_pollCraftData.savedPollsData[sPollGUID] = nil;
	g_pollCraftData.savedPollsGUIDs[sPollGUID] = nil;

	RequestPollsListsUpdate();
end

function GetPollData(sPollGUID)
	return g_pollCraftData.savedPollsData[sPollGUID];
end

function GetAllPollsGUID()
	return g_pollCraftData.savedPollsGUIDs;
end

function GetAllPolls()
	return g_pollCraftData.savedPollsData;
end

function IAlreadyVotedForThisPoll(sPollGUID)
	return g_pollCraftData.savedPollsData[sPollGUID] ~= nil and g_pollCraftData.savedPollsData[sPollGUID].bIVoted;
end


function RegisterVote(voteData)

	local sPollGUID = voteData.sPollGUID;
	local pollData = GetPollData(sPollGUID);

	local pollAnswers = pollData.answers;
	for i = 1, #voteData.newAnswers do
		table.insert(pollAnswers, voteData.newAnswers[i]);
	end
	g_pollCraftData.savedPollsData[sPollGUID].answers = pollAnswers;

	g_pollCraftData.savedPollsData[sPollGUID].voters = g_pollCraftData.savedPollsData[sPollGUID].voters or {};
	table.insert(g_pollCraftData.savedPollsData[sPollGUID].voters, voteData.sVoterBTag);

	local pollResults = pollData.results or {};
	for i = 1, #voteData.vote do
		local sCurrentVoteGUID = voteData.vote[i];
		if pollResults[sCurrentVoteGUID] == nil then
			pollResults[sCurrentVoteGUID] = 0;
		end
		pollResults[sCurrentVoteGUID] = pollResults[sCurrentVoteGUID] + 1;
	end
	g_pollCraftData.savedPollsData[sPollGUID].results = pollResults;
end

function RegisterResults(resultsData)

	local sPollGUID = resultsData.sPollGUID;

	if g_pollCraftData.savedPollsData[sPollGUID] == nil then
		g_pollCraftData.savedPollsData[sPollGUID] = {};
	end
	g_pollCraftData.savedPollsData[sPollGUID].answers = resultsData.pollAnswers;
	g_pollCraftData.savedPollsData[sPollGUID].results = resultsData.results;
end
