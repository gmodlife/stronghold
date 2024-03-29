--[[-------------------------------------------------------

Fight to Survive: Stronghold by RoaringCow, TehBigA is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.

This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or send a letter to Creative Commons, 
444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

---------------------------------------------------------]]
-- Lets not FORCE it, just use it where it is suppose to
--function GM:ForceDermaSkin()
--	return "stronghold"
--end

-- SKIN       ----------------------------------------------------------------------------------------------------

local SKIN = {}

local TEX_GRADIENT = surface.GetTextureID( "gui/gradient_down" )
local TEX_GRADIENT_UP = surface.GetTextureID( "gui/gradient_up" )
local TEX_GRADIENT_RIGHT = surface.GetTextureID( "vgui/gradient-r" )
local MAT_BLUR = Material( "pp/blurscreen" )

SKIN.PrintName 		= "STRONGHOLD Skin"
SKIN.Author 		= "TehBigA"
SKIN.DermaVersion	= 1

SKIN.bg_color 					= Color( 20, 20, 20, 120 )
SKIN.bg_color_sleep 			= Color( 50, 50, 50, 120 )
SKIN.bg_color_dark				= Color( 0, 0, 0, 140 )
SKIN.bg_color_bright			= Color( 70, 70, 70, 140 )

SKIN.bg_alt1 					= Color( 10, 10, 10, 120 )
SKIN.bg_alt2 					= Color( 12, 12, 12, 120 )

SKIN.panel_transback			= Color( 180, 180, 180, 50 )

SKIN.colPropertySheet 			= Color( 100, 100, 100, 140 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabInactive				= Color( 80,80, 80, 120 )
SKIN.colTabShadow				= Color( 0, 0, 0, 140 )
SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
SKIN.colTabTextInactive			= Color( 200, 200, 200, 100 )

SKIN.colButtonText				= Color( 255, 255, 255, 255 )
SKIN.colButtonTextDisabled		= Color( 255, 255, 255, 55 )
SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )

SKIN.colTextEntryBG				= Color( 255, 255, 255, 200 )
SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

SKIN.listview_hover				= Color( 60, 102, 132, 255 )
SKIN.listview_selected			= Color( 100, 170, 220, 255 )

-- GENERIC    ----------------------------------------------------------------------------------------------------

local SCR_H_DIV_4 = nil
function SKIN:DrawGenericBackground( x, y, w, h, color, skip_top )
	if !SCR_H_DIV_4 then SCR_H_DIV_4 = ScrH() * 0.25 end

	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( 0, 0, 0, 120 )
	if !skip_top then surface.DrawRect( x, y, w-1, 1 ) end
	surface.DrawRect( x, y, 1, h-1 )
	surface.DrawRect( x, y+h-1, w, 1 )
	surface.DrawRect( x+w-1, y, 1, h-1 )
	
	surface.SetDrawColor( 200, 200, 200, 120 )
	if !skip_top then surface.DrawRect( x+1, y+1, w-2, 1 ) end
	surface.DrawRect( x+1, y+1, 1, h-2 )
	surface.DrawRect( x+1, y+h-2, w-2, 1 )
	surface.DrawRect( x+w-2, y+1, 1, h-2 )
	
	local scale = math.Clamp( h/SCR_H_DIV_4, 0, 1 )
	surface.SetDrawColor( 0, 0, 0, 80+80*scale ) -- Smaller it is the lighter
	surface.SetTexture( TEX_GRADIENT )
	surface.DrawTexturedRect( x+2, y+2, w-4, h*0.75 )
end

function SKIN:DrawFlippedBackground( x, y, w, h, color, skip_top )
	if !SCR_H_DIV_4 then SCR_H_DIV_4 = ScrH() * 0.25 end

	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( 0, 0, 0, 120 )
	if !skip_top then surface.DrawRect( x, y, w-1, 1 ) end
	surface.DrawRect( x, y, 1, h-1 )
	surface.DrawRect( x, y+h-1, w, 1 )
	surface.DrawRect( x+w-1, y, 1, h-1 )
	
	surface.SetDrawColor( 200, 200, 200, 120 )
	if !skip_top then surface.DrawRect( x+1, y+1, w-2, 1 ) end
	surface.DrawRect( x+1, y+1, 1, h-2 )
	surface.DrawRect( x+1, y+h-2, w-2, 1 )
	surface.DrawRect( x+w-2, y+1, 1, h-2 )
	
	local scale = math.Clamp( h/SCR_H_DIV_4, 0, 1 )
	surface.SetDrawColor( 0, 0, 0, 80+80*scale ) -- Smaller it is the lighter
	surface.SetTexture( TEX_GRADIENT_UP )
	surface.DrawTexturedRect( x+2, y+h*0.25-2, w-4, h*0.75 )
end

