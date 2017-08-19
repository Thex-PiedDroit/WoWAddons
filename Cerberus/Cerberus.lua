
local cCerberusTextColour = "ffc42727";
local sCerberusPrefix = "|c" .. cCerberusTextColour .. "Cerberus: |r"
function Cerberus_Error(sMessage)
	error(sCerberusPrefix .. sMessage, 3);
end


g_cerberus = g_cerberus or {};

local sCurrentlyLoadingAddonName = nil;

local function GetCallingLine(bFromRegistration)
	local sCallingLine = debugstack((bFromRegistration and 4) or 3);
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

_G["Cerberus_HookThisFile"] = function(bFromRegistration)

	local iLevel = (bFromRegistration and 3) or 2;

	if getfenv(iLevel) == proxyTable then
		Cerberus_Error("Cerberus: Trying to hook file a second time.");

	elseif string.find(GetCallingLine(bFromRegistration), "in main chunk") == nil then
		Cerberus_Error("Cerberus: Trying to call HookThisFile() somewhere else than global scope. Please place the function call at the beginning of your file, and not in a function.");

	else
		setfenv(iLevel, proxyTable);
	end
end


local function InitProxyTable()

	setmetatable(proxyTable,
	{
		__newindex = function(_, sKey, value)
			if g_cerberus[sCurrentlyLoadingAddonName].savedVariables[sKey] == nil then
				g_cerberus[sCurrentlyLoadingAddonName][sKey] = value;
			else
				_G[sKey] = value;
			end
		end,

		__index = function(_, sKey)
			return g_cerberus[sCurrentlyLoadingAddonName][sKey] or _G[sKey];
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
