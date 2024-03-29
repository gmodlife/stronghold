--[[-------------------------------------------------------

Fight to Survive: Stronghold by RoaringCow, TehBigA is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.

This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or send a letter to Creative Commons, 
444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

---------------------------------------------------------]]
local CONVARS = GM.ConVars

local MAT_BLUR = Material( "pp/blurscreen" )
local MAT_DYING = Material( "blood/dying" )
local MAT_VIGNETTE = Material( "vignette" )
--[[local MAT_FILMGRAIN = {
	Material( "grain/SHFG1" ),
	Material( "grain/SHFG2" ),
	Material( "grain/SHFG3" ),
	Material( "grain/SHFG4" ),
	Material( "grain/SHFG5" ),
	Material( "grain/SHFG6" )
}]]

local BloodTime = 3.5
local BloodMagnitude = 0.01
local BloodSplatters = {}

function AddBloodSplatter()
	if !CONVARS.PPBloodSplat:GetBool() then return end
	for i=1, math.random(0,1) do
		local size = math.random(1024,2048)
		table.insert( BloodSplatters, 
		{x=math.random(100,ScrW()-100),
		y=math.random(200,ScrH()-200),
		w=size+math.random(0,50),
		h=size+math.random(0,50),
		ang=math.random(0,360),
		mat=surface.GetTextureID( "blood/bsplatv1" ),
		alpha=math.random(50,110),time=CurTime()} )
	end
end

--local FilmGrainCurrent = 1
--local FilmGrainLastChange = 0
function GM:ScreenEffectsThink()
	local ply = LocalPlayer()
	local curtime = CurTime()
	
	local hp = ply:Health()
	if !ply.LastHealth then
		ply.LastHealth = hp
		ply.LastHurt = 0
		ply.LastHeal = 0
		return
	end

	local delta = hp - ply.LastHealth
	if delta < 0 then
		if delta < -5 then AddBloodSplatter() end
		BloodMagnitude = math.Clamp( delta/-20, 0, 1 )
		ply.LastHurt = curtime
	elseif delta > 0 then
		ply.LastHeal = curtime
	end
	ply.LastHealth = hp
	
	--[[if curtime - FilmGrainLastChange > 0.05 then
		FilmGrainCurrent = FilmGrainCurrent + 1
		if FilmGrainCurrent > 6 then
			FilmGrainCurrent = 1
		end
		FilmGrainLastChange = curtime
	end]]
end

local SpawnProt = false
local SpawnProtTime = 0
local SpawnProtFadeTime = 0.25
local function SpawnProtToggle( um )
        SpawnProt = um:ReadBool()
        SpawnProtTime = CurTime()
end
usermessage.Hook( "sh_spawnprotection", SpawnProtToggle )

local Flashed = false
local FlashTime, FlashDuration = 0, 1
local function FlashToggle( um )
	if !Flashed then
		FlashTime = CurTime()
		FlashDuration = um:ReadFloat()
	else
		local add = um:ReadFloat()
		FlashTime = FlashTime + add * 0.7
		FlashDuration = FlashDuration + add
	end
	Flashed = true
end
usermessage.Hook( "sh_flashed", FlashToggle )