function SKIN:DrawRightBackground( x, y, w, h, color )
	if !SCR_H_DIV_4 then SCR_H_DIV_4 = ScrH() * 0.25 end

	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( 0, 0, 0, 120 )
	surface.DrawRect( x, y, w-1, 1 )
	surface.DrawRect( x, y, 1, h-1 )
	surface.DrawRect( x, y+h-1, w, 1 )
	surface.DrawRect( x+w-1, y, 1, h-1 )
	
	surface.SetDrawColor( 200, 200, 200, 120 )
	surface.DrawRect( x+1, y+1, w-2, 1 )
	surface.DrawRect( x+1, y+1, 1, h-2 )
	surface.DrawRect( x+1, y+h-2, w-2, 1 )
	surface.DrawRect( x+w-2, y+1, 1, h-2 )
	
	local scale = math.Clamp( h/SCR_H_DIV_4, 0, 1 )
	surface.SetDrawColor( 0, 0, 0, 80+80*scale ) -- Smaller it is the lighter
	surface.SetTexture( TEX_GRADIENT_RIGHT )
	surface.DrawTexturedRect( x+w*0.25-2, y+2, w*0.75, h-4 )
end

function SKIN:DrawLeftBackground( x, y, w, h, color )
	if !SCR_H_DIV_4 then SCR_H_DIV_4 = ScrH() * 0.25 end

	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
	
	surface.SetDrawColor( 0, 0, 0, 120 )
	surface.DrawRect( x, y, w-1, 1 )
	surface.DrawRect( x, y, 1, h-1 )
	surface.DrawRect( x, y+h-1, w, 1 )
	surface.DrawRect( x+w-1, y, 1, h-1 )
	
	surface.SetDrawColor( 200, 200, 200, 120 )
	surface.DrawRect( x+1, y+1, w-2, 1 )
	surface.DrawRect( x+1, y+1, 1, h-2 )
	surface.DrawRect( x+1, y+h-2, w-2, 1 )
	surface.DrawRect( x+w-2, y+1, 1, h-2 )
	
	local scale = math.Clamp( h/SCR_H_DIV_4, 0, 1 )
	surface.SetDrawColor( 0, 0, 0, 80+80*scale ) -- Smaller it is the lighter
	surface.SetTexture( TEX_GRADIENT_RIGHT )
	surface.DrawTexturedRectRotated( x+2, y+2, w*0.75, h-4, 180 )
end

