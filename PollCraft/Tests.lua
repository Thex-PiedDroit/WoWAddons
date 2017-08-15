
Cerberus_HookThisFile();

if not DEBUG_VERSION then
	return;
end


local function GenerateTestPollGUID()
	return "TEST_POLL_" .. MyGUID() .. tostring(math.random(1000000, 9999999));
end

local globalTestPollData =
{
	pollGUID = GenerateTestPollGUID(),
	pollMasterFullName = Me(),
	pollMasterRealm = MyRealm(),
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

local randomPollMastersNames =
{
	"Giovanni", "Gwiratha", "Falenidd", "Galeamos", "Morlune", "Miriawan", "Higo", "Woep", "Yilitha", "Erirekor", "Eledon", "Vulcun", "Edardo", "Shal", "Dante", "Aeratha", "Laralilath", "Lendaseth", "Qerrahar", "Sevardomas", "Geiwyr", "Geron", "Erlwin", "Galirakath", "Glerind", "Priranidd", "Xantis", "Trieron", "Gwoash", "Poich", "Zigog", "Trigo"
};
local randomRealms =
{
	"Aerie Peak", "Anvilmar", "Arathor", "Antonidas", "Azuremyst", "Baelgun", "Blade's Edge", "Bladefist", "Bronzebeard", "Cenarius", "Darrowmere", "Draenor", "Dragonblight", "Echo Isles", "Galakrond", "Gnomeregan", "Hyjal", "Kilrogg", "Korialstrasz", "Lightbringer", "Misha", "Moonrunner", "Nordrassil", "Proudmoore", "Shadowsong", "Shu'Halo", "Silvermoon", "Skywall", "Suramar", "Uldum", "Uther", "Velen", "Windrunner"
};
local function GenerateRandomPollMaster()
	local realm = randomRealms[math.random(1, #randomRealms)];
	local name = randomPollMastersNames[math.random(1, #randomPollMastersNames)] .. realm;
	return name, realm;
end

local function CreateTestPollData(mine, question, answersCount, multiVotes, allowNewAnswers)

	local pollMasterFullName = nil;
	local pollMasterRealm = nil;
	if mine then
		pollMasterFullName = Me();
		pollMasterRealm = MyRealm();
	else
		pollMasterFullName, pollMasterRealm = GenerateRandomPollMaster();
	end

	local testPollData =
	{
		pollGUID = GenerateTestPollGUID(),
		pollMasterFullName = pollMasterFullName,
		pollMasterRealm = pollMasterRealm,
		pollType = "RAID",
		multiVotes = multiVotes,
		allowNewAnswers = allowNewAnswers,
		question = question,
		answers = {}
	};

	for i = 1, answersCount do
		local answer =
		{
			text = "Answer " .. tostring(i),
			GUID = tostring(i)
		}
		table.insert(testPollData.answers, answer);
	end

	return testPollData;
end

function TestCreateSimplePoll()

	SendPollData(testPollData);
end

function TestAddSomePollsToData()

	local pollDataTest1 = CreateTestPollData(true, "First question", 3, false, true);
	local pollDataTest2 = CreateTestPollData(false, "Third question", 6, true, true);
	local pollDataTest3 = CreateTestPollData(false, "Fourth question", 2, true, false);
	local pollDataTest4 = CreateTestPollData(false, "Fourth question", 2, true, false);
	local pollDataTest5 = CreateTestPollData(false, "Fourth question", 2, true, false);
	local pollDataTest6 = CreateTestPollData(false, "Fourth question", 2, true, false);
	local pollDataTest7 = CreateTestPollData(false, "Fourth question", 2, true, false);
	local pollDataTest8 = CreateTestPollData(false, "Fourth question", 2, true, false);

	AddPollDataToMemory(pollDataTest1);
	AddPollDataToMemory(globalTestPollData);
	AddPollDataToMemory(pollDataTest2);
	AddPollDataToMemory(pollDataTest3);
	AddPollDataToMemory(pollDataTest4);
	AddPollDataToMemory(pollDataTest5);
	AddPollDataToMemory(pollDataTest6);
	AddPollDataToMemory(pollDataTest7);
	AddPollDataToMemory(pollDataTest8);
end

function TestOneSimpleVote()

	TestCreateSimplePoll();

	local voteData =
	{
		pollGUID = globalTestPollData.pollGUID,
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
		pollGUID = globalTestPollData.pollGUID,
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
