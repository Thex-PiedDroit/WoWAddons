

local testPollData =
{
	pollGUID = "TEST_POLL",
	pollMasterFullName = PollCraft_Me(),
	pollMasterRealm = PollCraft_MyRealm(),
	pollType = "RAID",
	multiVotes = false,
	allowNewAnswers = false,
	question = "qEDGTEgzergrzegzrgh zregyzer sihgoz zrziog zrghzo rzgv zpzrosd zreoigvzrô gvze r^gzreneô zeg ôzg ozeg ozgoh ozeg zeg zergo ze",
	answers =
	{
		{
			text = "qEDGTEgzergrzegzrgh zregyzer sihgoz zrziog zrghzo rzgv zpzrosd zreoigvzrô gvze r^gzreneô zeg ôzg ozeg ozgoh ozeg zeg zergo ze",
			GUID = "1"
		},
		{
			text = "Answer two",
			GUID = "2"
		},
		{
			text = "Answer three",
			GUID = "3"
		},
		{
			text = "Answer four",
			GUID = "4"
		},
		{
			text = "Answer five",
			GUID = "5"
		},
		{
			text = "Answer six",
			GUID = "6"
		},
		{
			text = "Answer seven",
			GUID = "7"
		},
	}
}

function TestCreateSimplePoll()

	SendPollData(testPollData);
end

function TestOneSimpleVote()

	TestCreateSimplePoll();

	local voteData =
	{
		pollGUID = testPollData.pollGUID,
		newAnswers = {},
		vote =
		{
			"3"
		}
	};
	ReceiveVote(voteData);
end

function TestSomeVotes()

	TestCreateSimplePoll();

	local voteData =
	{
		pollGUID = testPollData.pollGUID,
		newAnswers =
		{
			{
				text = "Hello",
				GUID = "Kriss-Draenor1"
			}
		},
		vote =
		{
			"3",
			"5",
			"6",
			"Kriss-Draenor1"
		}
	};
	ReceiveVote(voteData);
	voteData.newAnswers =
	{
		{
			text = "TEST LOL",
			GUID = "Derrek-Draenor1"
		},
		{
			text = "TEST 2 MDR",
			GUID = "Derrek-Draenor2"
		}
	};
	voteData.vote =
	{
		"2",
		"3",
		"7",
		"Derrek-Draenor1",
		"Derrek-Draenor2",
		"Kriss-Draenor1"
	};
	ReceiveVote(voteData);
	voteData.newAnswers = {};
	voteData.vote =
	{
		"2",
		"3"
	};
	ReceiveVote(voteData);
end
