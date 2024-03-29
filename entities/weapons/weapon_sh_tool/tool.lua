ToolObj = {}

include( 'tool_object.lua' )

function ToolObj:Create()
	local o = {}
	setmetatable( o, self )
	self.__index = self
	
	o.Mode				= nil
	o.SWEP				= nil
	o.Owner				= nil
	o.ClientConVar		= {}
	o.ServerConVar		= {}
	o.Objects			= {}
	o.Stage				= 0
	o.Message			= "start"
	o.LastMessage		= 0
	o.AllowedCVar		= 0
	return o
end

function ToolObj:CreateConVars()
	local mode = self:GetMode()

	if CLIENT then
		for cvar, default in pairs( self.ClientConVar ) do
			CreateClientConVar( mode.."_"..cvar, default, true, true )
		end
		return
	end
	
	// Note: I changed this from replicated because replicated convars don't work
	// when they're created via Lua.
	if SERVER then
		self.AllowedCVar = CreateConVar( "toolmode_allow_"..mode, 1, FCVAR_NOTIFY )
	end
end

function ToolObj:GetServerInfo( property )
	local mode = self:GetMode()
	return GetConVarString( mode.."_"..property )
end

function ToolObj:GetClientInfo( property )
	local mode = self:GetMode()
	return self:GetOwner():GetInfo( mode.."_"..property )
end

function ToolObj:GetClientNumber( property, default )
	default = default or 0
	local mode = self:GetMode()
	return self:GetOwner():GetInfoNum( mode.."_"..property, default )
end

function ToolObj:Allowed()
	if CLIENT then return true end
	return self.AllowedCVar:GetBool()
end

// Now for all the ToolObj redirects
function ToolObj:GetMode() return self.Mode end
function ToolObj:GetSWEP() return self.SWEP end
function ToolObj:GetOwner() return self:GetSWEP().Owner or self.Owner end
function ToolObj:GetWeapon() return self:GetSWEP().Weapon or self.Weapon end
function ToolObj:LeftClick() return false end
function ToolObj:RightClick() return false end
function ToolObj:Reload() self:ClearObjects() end
function ToolObj:Holster() self:ReleaseGhostEntity() return true end
function ToolObj:Think() self:ReleaseGhostEntity() end

/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function ToolObj:CheckObjects()
	for k, v in pairs(self.Objects) do
		if !v.Ent:IsWorld() && !v.Ent:IsValid() then
			self:ClearObjects()
		end		
	end
end

local toolmodes = file.FindInLua( SWEP.Folder.."/stools/*.lua" )
for key, val in pairs(toolmodes) do
	local char1, char2, toolmode = string.find( val, "([%w_]*)\.lua" )

	TOOL = ToolObj:Create()
	TOOL.Mode = toolmode

	AddCSLuaFile( "stools/"..val )
	include( "stools/"..val )

	TOOL:CreateConVars()
	SWEP.Tool[toolmode] = TOOL

	TOOL = nil
end

ToolObj = nil

if CLIENT then
	// Keep the tool list handy
	local TOOLS_LIST = SWEP.Tool
	
	// Add the STOOLS to the tool menu
	local function AddSToolsToMenu()
		for ToolName, TOOL in pairs(TOOLS_LIST) do
			if ( TOOL.AddToMenu != false ) then
				--[[spawnmenu.AddToolMenuOption( TOOL.Tab or "Main",
												TOOL.Category or "New Category", 
												ToolName, 
												TOOL.Name or "#"..ToolName, 
												TOOL.Command or "gmod_tool "..ToolName, 
												TOOL.ConfigName or ToolName,
												TOOL.BuildCPanel )]]
				
			end
		end
	end
	--hook.Add( "PopulateToolMenu", "AddSToolsToMenu", AddSToolsToMenu )
end
