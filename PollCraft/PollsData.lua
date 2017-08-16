
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


local currentPollsInMemory = {};
local currentPollsGUID = {};

function UpdatePollData(newPollData)

	currentPollsInMemory[newPollData.sPollGUID] = newPollData;	-- TEMP
end

function AddPollDataToMemory(pollData)

	local sPollGUID = pollData.sPollGUID;

	if currentPollsInMemory[sPollGUID] ~= nil then
		UpdatePollData(pollData);
	else
		currentPollsInMemory[sPollGUID] = pollData;
		currentPollsGUID[sPollGUID] = true;
	end

	RequestPollsListsUpdate();
end

function RemovePollDataFromMemory(sPollGUID)
	if currentPollsInMemory[sPollGUID] == nil then
		return;
	end

	currentPollsInMemory[sPollGUID] = nil;
	currentPollsGUID[sPollGUID] = nil;

	RequestPollsListsUpdate();
end

function GetPollData(sPollGUID)
	return currentPollsInMemory[sPollGUID];
end

function GetAllPollsGUID()
	return currentPollsGUID;
end

function GetAllPolls()
	return currentPollsInMemory;
end


function RegisterVote(voteData)

	local sPollGUID = voteData.sPollGUID;
	local pollData = currentPollsInMemory[sPollGUID];

	local pollAnswers = pollData.answers;
	for i = 1, #voteData.newAnswers do
		table.insert(pollAnswers, voteData.newAnswers[i]);
	end
	currentPollsInMemory[sPollGUID].answers = pollAnswers;

	local voterBTag = voteData.sVoterBTag;
	if voterBTag == MyBTag() then
		currentPollsInMemory[sPollGUID].bIVoted = true;
		TickVoteForPoll(sPollGUID, true, pollData.sPollMasterFullName == Me());
	end
	currentPollsInMemory[sPollGUID].voters = currentPollsInMemory[sPollGUID].voters or {};
	table.insert(currentPollsInMemory[sPollGUID].voters, voterBTag);

	local pollResults = pollData.results or {};
	for i = 1, #voteData.vote do
		local sCurrentVoteGUID = voteData.vote[i];
		if pollResults[sCurrentVoteGUID] == nil then
			pollResults[sCurrentVoteGUID] = 0;
		end
		pollResults[sCurrentVoteGUID] = pollResults[sCurrentVoteGUID] + 1;
	end
	currentPollsInMemory[sPollGUID].results = pollResults;
end

function RegisterResults(resultsData)

	local sPollGUID = resultsData.sPollGUID;

	if currentPollsInMemory[sPollGUID] == nil then
		currentPollsInMemory[sPollGUID] = {};
	end
	currentPollsInMemory[sPollGUID].answers = resultsData.pollAnswers;
	currentPollsInMemory[sPollGUID].results = resultsData.results;
end
