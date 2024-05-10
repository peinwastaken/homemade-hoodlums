if SERVER then
    util.AddNetworkString("CaptureMessage")

    AddCSLuaFile()
end

if CLIENT then
    net.Receive("CaptureMessage", function()
        local t = net.ReadString()
        local obj = net.ReadString()

        if t == "bloods" then
            local color = Color(255, 40, 40)
            chat.AddText(color, string.format("%s captured the %s!", "Bloodz", obj))
        else
            local color = Color(66, 66, 255)
            chat.AddText(color, string.format("%s captured the %s!", "Cripz", obj))
        end
    end)

    hook.Add("PostDrawTranslucentRenderables", "rendercapturepercent", function(dDepth, dSkybox, isDraw3dSkybox)
        local lply = LocalPlayer()
        local objs = ents.FindByClass("ent_objective")

        for _,ent in ipairs(objs) do
            local radius, progress = ent:GetRadius(), ent:GetCaptureProgress()
            local localPos, objPos = lply:GetPos(), ent:GetPos()
            local dir = localPos - objPos
            local dist = dir:Length()
            local angle = dir:Angle()
            if dist < radius + 23 then
                cam.Start3D2D(objPos + Vector(0, 0, 24), Angle(0, angle.y + 90, 90), 0.2)
                    draw.SimpleText(string.format("%s", progress.."%"), "HudDefault", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        end
    end)
end

local smoke = {
    "particle/smokesprites_0001",
    "particle/smokesprites_0002",
    "particle/smokesprites_0003",
    "particle/smokesprites_0004",
    "particle/smokesprites_0005",
    "particle/smokesprites_0006",
    "particle/smokesprites_0007",
    "particle/smokesprites_0008",
    "particle/smokesprites_0009"
}

ENT.Type = "anim"
ENT.PrintName = "ent_objective"
ENT.Author = "pein"

ENT.Model = "models/props_junk/wood_crate001a.mdl"
ENT.Radius = 200
ENT.DespawnTime = 300

ENT.ObjectiveTypes = {
    ["WeaponCache"] = {
        ["Name"] = "Weapon Cache",
        ["Items"] = {
            "weapon_m4",
            "weapon_m4_new",
            "weapon_remington700",
            "weapon_aks74u",
            "weapon_remington870",
            "weapon_pipebomb",
            "weapon_mcxspear"
        },
        ["CaptureDelay"] = 0.3,
        ["ItemCountMin"] = 2,
        ["ItemCountMax"] = 6,
        ["Flare"] = true,
        ["FlareColor"] = Color(115, 0, 255, 99),
    },
    ["AlcoholCache"] = {
        ["Name"] = "Alcohol Stash",
        ["Items"] = {
            "consumable_liquor",
            "consumable_henny"
        },
        ["CaptureDelay"] = 0.1,
        ["ItemCountMin"] = 2,
        ["ItemCountMax"] = 3,
        ["Flare"] = true,
        ["FlareColor"] = Color(255, 106, 0),
    }
}

-- fucking retarded
local retarded_shit = {"WeaponCache", "AlcoholCache"}
ENT.Spawnable = false

-- i should create some sort of utilities script... whatever lol its not like anyone is ever gonna go through the code anyway
function LerpColor(frac, from, to)
	local col = Color(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)

	return col
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "StartCaptureTime")
    self:NetworkVar("Int", 0, "CaptureProgress")
    self:NetworkVar("String", 0, "CaptureTeam")
    self:NetworkVar("Float", 1, "Radius")
    self:NetworkVar("String", 1, "ObjectiveType")
    self:NetworkVar("Float", 2, "NextCapture")
    self:NetworkVar("Float", 3, "DespawnTime")

    self:SetStartCaptureTime(CurTime())
    self:SetCaptureProgress(0)
    self:SetCaptureTeam("neutral")
    self:SetRadius(self.Radius)
    self:SetDespawnTime(CurTime() + self.DespawnTime)

    if SERVER then
        self:SetObjectiveType(retarded_shit[math.random(#retarded_shit)])
    end
end

function ENT:Initialize()
    local objType = self:GetObjectiveType()

    self:SetModel(self.Model)

    self:PhysicsInitStatic(SOLID_VPHYSICS)

    if CLIENT then
        self:SetRenderBounds(-Vector(128, 128, 128), Vector(128, 128, 128))

        if self.ObjectiveTypes[objType]["Flare"] then
            self.Emitter = ParticleEmitter(self:GetPos())
            self.nextparticle = CurTime() + 0.5
        end
    end
end

function ENT:OnRemove()
    if CLIENT then
        if self.Emitter then
            self.Emitter:Finish()
        end
    end
end

function ENT:Think()
    local pos, radius = self:GetPos(), self:GetRadius()
    local captureProgress = self:GetCaptureProgress()
    local captureTeam = self:GetCaptureTeam()
    local objType = self:GetObjectiveType()

    if CLIENT then
        local obj = self.ObjectiveTypes[objType]
        local color = obj["FlareColor"]

        if self.nextparticle < CurTime() then
            if IsValid(self.Emitter) then
                local particle = self.Emitter:Add(table.Random(smoke), pos)
                if particle then
                    particle:SetDieTime(math.random(25, 35))

                    particle:SetColor(color.r, color.g, color.b)
                
                    particle:SetStartAlpha(math.random(40, 100))
                    particle:SetEndAlpha(0)
                
                    particle:SetStartSize(math.random(10, 20))
                    particle:SetEndSize(math.random(100, 200))
                
                    particle:SetRoll(math.random(-180, 180))
                
                    particle:SetVelocity(Vector(0, 0, 1) * 25)
                    particle:SetGravity(Vector(0, 1, 0.5))

                    particle:SetLighting(false)
                    particle:SetCollide(true)
                end

                self.nextparticle = CurTime() + 0.35
            else
                self.Emitter = ParticleEmitter(pos)
            end
        end
    end

    if SERVER then
        -- all of this is probably very expensive and im sure there are a bagorillion different ways of doing this kinda stuff
        -- but as long as it works im fine with it :)

        if self:GetDespawnTime() < CurTime() then
            --print("despawning objective " .. self.ObjectiveTypes[self:GetObjectiveType()]["Name"])
            self:Remove()
        end

        -- get all players in zone
        local playersInZone = {}
        local entList = ents.FindInSphere(pos, radius)
        for _,ent in pairs(entList) do
            if ent:IsPlayer() then
                local dir = (ent:GetPos() + Vector(0, 0, 32) - pos)
                
                local filter = player.GetAll()
                table.insert(filter, self)
                local vischeck = util.QuickTrace(pos, dir, filter)

                if not vischeck.Hit then
                    local filter = player.GetAll()
                    table.insert(filter, self)
                    table.insert(playersInZone, ent)
                end
            end
        end

        -- get capturing player teams
        local capturing = {["bloods"] = 0, ["crips"] = 0}
        for _,ply in pairs(playersInZone) do
            local t = ply:GetTeam()
            if capturing[t] then
                capturing[t] = capturing[t] + 1
            end
        end

        if capturing.bloods > capturing.crips then
            self:SetCaptureTeam("bloods")
        elseif capturing.bloods < capturing.crips then
            self:SetCaptureTeam("crips")
        elseif captureProgress == 0 then
            self:SetCaptureTeam("neutral")
        end

        if self:GetNextCapture() < CurTime() then
            local delay = self.ObjectiveTypes[objType]["CaptureDelay"]

            if capturing.bloods == 0 and captureTeam == "bloods" then
                captureProgress = captureProgress - 1
                self:SetNextCapture(CurTime() + delay)
                self:SetDespawnTime(CurTime() + self.DespawnTime)
            elseif capturing.crips == 0 and captureTeam == "crips" then
                captureProgress = captureProgress - 1
                self:SetNextCapture(CurTime() + delay)
                self:SetDespawnTime(CurTime() + self.DespawnTime)
            elseif capturing.crips == 0 and capturing.bloods == 0 or capturing.crips == capturing.bloods then
                captureProgress = captureProgress - 1
                self:SetNextCapture(CurTime() + delay)
            else
                captureProgress = captureProgress + 1
                self:SetNextCapture(CurTime() + delay)
                self:SetDespawnTime(CurTime() + self.DespawnTime)
            end
        end

        captureProgress = math.Clamp(captureProgress, 0, 100)

        self:SetCaptureProgress(captureProgress)

        if self:GetCaptureProgress() == 100 then
            net.Start("CaptureMessage")
            net.WriteString(self:GetCaptureTeam())
            net.WriteString(self.ObjectiveTypes[self:GetObjectiveType()]["Name"])
            net.Broadcast()

            local min, max = self.ObjectiveTypes[objType]["ItemCountMin"], self.ObjectiveTypes[objType]["ItemCountMax"]
            for i = 1, math.random(min, max) do
                local items = self.ObjectiveTypes[objType]["Items"]
                CreateDroppedWeapon(items[math.random(1, #items)], pos + Vector(0, 0, 8 + i * 12), true, 60)
            end

            self:Remove()
        end
    end

    self:NextThink(CurTime())

    return true
end

local colors = {
    ["neutral"] = Color(255, 255, 255, 100),
    ["bloods"] = Color(255, 0, 0, 100),
    ["crips"] = Color(0, 0, 255, 100)
}

function ENT:Draw()
    local objectiveType = self:GetObjectiveType()
    local progress = self:GetCaptureProgress()
    local captureTeam = self:GetCaptureTeam()
    local lply = LocalPlayer()

    self:DrawModel()
end