function SKIN:DrawCheapBackground( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
end

-- TOOLTIP    ----------------------------------------------------------------------------------------------------

function SKIN:PaintTooltip( panel )
	local w, h = panel:GetSize()
	
	DisableClipping( true )

	for i=1, 4 do
		local BorderSize = i*2
		local BGColor = Color( 0, 0, 0, (255/i) * 0.3 )
		self:DrawCheapBackground( -BorderSize, -BorderSize, w+BorderSize*2, h+BorderSize*2, BGColor )
		panel:DrawArrow( BorderSize, BorderSize )
		panel:DrawArrow( -BorderSize, BorderSize )
		panel:DrawArrow( BorderSize, -BorderSize )
		panel:DrawArrow( -BorderSize, -BorderSize )
	end

	self:DrawGenericBackground( 0, 0, w, h, self.tooltip )
	panel:DrawArrow( 0, 0 )
	
	DisableClipping( false )
end

-- PANEL      ----------------------------------------------------------------------------------------------------

function SKIN:PaintPanel( panel )
	if panel.m_bPaintBackground then
		local w, h = panel:GetSize()
		self:DrawGenericBackground( 0, 0, w, h, panel.m_bgColor or self.panel_transback )
	end	
end

-- FORM       ----------------------------------------------------------------------------------------------------

function SKIN:PaintForm( panel )
	local x, y, w, h = 0, 9, panel:GetWide(), panel:GetTall()-9
	self:DrawGenericBackground( x, y, w, h, self.bg_color, true )
	
	local lw = panel.Label:GetWide()
	surface.SetDrawColor( 0, 0, 0, 120 )
	surface.DrawRect( x, y, 3, 1 )
	surface.DrawRect( x+lw+5, y, w-lw-6, 1 )
	surface.SetDrawColor( 200, 200, 200, 120 )
	surface.DrawRect( x+1, y+1, 2, 1 )
	surface.DrawRect( x+lw+6, y+1, w-lw-8, 1 )
end

-- FRAME      ----------------------------------------------------------------------------------------------------

function SKIN:PaintFrame( panel )
	local w, h = panel:GetWide(), panel:GetTall()
	
	if LocalPlayer then
		--DisableClipping( true )
		local x, y = panel:LocalToScreen( 0, 0 )
		surface.SetMaterial( MAT_BLUR )	
		surface.SetDrawColor( 255, 255, 255, 255 )
		for i=0.33, 1, 0.33 do
			MAT_BLUR:SetMaterialFloat( "$blur", 5*i )
			if render then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
		--surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
		--surface.DrawRect( 0, 0, w, h )
		--DisableClipping( false )
	end
	
	self:DrawGenericBackground( 0, 0, w, h, self.bg_color )
	surface.SetDrawColor( 120, 120, 120, 150 )
	surface.DrawRect( 1, 22, w-1, 1 )
end

-- PROP SHEET ----------------------------------------------------------------------------------------------------

function SKIN:PaintPropertySheet( panel )
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	--draw.RoundedBox( 4, 0, Offset, panel:GetWide(), panel:GetTall()-Offset, self.colPropertySheet )
	if ActiveTab then
		local w, h, padding = panel:GetWide(), panel:GetTall(), panel:GetPadding()
		Offset = ActiveTab:GetTall()
		surface.SetDrawColor( self.colPropertySheet )
		surface.SetTexture( TEX_GRADIENT )
		surface.DrawTexturedRect( 2, Offset, w-4, h*0.75 )
		
		local tab = ActiveTab:GetWide()
		local x, _ = ActiveTab:GetPos()
		local tab_offset = -panel.tabScroller.pnlCanvas.x --panel.tabScroller.OffsetX
		local x1, x2 = math.Round( x+padding+1-tab_offset ), math.Round( x+padding+tab-2-tab_offset )
		surface.SetDrawColor( 200, 200, 200, 200 )
		local left, right = (x1 >= 0 and x1 <= w), (x2 >= 0 and x2 <= w)
		if left then
			surface.DrawRect( 2, Offset, x1-1, 1 )
			surface.DrawRect( x1, Offset, 1, 2 )
		end
		if right then
			surface.DrawRect( x2, Offset, w-x2-2, 1 )
			surface.DrawRect( x2, Offset, 1, 2 )
		end
		if !left and !right then
			surface.DrawRect( 2, Offset, w-4, 1 )
		end
	end
end

function SKIN:PaintTab( panel )
	local w, h = panel:GetWide(), panel:GetTall()
	if panel:GetPropertySheet():GetActiveTab() == panel then
		-- Active
		surface.SetTexture( TEX_GRADIENT_UP )
		surface.SetDrawColor( SKIN.colTab )
		surface.DrawTexturedRect( 0, h*0.05, w, h*0.95 )
		surface.SetDrawColor( 200, 200, 200, 200 )
		surface.DrawTexturedRect( 1, 0, 1, h )
		surface.DrawTexturedRect( w-2, 0, 1, h )
	else
		-- Inactive
		surface.SetDrawColor( SKIN.colTabInactive )
		surface.SetTexture( TEX_GRADIENT_UP )
		surface.DrawTexturedRect( 0, h*0.30, w, h*0.70 )
		surface.SetDrawColor( 120, 120, 120, 120 )
		surface.DrawTexturedRect( 1, h*0.25, 1, h*0.75 )
		surface.DrawTexturedRect( w-2, h*0.25, 1, h*0.75 )
	end
end

-- BUTTON     ----------------------------------------------------------------------------------------------------

function SKIN:PaintButton( panel )
	if panel.m_bBackground then
		if panel:GetDisabled() then
			self:DrawFlippedBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.control_color_dark )
			return
		elseif panel.Depressed || panel:GetSelected() then
			self:DrawGenericBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.control_color_active )
			return
		elseif panel.Hovered then
			self:DrawFlippedBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.control_color_highlight )
			return
		end
		self:DrawFlippedBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.control_color )
	end
end

function SKIN:PaintOverButton( panel )
end

function SKIN:DrawButtonBorder( x, y, w, h, depressed )
end

function SKIN:DrawDisabledButtonBorder( x, y, w, h, depressed )
end

-- TEXTENTRY  ----------------------------------------------------------------------------------------------------

function SKIN:PaintTextEntry( panel )
	if panel.m_bBackground then
		self:DrawGenericBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.colTextEntryBG )
	end
	
	panel:DrawTextEntryText( panel.m_colText, panel.m_colHighlight, panel.m_colCursor )
end

-- SCROLLBAR  ----------------------------------------------------------------------------------------------------

function SKIN:PaintScrollBarGrip( panel )
	self:DrawRightBackground( 0, 0, panel:GetWide(), panel:GetTall(), self.control_color )
end

-- VOICE      ----------------------------------------------------------------------------------------------------

function SKIN:PaintVoiceNotify( panel )
	local w, h = panel:GetSize()
	self:DrawGenericBackground( 0, 0, w, h, Color(panel.Color.r,panel.Color.g,panel.Color.b,panel.Color.a*0.25) )
	self:DrawGenericBackground( 1, 1, w-2, h-2, Color( 60, 60, 60, 240 ) )
end

-- LISTVIEW   ----------------------------------------------------------------------------------------------------

function SKIN:PaintListView( panel )
	if panel.m_bBackground then
		surface.SetDrawColor( 50, 50, 50, 180 )
		panel:DrawFilledRect()
	end
end

function SKIN:PaintListViewLine( panel )
	local Col = nil
	if panel:IsSelected() then
		Col = self.listview_selected
	elseif panel.Hovered then
		Col = self.listview_hover
	elseif panel.m_bAlt then
		Col = self.bg_alt2
	else
		return
	end
	surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
	surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
end

derma.DefineSkin( "stronghold", "Derma skin for STRONGHOLD gamemode.", SKIN )