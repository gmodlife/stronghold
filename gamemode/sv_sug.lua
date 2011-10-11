--[[-------------------------------------------------------

Fight to Survive: Stronghold by RoaringCow, TehBigA is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.

This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or send a letter to Creative Commons, 
444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

---------------------------------------------------------]]
local sv_Sug = {}

sv_Sug.SuggestionInterval = 20

function sv_Sug.WriteSuggestion( strFileName, strText )
	print( strFileName )
	
	file.Write( "Stronghold/Suggestions/"..strFileName.. ".txt", strText )
end

function sv_Sug.SuggestionHook( pl, handler, id, encoded, decoded )
	if not pl then return end
	if encoded == "" then return end
	local allowed, charlimit = true, false
	
	if pl.sh_lastsubmittime then
		if RealTime() < pl.sh_lastsubmittime then
			allowed = false
		end
	else
		pl.sh_lastsubmittime = 0
	end
	
	if string.len( decoded[1] ) > 500 then
		charlimit = true
	end
	
	umsg.Start( "sh_suggestioncallback", pl )
		umsg.Bool( allowed )
		umsg.String( tostring( charlimit ) )
		umsg.Float( pl.sh_lastsubmittime -RealTime() )
	umsg.End()
	
	if allowed and not charlimit then
		local name
		if decoded[2] then
			name = "Bugs/".. string.gsub( pl:SteamID(), ":", "_" ).. string.gsub( string.gsub( os.date(), "/", "_" ), ":", "-" )
		else
			name = string.gsub( pl:SteamID(), ":", "_" ).. string.gsub( string.gsub( os.date(), "/", "_" ), ":", "-" )
		end
		
		sv_Sug.WriteSuggestion( name, decoded[1] )
		pl.sh_lastsubmittime = RealTime() +sv_Sug.SuggestionInterval
	end
end
datastream.Hook( "STRONGHOLD_suggestion", sv_Sug.SuggestionHook )
