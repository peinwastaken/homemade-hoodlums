SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Boombox"
SWEP.Author 				= "pein"
SWEP.Instructions			= "MC Pein - WELCOME TO THE HOMEMADE HOOD. Very homemade and anomalous."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 0
SWEP.Primary.DefaultClip	= 0

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "normal"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= Model("models/pein/boombox/boombox.mdl")

SWEP.CurrentSound = nil
SWEP.MaxAudioDistance = 150
SWEP.Audio = Sound("pein/boombox/homemade_hood.wav")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Playing")
	self:NetworkVar("Float", 0, "LastPlay")

	self:SetPlaying(false)
	self:SetLastPlay(CurTime())
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:TogglePlaying()
	local playing = self:GetPlaying()
	local lastplay = self:GetLastPlay()

	if lastplay + 1 > CurTime() then return end 

	if playing then
		self:SetPlaying(false)

		if self.CurrentSound then
			self.CurrentSound:Stop()
			self.CurrentSound = nil
		end
	else
		self:SetPlaying(true)

		self.CurrentSound = CreateSound(self, self.Audio, player.GetAll())
		self.CurrentSound:Play()
	end
end

function SWEP:Think()
	local ply = self:GetOwner()
	local playing = self:GetPlaying()

	if ply:KeyPressed(IN_ATTACK) then
		self:TogglePlaying()
	end
end

function SWEP:Deploy()
	local ply = self:GetOwner()
end

function SWEP:Holster()
	if self.CurrentSound then
		self.CurrentSound:Stop()
		self.CurrentSound = nil
	end

	return true
end

function SWEP:OnRemove()
	if self.CurrentSound then
		self.CurrentSound:Stop()
		self.CurrentSound = nil
	end
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()

end