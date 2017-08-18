
local cCerberusTextColour = "ffc42727";
local sCerberusPrefix = "|c" .. cCerberusTextColour .. "Cerberus: |r"
function Cerberus_Error(sMessage)
	error(sCerberusPrefix .. sMessage, 3);
end


g_cerberus = g_cerberus or {};

local sCurrentAddonName = nil;
g_cerberus._G = function()		-- Using getter function to avoid conflicts between mods
	return g_cerberus[sCurrentAddonName];
end

local function GetCallingLine()
	local sCallingLine = debugstack(3);
	local iAddonFolderPos = 1
	local iAddonFolderPos = string.find(sCallingLine, "AddOns\\");
	if iAddonFolderPos == nil then
		iAddonFolderPos = string.find(sCallingLine, "dOns\\");
	end
	local iEndOfLinePos = string.find(sCallingLine, "\n");
	sCallingLine = string.sub(sCallingLine, iAddonFolderPos, iEndOfLinePos);
	sCallingLine = strtrim(sCallingLine, "AddOns\\");

	return sCallingLine;
end

local proxyTable = {};

g_cerberus.HookThisFile = g_cerberus.HookThisFile or function()

	if getfenv(2) == proxyTable then
		Cerberus_Error("Cerberus: Trying to hook file a second time.");

	elseif string.find(GetCallingLine(), "in main chunk") == nil then
		Cerberus_Error("Cerberus: Trying to call HookThisFile() somewhere else than global scope. Please place the function call at the beginning of your file, and not in a function.");

	else
		setfenv(2, proxyTable);
	end
end


local function InitProxyTable()

	setmetatable(proxyTable,
	{
		__newindex = function(_, sKey, value)
			local cerberus_G = g_cerberus._G();
			if cerberus_G.savedVariables[sKey] == nil then
				cerberus_G[sKey] = value;
			else
				_G[sKey] = value;
			end
		end,

		__index = function(_, sKey)
			return g_cerberus._G()[sKey] or _G[sKey];
		end
	});
end

g_cerberus.RegisterAddon = function(sAddonName)

	if sCurrentAddonName ~= nil then
		Cerberus_Error("Trying to initialize addon " .. sAddonName .. " but Cerberus has already been initialized this session with addon name " .. sCurrentAddonName .. ".");
		return;
	elseif g_cerberus[sAddonName] ~= nil then
		Cerberus_Error("Attempting to register addon which has already been registered (" .. sAddonName .. "). Try with a different addon name, or a more specific one.");
		return;
	end

	sCurrentAddonName = sAddonName;
	g_cerberus[sAddonName] = {};
	g_cerberus[sAddonName].savedVariables = {};
	InitProxyTable();
end

g_cerberus.RegisterAddonModule = function(sParentAddonName)

	if g_cerberus[sParentAddonName] == nil then
		Cerberus_Error("Parent addon does not seem to exist in Cerberus. Make sure the parent addon is listed as a dependency in your module's toc file and that it is using Cerberus.");
		return;
	end

	sCurrentAddonName = sParentAddonName;
	InitProxyTable();
end

g_cerberus.RegisterSavedVariables = function(savedVariablesNames)

	for i = 1, #savedVariablesNames do
		local currentSavedVariableName = savedVariablesNames[i];
		g_cerberus[sCurrentAddonName].savedVariables[currentSavedVariableName] = true;
	end
end
