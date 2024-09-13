if SERVER then
    util.AddNetworkString("CaptureMessage")

    AddCSLuaFile()
end

if CLIENT then
    net.Receive("CaptureMessage", function()
        local t = net.ReadString()
        local obj = net.ReadString()
        local color = _G.Teams[t]["ChatColor"]

        if t == "cops" then
            chat.AddText(color, string.format("%s seized the %s!", _G.Teams[t]["Name"], obj))
            return
        end
        chat.AddText(color, string.format("%s captured the %s!", _G.Teams[t]["Name"], obj))
    end)

    hook.Add("PostDrawTranslucentRenderables", "rendercapturepercent", function(dDepth, dSkybox, isDraw3dSkybox)
        local lply = LocalPlayer()
        local teams = _G.Teams
        local objs = ents.FindByClass("ent_objective")

        for _,ent in ipairs(objs) do
            local radius, progress = ent:GetRadius(), ent:GetCaptureProgress()
            local localPos, objPos = lply:GetPos(), ent:GetPos()
            local dir = localPos - objPos
            local dist = dir:Length()
            local angle = dir:Angle()
            if dist < radius + 23 then
                cam.Start3D2D(objPos + Vector(0, 0, 24), Angle(0, angle.y + 90, 90), 0.2)
                    local capturing = ent:GetCaptureTeam()
                    local alpha = progress / 100
                    local colorLerp = LerpColor(math.Clamp(alpha * 2, 0, 1), color_white, teams[capturing]["Color"])
                    local text = string.format("%s", progress.."%")

                    --background
                    surface.SetFont("HudDefault")
                    local padding = 5
                    local x, y = surface.GetTextSize(text)
                    surface.SetDrawColor(0, 0, 0, 50)
                    surface.DrawRect(0 - (x + padding)/2, 0 - (y + padding)/2, x + padding, y + padding)

                    draw.SimpleText(text, "HudDefault", 0, 0, colorLerp, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
ENT.Spawnable = false

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
            "weapon_mcxspear",
            "weapon_deagle",
            "weapon_akm",
            "weapon_g3"
        },
        ["CaptureDelay"] = 0.07,
        ["ItemCountMin"] = 2,
        ["ItemCountMax"] = 6,
        ["Flare"] = true,
        ["FlareColor"] = Color(106, 26, 255, 124),
    },
    ["AlcoholCache"] = {
        ["Name"] = "Alcohol Stash",
        ["Items"] = {
            "consumable_liquor",
            "consumable_henny"
        },
        ["CaptureDelay"] = 0.07,
        ["ItemCountMin"] = 2,
        ["ItemCountMax"] = 3,
        ["Flare"] = true,
        ["FlareColor"] = Color(255, 106, 0),
    },
    ["UtilityCache"] = {
        ["Name"] = "Utility Crate",
        ["Items"] = {
            "weapon_pipebomb",
            "deployable_ammobox"
        },
        --[[
        ["Armors"] = {
            "armor_6b23",
            "helmet_welding"
        },]]
        ["CaptureDelay"] = 0.07,
        ["ItemCountMin"] = 2,
        ["ItemCountMax"] = 5,
        ["Flare"] = true,
        ["FlareColor"] = Color(0, 255, 234, 124),
    },
}

-- fucking retarded
local retarded_shit = {"WeaponCache", "AlcoholCache", "UtilityCache"}

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

-- following 2 functions.....so...fvcking....neurodivergent...
local function CheckContested(leadingTable, capturingTable)
    local leadingTeam, leadingAmount = leadingTable[1], capturingTable[leadingTable[1]]

    for alliance, amount in pairs(capturingTable) do
        if alliance == leadingTeam then
            continue
        else
            if amount == leadingAmount then
                return true
            end
        end
    end

    return false
end

local function GetLeadingTeam(tbl)
    local leading = {}

    -- copy it.
    for i in pairs(tbl) do table.insert(leading, i) end
    -- sort it.
    table.sort(leading, function(a, b)
        return tbl[a] > tbl[b]
    end)

    local contested = CheckContested(leading, tbl)
    
    if not contested then 
        return leading[1] 
    end

    return "neutral"
end

local function GetValueOrZero(val)
    if val then
        return val
    end

    return 0
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

function ENT:OnCaptured()
    local pos, ang = self:GetPos()

    local objType = self:GetObjectiveType()
    local objTable = self.ObjectiveTypes[objType]

    local min, max = objTable["ItemCountMin"], objTable["ItemCountMax"]
    for i = 1, math.random(min, max) do
        local rand = math.random()
        if rand > 0.5 and objTable["Armors"] then
            local items = objTable["Armors"]
            CreateDroppedArmor(items[math.random(1, #items)], pos + Vector(0, 0, 8 + i * 12), 60)
        else
            local items = objTable["Items"]
            CreateDroppedWeapon(items[math.random(1, #items)], pos + Vector(0, 0, 8 + i * 12), true, 60)
        end
    end

    net.Start("CaptureMessage")
    net.WriteString(self:GetCaptureTeam())
    net.WriteString(self.ObjectiveTypes[self:GetObjectiveType()]["Name"])
    net.Broadcast()

    self:Remove()
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

        -- if expired
        if self:GetDespawnTime() < CurTime() then
            --print("despawning objective " .. self.ObjectiveTypes[self:GetObjectiveType()]["Name"])
            self:Remove()
        end

        -- get all players in zone
        local playersInZone = {}
        local entList = ents.FindInSphere(pos, radius)
        for _,ent in pairs(entList) do
            if ent:IsPlayer() and ent:Alive() then
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
        local all_teams = _G.Teams
        local capturing = {}
        for i,v in pairs(all_teams) do
            capturing[i] = 0
        end

        -- how many people capturing in each team
        for _,ply in pairs(playersInZone) do
            local t = ply:GetTeam()
            if capturing[t] then
                capturing[t] = capturing[t] + 1
            end
        end

        -- umm....
        local leadingTeam = GetLeadingTeam(capturing)
        if self:GetNextCapture() < CurTime() then
            local delay = self.ObjectiveTypes[objType]["CaptureDelay"]
            local nextTime = CurTime() + delay

            local capturingCount = GetValueOrZero(capturing[leadingTeam])

            if captureProgress == 0 and captureTeam == "neutral" and capturingCount > 0 then
                captureTeam = leadingTeam
            end

            -- maybe decay faster when someone else is capturing it?
            -- or maybe capture faster with multiple people?
            if leadingTeam ~= captureTeam then
                captureProgress = captureProgress - 1
            else
                if capturingCount == 0 then
                    captureProgress = captureProgress - 1
                else
                    captureProgress = captureProgress + 1
                    self:SetCaptureTeam(leadingTeam)
                end
            end

            if captureProgress == 0 and captureTeam ~= "neutral" then
                self:SetCaptureTeam("neutral")
            end

            self:SetNextCapture(nextTime)
            captureProgress = math.Clamp(captureProgress, 0, 100)
            --print("CaptureProgress " .. captureProgress)
        end

        self:SetCaptureProgress(captureProgress)

        -- if 100% captured
        if self:GetCaptureProgress() == 100 then
            self:OnCaptured()
        end
    end

    self:NextThink(CurTime())

    return true
end

function ENT:Draw()
    local objectiveType = self:GetObjectiveType()
    local progress = self:GetCaptureProgress()
    local captureTeam = self:GetCaptureTeam()
    local lply = LocalPlayer()

    self:DrawModel()
end