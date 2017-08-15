

local cCerberusTextColour = "ffc42727";
local sCerberusPrefix = "|c" .. cCerberusTextColour .. "Cerberus: |r"
function Cerberus_Error(sMessage)
	error(sCerberusPrefix .. sMessage, 3);
end


g_cerberus = g_cerberus or {};
local sCurrentAddonName = nil;
local function GetCurrentAddonName()
	return sCurrentAddonName;
end
g_cerberus.Get_G = function()
	return g_cerberus[GetCurrentAddonName()];	-- Using getter function to avoid conflicts between mods
end

local function GetCallingLine()
	local sCallingLine = debugstack(3);
	local iAddonFolderPos = string.find(sCallingLine, "AddOns");
	local iEndOfLinePos = string.find(sCallingLine, "\n");
	sCallingLine = string.sub(sCallingLine, iAddonFolderPos, iEndOfLinePos);
	sCallingLine = strtrim(sCallingLine, "AddOns\\");

	return sCallingLine;
end

local proxyTable = {};
local function GetProxyTable()
	return proxyTable;
end

g_cerberus.HookThisFile = g_cerberus.HookThisFile or function()

	local localProxyTable = GetProxyTable();

	if getfenv(2) == localProxyTable then
		Cerberus_Error("Cerberus: Trying to hook file a second time.");

	elseif string.find(GetCallingLine(), "in main chunk") == nil then
		Cerberus_Error("Cerberus: Trying to call HookThisFile() somewhere else than global scope. Please place the function call at the beginning of your file, and not in a function.");

	else
		setfenv(2, localProxyTable);
	end
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

	setmetatable(proxyTable,
	{
		__newindex = function(_, key, value)
			g_cerberus.Get_G()[key] = value;
		end,

		__index = function(_, key)
			return g_cerberus.Get_G()[key] or _G[key];
		end
	});
end
