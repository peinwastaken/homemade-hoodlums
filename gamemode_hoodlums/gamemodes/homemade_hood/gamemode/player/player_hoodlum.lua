DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75

PLAYER.Models = {
    ["bloods"] = {
        "models/player/bloodz/slow_1.mdl",
        "models/player/bloodz/slow_2.mdl",
        "models/player/bloodz/slow_3.mdl"
    },
    ["crips"] = {
        "models/player/cripz/slow_1.mdl", 
        "models/player/cripz/slow_2.mdl", 
        "models/player/cripz/slow_3.mdl"
    },
    ["groves"] = {
        "models/player/grovez/grovez_1.mdl",
        "models/player/grovez/grovez_2.mdl",
        "models/player/grovez/grovez_3.mdl",
        "models/player/grovez/grovez_4.mdl"
    },
    ["vagos"] = {
        "models/player/vagoz/lsv1pm.mdl",
        "models/player/vagoz/lsv2pm.mdl",
        "models/player/vagoz/lsv3pm.mdl",
    }
}

PLAYER.Teams = {"bloods", "crips", "groves", "vagos"}

PLAYER.Items = {
    ["primary"] = {
        "weapon_m4",
        "weapon_m4_new",
        "weapon_draco",
        "weapon_mpx",
        "weapon_aks74u",
        "weapon_remington870",
        "weapon_uzi",
        "weapon_mac10",
        "weapon_akm"
    },
    ["secondary"] = {
        "weapon_m1911",
        "weapon_glock",
        "weapon_sawedoff",
        "weapon_p320",
        "weapon_vz61",
        "weapon_tec9"
    },
    ["melee"] = {
        "melee_bat"
    },
    ["throwable"] = {
        "weapon_pipebomb"
    }
}

local function GetRandomItem(tbl)
    local count = #tbl
    local rnd = math.random(1, #tbl)

    return tbl[rnd]
end

function PLAYER:Loadout()
    -- :(
end

function PLAYER:GetAlliance()
    local ply = self.Player
    local model = ply:GetModel()

    -- i should **really** be using the built in teams system but im restarted

    for t, tbl in pairs(self.Models) do -- why cant i just call it team... gotta call it t instead gg
        for _,mdl in pairs(tbl) do
            if mdl == model then
                return t
            end
        end
    end

    return nil
end

function PLAYER:OnRespawn()
    local ply = self.Player

    ply:SetSuppressPickupNotices(true)

    ply:RemoveAllAmmo()
    ply:SetAmmo(9999, "pistol") -- temporary
    ply:Give(GetRandomItem(self.Items["primary"])):SetRandomAttachments()
    ply:Give(GetRandomItem(self.Items["secondary"])):SetRandomAttachments()
    ply:Give(GetRandomItem(self.Items["melee"]))
    ply:Give("weapon_hands")
    ply:Give("weapon_flashlight")

    local randThrowable = math.random(0, 100)
    if randThrowable < 50 then
        ply:Give(self.Items["throwable"][1]) -- :/
    end

    local tbl = self.Models[self.Teams[math.random(1, #self.Teams)]]
    local model = GetRandomItem(tbl)
    ply:SetModel(model)

    ply:SetWalkSpeed(self.WalkSpeed)
    ply:SetRunSpeed(self.RunSpeed)
    ply:SetSlowWalkSpeed(self.SlowWalkSpeed)
    ply:SetJumpPower(165)
end

function PLAYER:SetModel()

end

player_manager.RegisterClass("player_hoodlum", PLAYER, "player_default")