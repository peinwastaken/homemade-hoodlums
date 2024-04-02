-- getnwbool "flashlight"
local PLAYER = FindMetaTable("Player")

function PLAYER:GetFlashlight()
    
end

if CLIENT then
    
end

if SERVER then
    hook.Add("PlayerSwitchFlashlight", "homemade.flashlight", function(ply, enabled)
        ply:SetNWBool("flashlight", enabled)

        print(ply:GetNWBool("flashlight"))

        return false
    end)
end