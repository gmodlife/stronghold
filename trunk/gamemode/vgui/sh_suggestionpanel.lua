--[[-------------------------------------------------------

Fight to Survive: Stronghold by RoaringCow, TehBigA is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.

This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or send a letter to Creative Commons, 
444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

---------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()
	self.CBox1 = vgui.Create( "DCheckBoxLabel", self )
	self.CBox1:SetText( "Is this a bug?" )
	self.CBox1:SizeToContents()	
	
	self.TBox = vgui.Create( "DTextEntry", self )
	self.TBox:SetMultiline( true )
	
	self.InfoLbl = vgui.Create( "DLabel", self )
	self.InfoLbl:SetExpensiveShadow( 1, Color( 0, 0, 0, 190 ) )
	self.InfoLbl:SetFont( "Trebuchet19" )
	self.InfoLbl:SetText( "All reports are moderated." )
	self.InfoLbl:SizeToContents()
	
	self.SubmitBtn = vgui.Create( "DButton", self )
	self.SubmitBtn:SetText( "Submit!" )
	self.SubmitBtn.DoClick = function()
		if self.TBox:GetValue() == "" then
			surface.PlaySound( "buttons/button11.wav" )
			
			self.InfoLbl:SetText( "Type something first!" )
			self.InfoLbl:SizeToContents()
			
			return
		end
		
		self:Submit( LocalPlayer(), self.TBox:GetValue() )
	end
end

function PANEL:PerformLayout()
	self.CBox1:SetPos( self:GetWide() -100, 5 )
	self.TBox:SetPos( 5, 27 )
	self.InfoLbl:SetPos( 5, self:GetTall() -24 )
	self.SubmitBtn:SetPos( self:GetWide() -105, self:GetTall() -25 )
	
	self.TBox:SetSize( self:GetWide() -10, self:GetTall() -55 )
	self.SubmitBtn:SetSize( 100, 25 )
end

function PANEL:ClearAll()
	self.TBox:SetText( "" )
	self.CBox1:SetValue( 0 )
	
	self.InfoLbl:SetText( "All reports are moderated." )
	self.InfoLbl:SizeToContents()
end

function PANEL:Submit( entPlayer, strText )
	local formmated_string = "Suggestion by ".. entPlayer:Name().. " || ".. entPlayer:SteamID().. " on ".. os.date().. "\n".. strText
	local bBug = tobool( self.CBox1:GetChecked() )
	
	self.DStreamTempID = datastream.StreamToServer( "STRONGHOLD_suggestion", { formmated_string, bBug } )
end

vgui.Register( "sh_suggestionpanel", PANEL, "Panel" )

local function suggestioncallback( bf_read )
	local pan = GAMEMODE.HelpFrame.SuggestionPanel
	local accepted = bf_read:ReadBool()
	
	if bf_read:ReadString() == "true" then
		surface.PlaySound( "buttons/button11.wav" )
		
		pan.InfoLbl:SetText( "You have exceeded the max character limit! (500)" )
		pan.InfoLbl:SizeToContents()		
	elseif accepted then
		surface.PlaySound( "buttons/button9.wav" )
		
		pan.InfoLbl:SetText( "Sent, thanks for your feedback!" )
		pan.InfoLbl:SizeToContents()
		pan.CBox1:SetValue( 0 )
		pan.TBox:SetText( "" )
	else
		surface.PlaySound( "buttons/button11.wav" )
		
		local len = math.floor( bf_read:ReadFloat() )
		pan.InfoLbl:SetText( "You must wait ".. len.. " more seconds before submitting again!" )
		pan.InfoLbl:SizeToContents()
	end
end
usermessage.Hook( "sh_suggestioncallback", suggestioncallback )