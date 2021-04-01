/**************************************************************
                       Buu342's Balisong
https://github.com/buu342/GMod-BuuBalisong
**************************************************************/

AddCSLuaFile()
DEFINE_BASECLASS( "weapon_buu_base2" )

-- Precache particles we are going to use
PrecacheParticleSystem("blood_advisor_puncture_withdraw")

-- Create a console variable for the fail chance
if (!ConVarExists("sv_buu_balisongfailchance")) then
    CreateConVar("sv_buu_balisongfailchance", '10', FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
end

-- Kill icons and ammo name
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/entities/weapon_buu_balisong")
    killicon.Add("weapon_buu_balisong", "VGUI/entities/weapon_buu_balisong", Color(255,255,255))
    language.Add("weapon_buu_balisong", "Balisong")
end

-- SWEP Info
SWEP.Author       = "Buu342"
SWEP.PrintName    = "Balisong"
SWEP.Contact      = "Buu342@hotmail.com"
SWEP.Purpose      = "To make things liven't"
SWEP.Instructions = "Left click to stab stuff in front of you."
SWEP.Category     = "Buu342's Stuff"

-- Spawning settings
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

-- Model settings
SWEP.ViewModel    = "models/weapons/c_buu_balisong.mdl" 
SWEP.WorldModel   = "models/weapons/w_buu_balisong.mdl"
SWEP.ViewModelFOV = 54
SWEP.HoldType     = "knife" 

-- Weapon slot
SWEP.Slot    = 0
SWEP.SlotPos = 0

-- Use Buu's Base
SWEP.Base = "weapon_buu_base2"

-- Primary Fire Mode
SWEP.Primary.SwingSound  = Sound("FC3/weapons/1911/1911s-1.wav")
SWEP.Primary.Damage      = 20
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "non"

-- Sprinting 
SWEP.RunArmPos = Vector(-3, -3, 0)
SWEP.RunArmAngle = Vector(-7, 0, -9)

-- Disable Buu Base features we don't need
SWEP.CrosshairType    = 0
SWEP.CanIronsight     = false
SWEP.CanNearWall      = false
SWEP.CanSmoke         = false
SWEP.CustomFlashlight = false

-- Weapon reach
SWEP.Reach = 50


/*-----------------------------
    SetupDataTables
    Initializes predicted variables
-----------------------------*/

function SWEP:SetupDataTables()

    -- Call the weapon base's SetupDataTables function
    BaseClass.SetupDataTables(self)
    
    -- Create some variables for this weapon
    self:NetworkVar("Float", 0, "Buu_Balisong_SwingTimer")
    self:NetworkVar("Int", 0, "Buu_Balisong_SwingStyle")
    self:NetworkVar("Bool", 0, "Buu_Balisong_Failed")
    self:NetworkVar("Bool", 1, "Buu_Balisong_Deployed")
end


/*-----------------------------
    Deploy
    Called when the weapon is deployed
    @Return Whether to allow switching away from this weapon
-----------------------------*/

function SWEP:Deploy() 

    -- Call the weapon base's Deploy function
    BaseClass.Deploy(self)
    
    -- Decide what animation to use
    local sequence
    local maxchance = GetConVar("sv_buu_balisongfailchance"):GetInt()
    if (maxchance > 0 && math.Round(util.SharedRandom("Buu_Balisong_Fail", 1, maxchance)) == 1) then
        sequence = "draw_fail"
        self:SetBuu_Balisong_Failed(true)
        self:SetBuu_Balisong_SwingTimer(CurTime()+1.7)
    else
        sequence = "draw"..math.Round(util.SharedRandom("Buu_Balisong_Draw", 1, 4))
        self:SetBuu_Balisong_Failed(false)
        self:SetBuu_Balisong_SwingTimer(0)
    end
    
    -- Calculate the sequence number and duration
    sequence = self.Owner:GetViewModel():LookupSequence(sequence)
    time = CurTime() + self.Owner:GetViewModel():SequenceDuration(sequence)
    
    -- Play the animation
    self.Owner:GetViewModel():SendViewModelMatchingSequence(sequence)
    self:SetNextPrimaryFire(time)
    self:SetBuu_GotoIdle(0)
    self:SetBuu_Balisong_Deployed(true)
    
    -- Return true to allow switching away from this weapon using lastinv command
    return true
end


/*-----------------------------
    Holster
    Called when the weapon is holstered
    @Param  The weapon being holstered to
    @Return Whether to allow holstering
-----------------------------*/

function SWEP:Holster(holsterto) 
    if (self:GetBuu_Balisong_Failed()) then return false end
    
    -- Ensure we play the deploy animation again next time
    self:SetBuu_Balisong_Deployed(false)
    
    -- Call the weapon base's Holster function
    return BaseClass.Holster(self, holsterto)
end


/*-----------------------------
    PrimaryAttack
    Called when left clicking
-----------------------------*/

function SWEP:PrimaryAttack() 
    if (self:GetNextPrimaryFire() > CurTime() || self:GetBuu_Balisong_Failed()) then return end
    if (self:GetBuu_Sprinting() || self:GetBuu_OnLadder()) then return end
    
    -- Create a hull to see if we have an entity near us
    local ent = self:MakeHull().Entity
    
    -- Check if we can backstab something
    if (self:CheckBackstab(ent)) then
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        self:SetNextPrimaryFire(CurTime()+1.1)
        self:SetBuu_Balisong_SwingStyle(3)
    else
        local anim = math.Round(util.SharedRandom("Buu_Balisong_SwingAnim", 1, 2))
        local sequence = self.Owner:GetViewModel():LookupSequence("miss"..anim)
        self.Owner:GetViewModel():SendViewModelMatchingSequence(sequence)
        self:SetNextPrimaryFire(CurTime()+0.5)
        self:SetBuu_Balisong_SwingStyle(anim)
    end
    
    -- Play thirdperson attack animation and a sound
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("Buu342/Balisong/Swing"..math.random(1, 2)..".wav", 70, math.random(97, 102), 0.2)
    
    -- Start the damage timer
    self:SetBuu_Balisong_SwingTimer(CurTime()+0.1)
end


/*-----------------------------
    Think
    Logic that runs every frame
-----------------------------*/

function SWEP:Think()

    -- Sometimes deploy isn't called clientside, this will fix that
    if (!self:GetBuu_Balisong_Deployed()) then
        self:Deploy()
    end
    
    -- If the swing timer is over
    if (self:GetBuu_Balisong_SwingTimer() != 0 && self:GetBuu_Balisong_SwingTimer() < CurTime()) then
        if (!self:GetBuu_Balisong_Failed()) then
            self:DoDamage()
        elseif (SERVER) then
            self.Owner:Kill()
        end
    end
    
    -- If we failed the deploy
    if (self:GetBuu_Balisong_Failed()) then
    
        -- Initialize the bled variable if it doesn't exist
        if (self.Bled == nil) then
            self.Bled = false
        end
        
        -- Once enough time has passed in the animation
        if (self:GetBuu_Balisong_SwingTimer()-CurTime() < 1 && !self.Bled) then
            self.Bled = true
        
            -- Do a blood curling scream
            if (SERVER || IsFirstTimePredicted()) then
                self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav") 
                self.Owner:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav") 
            end
            
            -- Create blood
            if (CLIENT) then
                ParticleEffectAttach("blood_advisor_puncture_withdraw",  PATTACH_POINT_FOLLOW , self.Owner:GetViewModel(), self.Owner:GetViewModel():LookupAttachment("1")) 
            end
        end
    end
    
    -- Call the weapon base's think function
    BaseClass.Think(self)
end

/*-----------------------------
    MakeHull
    Create a hull to check for the player we're 
    attacking, and return it.
    @Return the entity caught in the trace
-----------------------------*/
function SWEP:MakeHull()

    -- Perform a quick line trace to see if we have anything in front of us
    local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*self.Reach,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	})
    
    -- If we didn't find anything, then make a box trace instead
	if (!IsValid(tr.Entity)) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*self.Reach,
			filter = self.Owner,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10),
			mask = MASK_SHOT_HULL
		})
	end
    
    -- Return the trace result
    return tr
