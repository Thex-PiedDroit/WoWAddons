
--[[
pollData =
{
	sPollGUID,
	sPollMasterFullName,
	sPollMasterRealm,
	sPollType,
	bMultiVotes,
	bAllowNewAnswers,
	question,	-- As text
	answers = {}
	results =
	{
		[sAnswerGUID] = iX,	-- Where iX is the current amount of votes on that answer. If answer is not in this list, answer has 0 votes
	}
}

-- Polls each have "unique" IDs composed like so: "PlayerGUIDXXXXXXX" where "XXXXXXX" is a random number between 1000000 and 9999999 (not really unique, but close enough)
]]


Cerberus_HookThisFile();


local currentPollsInMemory = {};

function UpdatePollData(newPollData)

	currentPollsInMemory[newPollData.sPollGUID] = newPollData;	-- TEMP
end

function AddPollDataToMemory(pollData)

	local sPollGUID = pollData.sPollGUID;

	if currentPollsInMemory[sPollGUID] ~= nil then
		UpdatePollData(pollData);
	else
		currentPollsInMemory[sPollGUID] = pollData;
	end
end

function RemovePollDataFromMemory(sPollGUID)
	currentPollsInMemory[sPollGUID] = nil;
end

function GetPollData(sPollGUID)
	return currentPollsInMemory[sPollGUID];
end


function RegisterVote(voteData)

	local pollData = currentPollsInMemory[voteData.sPollGUID];

	local pollAnswers = pollData.answers;
	for i = 1, #voteData.newAnswers do
		table.insert(pollAnswers, voteData.newAnswers[i]);
	end
	currentPollsInMemory[voteData.sPollGUID].answers = pollAnswers;

	local pollResults = pollData.results or {};
	for i = 1, #voteData.vote do
		local sCurrentVoteGUID = voteData.vote[i];
		if pollResults[sCurrentVoteGUID] == nil then
			pollResults[sCurrentVoteGUID] = 0;
		end
		pollResults[sCurrentVoteGUID] = pollResults[sCurrentVoteGUID] + 1;
	end
	currentPollsInMemory[voteData.sPollGUID].results = pollResults;
end

function RegisterResults(resultsData)

	local sPollGUID = resultsData.sPollGUID;

	if currentPollsInMemory[sPollGUID] == nil then
		currentPollsInMemory[sPollGUID] = {};
	end
	currentPollsInMemory[sPollGUID].answers = resultsData.pollAnswers;
	currentPollsInMemory[sPollGUID].results = resultsData.results;
end