local SmokeBlur = 0
local SmokeBlurTarget = 0
function GM:RenderScreenspaceEffects()
	local light = render.GetLightColor( LocalPlayer():EyePos() )
	local ply = LocalPlayer()
	local curtime = CurTime()
	local sw, sh = ScrW(), ScrH()
	
	if CONVARS.PPHurtBlur:GetBool() and ply.LastHurt then
		for k, v in pairs(BloodSplatters) do
			local b_scale = math.Clamp( -((curtime-v.time)/BloodTime) + 1, 0, 1 )
			if b_scale <= 0 then
				BloodSplatters[k] = nil
			else
				surface.SetTexture( v.mat )
				surface.SetDrawColor( 0, 0, 0, (55+v.alpha)*b_scale*light.y)
				surface.DrawTexturedRectRotated( v.x, v.y, v.w, v.h, v.ang )
			end
		end

		local scale = math.Clamp( -((curtime-ply.LastHurt)/(BloodTime*0.20)) + 1, 0, 1 )
		if scale > 0 then
			surface.SetDrawColor( 100, 0, 0, 75*scale*BloodMagnitude )
			surface.DrawRect( 0, 0, sw, sh )
			DisableClipping( true )
				surface.SetMaterial( MAT_BLUR )	
				surface.SetDrawColor( 255, 255, 255, 255 )
				for i=0.25, 0.50, 0.25 do
					MAT_BLUR:SetMaterialFloat( "$blur", scale * 10 * i )
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRect( 0, 0, sw, sh )
				end
			DisableClipping( false )
		end
	end
	
	local colormod_brightness = 0
	local colormod_contrast_add = 0
	local colormod_color = 1
	
	if CONVARS.PPSpawnProt:GetBool() and (SpawnProt or curtime-SpawnProtTime <= (SpawnProtFadeTime+0.05)) then
		colormod_contrast_add = colormod_contrast_add + 0.20 * (SpawnProt and 1 or math.Clamp( -(curtime-SpawnProtTime)/SpawnProtFadeTime+1, 0, 1 ))
		colormod_color = (SpawnProt and 0) or math.Clamp( (curtime-SpawnProtTime)/SpawnProtFadeTime, 0, 1 )
	end
	
	if Flashed then
		if !ply:Alive() or curtime > FlashTime+FlashDuration+4*(FlashDuration/8) then Flashed = false end
		local scale_w = math.Clamp( ((FlashTime - curtime) / FlashDuration) + 1, 0, 1 )
		local scale_b = math.Clamp( ((FlashTime - curtime) / (FlashDuration+4*(FlashDuration/8))) + 1, 0, 1 )

		if scale_b > 0 then
			DrawBloom( 0.10, 1*scale_b, 8+12*scale_b, 0, 8, 1*scale_b, 1, 1, 1 )
		end
		
		if scale_w > 0 then
			local tbl = {}
			colormod_brightness = 0.60*scale_w
			colormod_contrast_add = colormod_contrast_add + 0.30*scale_w

			surface.SetDrawColor( 255, 255, 255, 180*scale_w )
			surface.DrawRect( 0, 0, sw, sh )
		end
		
		if scale_b > 0 then
			DisableClipping( true )
				surface.SetMaterial( MAT_BLUR )	
				surface.SetDrawColor( 255, 255, 255, 255*scale_b )
				for i=0.25, 0.50, 0.25 do
					MAT_BLUR:SetMaterialFloat( "$blur", scale_b * 10 * i )
					if render then render.UpdateScreenEffectTexture() end
					surface.DrawTexturedRect( 0, 0, sw, sh )
				end
			DisableClipping( false )
		end
	end
	
	if colormod_brightness != 0 or colormod_contrast_add != 0 or colormod_color != 1 then
		local colormod = {}
			colormod["$pp_colour_addr"] = 0
			colormod["$pp_colour_addg"] = 0
			colormod["$pp_colour_addb"] = 0
			colormod["$pp_colour_brightness"] = colormod_brightness
			colormod["$pp_colour_contrast"] = 1 + colormod_contrast_add
			colormod["$pp_colour_colour"] = colormod_color
			colormod["$pp_colour_mulr"] = 0
			colormod["$pp_colour_mulg"] = 0
			colormod["$pp_colour_mulb"] = 0
		DrawColorModify( colormod )
	end
	
	if SmokeBlur > 0 then
		surface.SetDrawColor( 0, 0, 0, 200*SmokeBlur )
		surface.DrawRect( 0, 0, sw, sh )
		DisableClipping( true )
			surface.SetMaterial( MAT_BLUR )	
			surface.SetDrawColor( 255, 255, 255, 255 )
			for i=0.50, 1, 0.50 do
				MAT_BLUR:SetMaterialFloat( "$blur", SmokeBlur * 7 * i )
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( 0, 0, sw, sh )
			end
		DisableClipping( false )
	end
	
	local hp = ply:Health()
	if hp > 0 and hp < 75 then
		local hpscale = -math.Clamp( ply:Health()/75, 0, 1 )+1
		local hurtscale = (math.sin(RealTime()*8)+1)/2
		surface.SetDrawColor( 0, 0, 0, (50+70*hurtscale)*hpscale )
		surface.DrawRect( 0, 0, sw, sh )
		surface.SetDrawColor( 255, 255, 255, (48+60*hurtscale)*hpscale )
		surface.SetMaterial( MAT_DYING )
		surface.DrawTexturedRect( 0, 0, sw, sh )
	end

	--[[if CONVARS.PPFilmGrain:GetBool() then
		surface.SetMaterial( MAT_FILMGRAIN[FilmGrainCurrent] )
		surface.SetDrawColor( 255, 255, 255, CONVARS.PPFilmGrainOpacity:GetInt() )
		for x=0, sw, 1024 do
			for y=0, sh, 512 do
				surface.DrawTexturedRect( x, y, 1024, 512 )
			end
		end
	end]]
	
	if CONVARS.PPVignette:GetBool() then
		surface.SetMaterial( MAT_VIGNETTE )
		surface.SetDrawColor( 255, 255, 255, CONVARS.PPVignetteOpacity:GetInt() )
		surface.DrawTexturedRect( 0, 0, sw, sh )
	end
	
	if self.GameOver then
		DisableClipping( true )
			surface.SetMaterial( MAT_BLUR )	
			surface.SetDrawColor( 255, 255, 255, 255 )
			for i=0.50, 1, 0.50 do
				MAT_BLUR:SetMaterialFloat( "$blur", 0.50 * 7 * i )
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( 0, 0, sw, sh )
			end
		DisableClipping( false )
	
		surface.SetFont( "DeathCamera" )
		local tw, th = surface.GetTextSize( "Game over!" )
		
		local x, y, w, h = 0, math.floor(sh*0.25-th*0.50-10), sw, th+20
		surface.SetDrawColor( 0, 0, 0, 220 )
		surface.DrawRect( 0, 0, sw, sh )
		surface.DrawRect( x, y, w, h )
		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.DrawRect( x, y+1, w, 1 )
		surface.DrawRect( x, y+h-2, w, 1 )
		
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( ScrW()*0.50-tw*0.50, y+15 )
		surface.DrawText( "Game over!" )
	end
