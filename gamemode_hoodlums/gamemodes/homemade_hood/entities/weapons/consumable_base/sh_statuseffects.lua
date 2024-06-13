-- todo: rewrite all this shit... its.. so... bad....
local PLAYER = FindMetaTable("Player")

function PLAYER:GetAlcohol()
    return self:GetNWFloat("Alcohol")
end

function PLAYER:SetAlcohol(amount)
    return self:SetNWFloat("Alcohol", amount)
end

if CLIENT then
    local overlayMat = Material("pp/blurx")

    hook.Add("RenderScreenspaceEffects", "alcoholscreenspace", function()
        local lply = LocalPlayer()
        local alcohol = lply:GetAlcohol()
        if lply:Alive() then
            local blurmult = math.abs(math.sin(CurTime())) + 0.2
            overlayMat:SetFloat("$size", 4 * alcohol * blurmult)
            render.SetMaterial(overlayMat)
            render.DrawScreenQuad()

            DrawSharpen(2, alcohol)

            DrawMotionBlur(0.3, 2 * alcohol, 0.01)
        end
    end)

    local last = SysTime()
    hook.Add("StartCommand", "alcoholsway", function(ply, cmd)
        local lply = LocalPlayer()
        local alcohol = lply:GetAlcohol()
        local viewangles = cmd:GetViewAngles()
        local ft = SysTime() - last

        local shakeX = math.sin(SysTime()) * 48
        local shakeY = math.cos(SysTime()) * 84

        local shakeasd = math.sin(SysTime() * 6) * 12

        local multSway = math.Clamp(alcohol - 0.1, 0, 1)
        cmd:SetViewAngles(viewangles + Angle(shakeX + shakeasd, -shakeY - shakeasd, 0) * ft * multSway)

        last = SysTime()
    end)
end

if SERVER then
    hook.Add("Think", "alcoholthink", function()
        for _,ply in player.Iterator() do
            local alcohol = ply:GetAlcohol()
    
            ply:SetAlcohol(math.Clamp(alcohol - 0.013 * engine.TickInterval(), 0, 1))
        end
    end)

    hook.Add("PlayerRespawn", "reseteffects", function(ply)
        ply:SetAlcohol(0)
    end)

    hook.Add("KeyPress", "alcoholfall", function(ply, key) -- you're drunk go home
        local alcohol = ply:GetAlcohol()
        local rand = math.random(70, 110)

        if ply:Alive() and ply:IsSprinting() then
            if rand < (alcohol * 100) then
                ply:ToggleRagdoll(nil)
            end
        end
    end)
end
