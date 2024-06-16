
--[[
		CERBERUS

	This tool helps with addons making by allowing the users to put functions and variables into the global scope without
	having to worry about taint and naming conflicts with other addons.

	Cerberus will "pick up" everything that is put in the global scope and store it in the g_cerberus[sAddonName] table,
	which will then be used as a fake _G table.
	The goal is to avoid having to manually put everything in a global object, and having to put "self" before every
	function or variable call.
]]--


local cCerberusTextColour = "ffc42727";
local sCerberusPrefix = "|c" .. cCerberusTextColour .. "Cerberus: |r"
function Cerberus_Error(sMessage)
	error(sCerberusPrefix .. sMessage, 3);
end


g_cerberus = g_cerberus or {};

local sCurrentlyLoadingAddonName = nil;

local function GetCallingLine(bFromRegistration)

	return debugstack((bFromRegistration and 4) or 3);
end

_G["Cerberus_HookThisFile"] = function(bFromRegistration)

	local iLevel = (bFromRegistration and 3) or 2;

	if getfenv(iLevel) == g_cerberus[sCurrentlyLoadingAddonName] then
		Cerberus_Error("Cerberus: Trying to hook file a second time.");

	elseif string.find(GetCallingLine(bFromRegistration), "in main chunk") == nil then
		Cerberus_Error("Cerberus: Trying to call HookThisFile() somewhere else than global scope. Please place the function call at the beginning of your file, and not in a function.");

	else
		setfenv(iLevel, g_cerberus[sCurrentlyLoadingAddonName]);
	end
end


local function InitProxyTable()

	setmetatable(g_cerberus[sCurrentlyLoadingAddonName],
	{
		__newindex = function(_, sKey, value)
			if g_cerberus[sCurrentlyLoadingAddonName].savedVariables[sKey] == nil then
				rawset(g_cerberus[sCurrentlyLoadingAddonName], sKey, value);
			else
				_G[sKey] = value;
			end
		end,

		__index = function(_, sKey)
			local value = _G[sKey];
			if g_cerberus[sCurrentlyLoadingAddonName].savedVariables[sKey] == nil then
				rawset(g_cerberus[sCurrentlyLoadingAddonName], sKey, value);
			end
			return value;
		end
	});
end

g_cerberus.RegisterAddon = function(sAddonName, savedVariablesNames)

	if sCurrentlyLoadingAddonName ~= nil then
		Cerberus_Error("Trying to initialize addon " .. sAddonName .. " but Cerberus has already been initialized this session with addon name " .. sCurrentlyLoadingAddonName .. ".");
		return;
	elseif g_cerberus[sAddonName] ~= nil then
		Cerberus_Error("Attempting to register addon which has already been registered (" .. sAddonName .. "). Try with a different addon name, or a more specific one.");
		return;
	end

	sCurrentlyLoadingAddonName = sAddonName;
	g_cerberus[sAddonName] = {};
	g_cerberus[sAddonName].savedVariables = {};

	if savedVariablesNames ~= nil then
		for i = 1, #savedVariablesNames do
			local currentSavedVariableName = savedVariablesNames[i];
			g_cerberus[sAddonName].savedVariables[currentSavedVariableName] = true;
		end
	end

	InitProxyTable();
	g_cerberus[sCurrentlyLoadingAddonName].cerberus_G = g_cerberus[sCurrentlyLoadingAddonName];
	Cerberus_HookThisFile(true);
end

g_cerberus.RegisterAddonModule = function(sParentAddonName)

	if g_cerberus[sParentAddonName] == nil then
		Cerberus_Error("Parent addon does not seem to exist in Cerberus. Make sure the parent addon is listed as a dependency in your module's toc file and that it is using Cerberus.");
		return;
	end

	sCurrentlyLoadingAddonName = sParentAddonName;
	InitProxyTable();
	Cerberus_HookThisFile(true);
end
