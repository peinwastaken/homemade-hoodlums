SWEP.MaxMagazines = 7
SWEP.StartMagazines = 3
SWEP.MagazinesPerResupply = 1
SWEP.MagazineString = "Magazines"

SWEP.BreechLoader = false

local magCheckTimeRequired = 0.3

if CLIENT then
    local fullLerp = 0
    local magLerp = 0

    function DrawInfoText(text, alpha, posX, posY)
        surface.SetFont("HudMedium")
        local textSizeX, textSizeY = surface.GetTextSize(text)
        
        local padding = {x = 20, y = 5}
        local size = {x = textSizeX + padding.x, y = textSizeY + padding.y}
        local x = posX - size.x
        local y = posY - size.y/2

        local textPos = {
            x = x + textSizeX/2 + padding.x/2,
            y = y + textSizeY/2
        }
    
        surface.SetDrawColor(0, 0, 0, 50 * alpha)
        surface.DrawRect(x, y, size.x, size.y)
    
        draw.SimpleText(text, "HudMedium", textPos.x, textPos.y, Color(255, 255, 255, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("HUDPaint", "immersive_magcheckhud", function()
        local ply = LocalPlayer()
        local wep = ply:GetActiveWeapon()

        if not wep.GetMagazineInfo then return end

        local ammoLeft, magsLeft = wep:GetMagazineInfo()

        local reloadHeldTime = wep:GetReloadHeldTime()
        local timeSinceMagCheck wep:GetTimeSinceMagCheck()
        local checkingMag = wep:GetCheckingMag()
        local lastAmmoInMag = wep:GetLastAmmoInMag()
        -- timesincemagcheck should use the same method..
        local lastReload = wep:GetLastReload()
        local timeSinceReload = CurTime() - lastReload

        local automatic = wep.Primary.Automatic
        local automaticText = "Automatic"
        if not automatic then
            automaticText = "Semi-Auto"
        end
        
        local ammoText = "Full"
        local maxClip = wep:GetMaxClip1()
        local ammoDiv = lastAmmoInMag/maxClip

        -- yanderedev coding
        if ammoDiv >= 1 then
            ammoText = "Full"
        elseif ammoDiv > 0.75 then
            ammoText = "~Full"
        elseif ammoDiv > 0.5 then
            ammoText = ">Half"
        elseif ammoDiv == 0.5 then
            ammoText = "Half"
        elseif ammoDiv > 0.25 then
            ammoText = "<Half"
        elseif ammoDiv > 0 then
            ammoText = "~Empty"
        elseif ammoDiv == 0 then
            ammoText = "Empty"
        end

        if checkingMag and timeSinceReload > 2.5 then
            fullLerp = Lerp(8 * FrameTime(), fullLerp, 1)
        else
            fullLerp = Lerp(8 * FrameTime(), fullLerp, 0)
        end

        if timeSinceReload < 1.5 then
            magLerp = Lerp(8 * FrameTime(), magLerp, 1)
        else
            magLerp = Lerp(8 * FrameTime(), magLerp, 0)
        end

        local x = ScrW() - 50
        local y = ScrH() - 50

        if fullLerp > 0.01 then
            DrawInfoText(ammoText, fullLerp, x, y)
            DrawInfoText(string.format("%s: %s", wep.MagazineString, magsLeft), fullLerp, x, y - 60)
            DrawInfoText(automaticText, fullLerp, x, y - 120)
        elseif magLerp > 0.01 then
            DrawInfoText(string.format("%s: %s", wep.MagazineString, magsLeft), magLerp, x, y)
        end
    end)
end

function SWEP:GetMagazineInfo()
    local ammoInMagazine = self:Clip1()
    local magazinesLeft = self:GetMagazinesRemaining()

    return ammoInMagazine, magazinesLeft
end

function SWEP:DoReload()
    local magsLeft = self:GetMagazinesRemaining()

	if not self:Reloading() and magsLeft > 0 and self:Clip1() < self.Primary.ClipSize then
		local ply = self:GetOwner()

        if self.BreechLoader then
            self:DoBreechLoad()
            return
        end

		ply:SetAnimation(PLAYER_RELOAD)

        if IsFirstTimePredicted() then
            EmitSound(self.ReloadSound, self:GetPos(), self:EntIndex(), CHAN_AUTO, 1, 50, SND_NOFLAGS, 100)
        end
		
		timer.Create("reload" .. self:EntIndex(), self.ReloadTime, 1, function()
			if not IsValid(self) then return end

			local ammo = self:Ammo1()
			local clip = self:Clip1()
			local maxclip = self.Primary.ClipSize
			local missing = maxclip - clip
			
			self:SetClip1(maxclip)
            self:SetMagazinesRemaining(magsLeft - 1)
            self:SetLastPump(CurTime())
            self:SetLastReload(CurTime())

            self:SetWeaponHoldType(self.HoldType)
		end)
	end
end

function SWEP:DoBreechLoad()
    local ply = self:GetOwner()
    local holdType = self:GetHoldType()
    local magsLeft = self:GetMagazinesRemaining()

    ply:SetAnimation(PLAYER_RELOAD)

    if IsFirstTimePredicted() then
        EmitSound("weapons/shotgun/shotgun_reload3.wav", self:GetPos(), self:EntIndex(), CHAN_AUTO, 1, 100, SND_NOFLAGS, 100)
    end

    timer.Create("reload" .. self:EntIndex(), 0.8, 1, function()
        if not IsValid(self) then return end

        local ammo = self:Ammo1()
        local clip = self:Clip1()
        local maxclip = self.Primary.ClipSize
        
        self:SetClip1(clip + 1)
        self:SetMagazinesRemaining(magsLeft - 1)
        self:SetLastReload(CurTime())

        self:SetWeaponHoldType(self.HoldType)
    end)
end

function SWEP:InitMagazines()
    self:NetworkVar("Int", 2, "MagazinesRemaining")

    -- dont even know why these are networked if im being honest
    -- originally it was to fix a bug but this should all be clientside local u know

    -- normal shit
    self:NetworkVar("Bool", 2, "CheckingMag")
    self:NetworkVar("Float", 2, "TimeSinceMagCheck")
    self:NetworkVar("Float", 3, "ReloadHeldTime")
    self:NetworkVar("Int", 4, "LastAmmoInMag")
    self:NetworkVar("Float", 4, "LastReload")

    self:SetMagazinesRemaining(self.StartMagazines)
    self:SetCheckingMag(false)
    self:SetTimeSinceMagCheck(0)
    self:SetReloadHeldTime(0)
    self:SetLastAmmoInMag(0)
    self:SetLastReload(0)
end

function SWEP:StartCheckingMag()
    local ammoLeft = self:GetMagazineInfo()
    self:SetLastAmmoInMag(ammoLeft)

    self:SetTimeSinceMagCheck(0)
    self:SetCheckingMag(true)
end

-- move outside somewhere.... later...
function SWEP:StopCheckingMag()
    if CLIENT then
        hudLerp = 0
    end

    self:SetReloadHeldTime(0)
    self:SetTimeSinceMagCheck(999)
    self:SetCheckingMag(false)
end

function SWEP:MagThink()
    local ply = self:GetOwner()
    local reloadHeldTime = self:GetReloadHeldTime()
    local timeSinceMagCheck = self:GetTimeSinceMagCheck()
    local checkingMag = self:GetCheckingMag()

    if ply:KeyDown(IN_RELOAD) then
        self:SetReloadHeldTime(reloadHeldTime + FrameTime())

        if reloadHeldTime > magCheckTimeRequired and not checkingMag then
            self:StartCheckingMag()
        end
    end

    if ply:KeyReleased(IN_RELOAD) then
        self:SetReloadHeldTime(0)

        if timeSinceMagCheck > 0.25 and reloadHeldTime < magCheckTimeRequired then
            self:DoReload()
        end
    end
    

    self:SetTimeSinceMagCheck(self:GetTimeSinceMagCheck() + FrameTime())

    if timeSinceMagCheck > 2 and not ply:KeyDown(IN_RELOAD) then
        self:SetCheckingMag(false)
    end
end

-- racism :/
local blacklist = {
    ["weapons/ar2/ar2_reload.wav"] = true,
    ["weapons/357/357_reload1.wav"] = true,
    ["weapons/357/357_reload2.wav"] = true,
    ["weapons/357/357_reload3.wav"] = true,
    ["weapons/357/357_reload4.wav"] = true,
    ["Weapon_357.OpenLoader"] = true,
    ["Weapon_357.RemoveLoader"] = true,
    ["Weapon_357.ReplaceLoader"] = true,
    ["player/pl_shell2.wav"] = true,
    ["player/pl_shell3.wav"] = true,
    ["weapons/crossbow/reload1.wav"] = true,
    ["weapons/pistol/pistol_reload1.wav"] = true,
    ["weapons/shotgun/shotgun_reload1.wav"] = true,
    ["weapons/shotgun/shotgun_reload2.wav"] = true,
    ["weapons/shotgun/shotgun_reload3.wav"] = true,
    ["weapons/smg1/smg1_reload.wav"] = true
}

-- do reload sounds later at somepoint