end


/*-----------------------------
    CheckBackstab
    Checks if we're backstabbing something
    @Param  The entity to check
    @Return Whether we're backstabbing or not
-----------------------------*/

function SWEP:CheckBackstab(ent)

    -- First, ensure we're looking at a player or NPC
    if !IsValid(ent) || (!ent:IsPlayer() && !ent:IsNPC()) then 
        return false 
    end
    
    -- Check if facing the enemy's back.
    return math.abs(math.AngleDifference(ent:GetAngles().y, self.Owner:GetAngles().y)) <= 50
end


/*-----------------------------
    DoDamage
    Does the actual damage
-----------------------------*/

-- Initialize some useful lookup tables
local punchtable = {
    Angle(1, 2, 0),
    Angle(1, -2, 0),
    Angle(3, 0, 0),
}
local forcetable = {
    {30, -30, 0},
    {30, 30, 0},
    {30, 0, 30},
}
function SWEP:DoDamage()

    -- Enable lag compensation
    self.Owner:LagCompensation(true)

    -- Initialize a few variables
    local swing = self:GetBuu_Balisong_SwingStyle(anim)
    local damage = self.Primary.Damage
    local attacker = self.Owner or self
    local punch = punchtable[swing]
    local force = forcetable[swing]    
    force = self.Owner:GetForward()*force[1] + self.Owner:GetRight()*force[2] + self.Owner:GetUp()*force[3]
    
    -- If we're doing a backstab, do triple damage
    if (self:GetBuu_Balisong_SwingStyle() == 3) then
        damage = damage*3
    end
    
    -- Create a quick trace to see what we hit
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector()*(self.Reach+12))
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    tr = util.TraceLine(tr)
    
    -- If we hit something that isn't the world, then make a bullet (for the impact effect). Otherwise, do a manhack cut
    if (tr.Hit && !tr.HitWorld) then
        local bullet    = {}
        bullet.Num      = 1
        bullet.Src      = self.Owner:GetShootPos()
        bullet.Dir      = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
        bullet.Spread   = Vector(0, 0, 0)
        bullet.Distance = self.Reach+12
        bullet.Tracer   = 0
        bullet.Force    = 1
        bullet.Damage   = 1
        self.Owner:FireBullets(bullet, true)
    elseif (tr.HitWorld) then
        util.Decal("ManhackCut", tr.HitPos-tr.HitNormal, tr.HitPos+tr.HitNormal)
    end
    
    -- Create a hull to figure out if we hit something
	tr = self:MakeHull()
    if (IsValid(tr.Entity) && SERVER) then
        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(damage)
        dmginfo:SetDamageType(DMG_SLASH)
        if (tr.Entity:IsPlayer() || tr.Entity:IsNPC()) then
            force = force*100
        end
        dmginfo:SetDamageForce(force)
        tr.Entity:TakeDamageInfo(dmginfo)
    end
    
    -- Play a sound based on what we hit
    if (tr.Entity:IsNPC() || tr.Entity:IsPlayer()) then
        self:EmitSound("Buu342/Balisong/Hit"..math.random(1, 4)..".wav", 40)
    elseif (tr.Hit) then
        self:EmitSound("Buu342/Balisong/HitWall"..math.random(1, 4)..".wav", 40)
    end
    
    -- Reset the swing timer and shake the screen
    self:SetBuu_Balisong_SwingTimer(0)
    self.Owner:ViewPunch(punch)
    
    -- Disable lag compensation
    self.Owner:LagCompensation(false)
end