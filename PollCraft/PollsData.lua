
--[[
pollData =
{
	pollGUID,
	pollMasterFullName,
	pollMasterRealm,
	pollType,
	multiVotes,
	allowNewAnswers,
	question,	-- As text
	answers = {}
	results =
	{
		[answerGUID] = X,	-- Where X is the current amount of votes on that answer. If answer is not in this list, answer has 0 votes
	}
}

-- Polls each have "unique" IDs composed like so: "PlayerGUIDXXXXXXX" where "XXXXXXX" is a random number between 1000000 and 9999999 (not really unique, but close enough)
]]

g_cerberus.HookThisFile();


local currentPollsInMemory = {};

function UpdatePollData(newPollData)

	currentPollsInMemory[newPollData.pollGUID] = newPollData;	-- TEMP
end

function AddPollDataToMemory(pollData)

	local pollGUID = pollData.pollGUID;

	if currentPollsInMemory[pollGUID] ~= nil then
		UpdatePollData(pollData);
	else
		currentPollsInMemory[pollGUID] = pollData;
	end
end

function RemovePollDataFromMemory(pollGUID)
	currentPollsInMemory[pollGUID] = nil;
end

function GetPollData(pollGUID)
	return currentPollsInMemory[pollGUID];
end


function RegisterVote(voteData)

	local pollData = currentPollsInMemory[voteData.pollGUID];

	local pollAnswers = pollData.answers;
	for i = 1, #voteData.newAnswers do
		table.insert(pollAnswers, voteData.newAnswers[i]);
	end
	currentPollsInMemory[voteData.pollGUID].answers = pollAnswers;

	local pollResults = pollData.results or {};
	for i = 1, #voteData.vote do
		local currentVoteGUID = voteData.vote[i];
		if pollResults[currentVoteGUID] == nil then
			pollResults[currentVoteGUID] = 0;
		end
		pollResults[currentVoteGUID] = pollResults[currentVoteGUID] + 1;
	end
	currentPollsInMemory[voteData.pollGUID].results = pollResults;
end

function RegisterResults(resultsData)

	local pollGUID = resultsData.pollGUID;

	if currentPollsInMemory[pollGUID] == nil then
		currentPollsInMemory[pollGUID] = {};
	end
	currentPollsInMemory[pollGUID].answers = resultsData.pollAnswers;
	currentPollsInMemory[pollGUID].results = resultsData.results;
end
