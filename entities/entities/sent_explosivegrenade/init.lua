AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/weapons/w_eq_fraggrenade.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_NONE )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Created = CurTime()
end

function ENT:Think()
	if CurTime() - self.Created >= self.dt.Duration then
		self:Explode()
		self:Remove()
	end
end

function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetNormal( Vector(0,0,1) )
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "shockwave", effectdata, true, true )
	util.Effect( "explosion_dust", effectdata, true, true )

	local explo = ents.Create( "env_explosion" )
	explo:SetOwner( self.GrenadeOwner )
	explo:SetPos( self:GetPos() )
	explo:SetKeyValue( "iMagnitude", "150" )
	explo:Spawn()
	explo:Activate()
	explo:Fire( "Explode", "", 0 )

	local shake = ents.Create( "env_shake" )
	shake:SetOwner( self.Owner )
	shake:SetPos( self:GetPos() )
	shake:SetKeyValue( "amplitude", "2000" )	-- Power of the shake
	shake:SetKeyValue( "radius", "900" )	-- Radius of the shake
	shake:SetKeyValue( "duration", "0.5" )	-- Time of shake
	shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
end