end

local function DyingBlur( x, y, forward, spin )
	local ply = LocalPlayer()
	local hp = ply:Health()
	if hp > 0 and hp < 45 then
		local hpscale = -math.Clamp( ply:Health()/45, 0, 1 )+1
		local hurtscale = (math.sin(RealTime()*8)+1)/2
		return 0, 0, 0.01*hpscale*hurtscale, 0.002*hpscale*hurtscale
	end
end
hook.Add( "GetMotionBlurValues", "DyingBlur", DyingBlur )

local function SmokeGrenadeBlur()
	local ply = LocalPlayer()
	local nade, dist = nil, -1
	for _, v in ipairs(ents.FindByClass("sh_smokegrenade")) do
		local testdist = (v:GetPos()-ply:EyePos()):Length()
		if CurTime()-v.Created > 3 and v:WaterLevel() < 3 and (nade == nil or testdist < dist) then
			nade = v
			dist = testdist
		end
	end
	
	if dist != -1 then
		SmokeBlurTarget = math.Clamp( -(dist/275)+1, 0, 1 )
	else
		SmokeBlurTarget = 0
	end
	SmokeBlur = math.Approach( SmokeBlur, SmokeBlurTarget, (SmokeBlurTarget-SmokeBlur < 0 and 0.02 or 0.05) )
end
timer.Create( "SmokeGrenadeBlur", 0.10, 0, SmokeGrenadeBlur ) 

--[[function GM:ViewmodelTest()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	local viewmodel = ply:GetViewModel()
	if !IsValid( viewmodel ) or !IsValid( wep ) or !ply.LastCalcView then return end

	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
	
	--local fov = 55 - (CV_DEFFOV:GetFloat()-ply:GetFOV())
	--fov = math.tan(0.50 * math.Deg2Rad( fov )) * (ScrW()/ScrH()*0.75)
	--fov = math.Rad2Deg( fov ) * 2
	
	local fov = (wep.TranslateFOV and wep:TranslateFOV(wep.ViewModelFOV) or CV_VMFOV:GetFloat()) - 2.25
	fov = ( fov - (CV_DEFFOV:GetFloat()-ply:GetFOV()) ) * (ScrW()/ScrH()*0.75)
	
	cam.Start3D( ply.LastCalcView.origin, ply.LastCalcView.angles, fov )
		viewmodel:DrawModel()
	cam.End3D()
		
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		
	render.SetMaterial( MAT_BLUR )
	MAT_BLUR:SetMaterialFloat( "$blur", 1 * 10 )
	render.UpdateScreenEffectTexture()
	
	render.DrawScreenQuad()
	
	render.SetStencilEnable( false )
end]]
