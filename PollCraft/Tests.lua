
Cerberus_HookThisFile();

if not DEBUG_VERSION then
	return;
end

local iTestPollsCount = 0;
local function GenerateTestPollGUID()
	iTestPollsCount = iTestPollsCount + 1;
	return "TEST_POLL_" .. tostring(iTestPollsCount);
end

local globalTestPollData =
{
	sPollGUID = GenerateTestPollGUID(),
	sPollMasterFullName = Me(),
	sPollMasterRealm = MyRealm(),
	sPollType = "RAID",
	bMultiVotes = false,
	bAllowNewAnswers = false,
	sQuestion = "qEDGTEgzergrzegzrgh zregyzer sihgoz zrziog zrghzo rzgv zpzrosd zreoigvzrô gvze r^gzreneô zeg ôzg ozeg ozgoh ozeg zeg zergo ze",
	answers =
	{
		{
			sText = "qEDGTEgzergrzegzrgh zregyzer sihgoz zrziog zrghzo rzgv zpzrosd zreoigvzrô gvze r^gzreneô zeg ôzg ozeg ozgoh ozeg zeg zergo ze",
			sGUID = "1"
		},
		{
			sText = "Answer two",
			sGUID = "2"
		},
		{
			sText = "Answer three",
			sGUID = "3"
		},
		{
			sText = "Answer four",
			sGUID = "4"
		},
		{
			sText = "Answer five",
			sGUID = "5"
		},
		{
			sText = "Answer six",
			sGUID = "6"
		},
		{
			sText = "Answer seven",
			sGUID = "7"
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
	local sRealm = randomRealms[math.random(1, #randomRealms)];
	local sName = randomPollMastersNames[math.random(1, #randomPollMastersNames)] .. sRealm;
	return sName, sRealm;
end

local function CreateTestPollData(bMine, sQuestion, iAnswersCount, bMultiVotes, bAllowNewAnswers)

	local sPollMasterFullName = nil;
	local sPollMasterRealm = nil;
	if bMine then
		sPollMasterFullName = Me();
		sPollMasterRealm = MyRealm();
	else
		sPollMasterFullName, sPollMasterRealm = GenerateRandomPollMaster();
	end

	local testPollData =
	{
		sPollGUID = GenerateTestPollGUID(),
		sPollMasterFullName = sPollMasterFullName,
		sPollMasterRealm = sPollMasterRealm,
		sPollType = "RAID",
		bMultiVotes = bMultiVotes,
		bAllowNewAnswers = bAllowNewAnswers,
		sQuestion = sQuestion,
		answers = {}
	};

	for i = 1, iAnswersCount do
		local answer =
		{
			sText = "Answer " .. tostring(i),
			sGUID = tostring(i)
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
	local pollDataTest4 = CreateTestPollData(false, "Fifth question", 2, true, false);
	local pollDataTest5 = CreateTestPollData(false, "Sixth question", 2, true, false);
	local pollDataTest6 = CreateTestPollData(false, "Seventh question", 2, true, false);
	local pollDataTest7 = CreateTestPollData(false, "Eighth question", 2, true, false);
	local pollDataTest8 = CreateTestPollData(false, "Ninth question", 2, true, false);

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
		sPollGUID = globalTestPollData.sPollGUID,
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
		sPollGUID = globalTestPollData.sPollGUID,
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
