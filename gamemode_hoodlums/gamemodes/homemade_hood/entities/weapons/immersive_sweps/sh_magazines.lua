SWEP.MaxMagazines = 7
SWEP.StartMagazines = 3

local magCheckTimeRequired = 0.3

if CLIENT then
    local hudLerp = 0

    local function DrawInfoText(text, alpha, posX, posY)
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
    
        draw.SimpleText(text, "HudMedium", textPos.x, textPos.y, Color(255, 255, 255, 255 * hudLerp), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

        if checkingMag then
            hudLerp = Lerp(8 * FrameTime(), hudLerp, 1)
        else
            hudLerp = Lerp(8 * FrameTime(), hudLerp, 0)
        end

        local x = ScrW() - 50
        local y = ScrH() - 50

        if hudLerp > 0.01 then
            DrawInfoText(ammoText, hudLerp, x, y)
            DrawInfoText(string.format("Magazines: %s", magsLeft), hudLerp, x, y - 60)
            DrawInfoText(automaticText, hudLerp, x, y - 120)
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

		ply:SetAnimation(PLAYER_RELOAD)
		self:EmitSound(self.ReloadSound, 60, 100, 1, CHAN_AUTO)
		timer.Create("reload" .. self:EntIndex(), self.ReloadTime, 1, function()
			if not IsValid(self) then return end

			local ammo = self:Ammo1()
			local clip = self:Clip1()
			local maxclip = self.Primary.ClipSize
			local missing = maxclip - clip
			
			self:SetClip1(maxclip)
            self:SetMagazinesRemaining(magsLeft - 1)
		end)
	end
end

function SWEP:InitMagazines()
    self:NetworkVar("Int", 2, "MagazinesRemaining")

    -- dont even know why these are networked if im being honest
    -- originally it was to fix a bug but this should all be clientside local u know
    self:NetworkVar("Bool", 2, "CheckingMag")
    self:NetworkVar("Float", 2, "TimeSinceMagCheck")
    self:NetworkVar("Float", 3, "ReloadHeldTime")
    self:NetworkVar("Int", 4, "LastAmmoInMag")

    self:SetMagazinesRemaining(self.StartMagazines)
    self:SetCheckingMag(false)
    self:SetTimeSinceMagCheck(0)
    self:SetReloadHeldTime(0)
    self:SetLastAmmoInMag(0)
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