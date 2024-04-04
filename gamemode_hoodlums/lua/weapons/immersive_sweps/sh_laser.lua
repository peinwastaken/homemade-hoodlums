if CLIENT then
    local white = Material("reticles/white")
    local glow = Material("Sprites/light_glow02_add_noz")
    hook.Add("PostDrawTranslucentRenderables", "laser_posttranslucent", function()
        local lply = LocalPlayer()
        for _,ply in player.Iterator() do
            local wep = ply:GetActiveWeapon()
            local enabled = ply:GetNWBool("laser")

            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:Alive() then
                if not enabled then continue end

                local effect = wep:GetAttachmentEffects()
                local att_name = effect["LaserAttachment"]
                if not att_name then continue end
                local att = wep:GetAttachment(wep:LookupAttachment(att_name))

                -- laser beam
                att.Ang:RotateAroundAxis(att.Ang:Right(), 90)
                cam.Start3D()
                    local r, g, b, a = ply:GetNWInt("laser_r"), ply:GetNWInt("laser_g"), ply:GetNWInt("laser_b"), ply:GetNWInt("laser_a")
                    local trace = util.QuickTrace(att.Pos, att.Ang:Up() * -1024)
                    render.SetMaterial(Material("effects/laser1"))
                    render.DrawBeam(trace.StartPos, trace.HitPos, 1, 0, 12.5, Color(r, g, b, a))
                cam.End3D()
            end
        end
    end)

    hook.Add("PostDrawEffects", "laser_postdraw", function()
        local lply = LocalPlayer()
        for _,ply in player.Iterator() do
            local wep = ply:GetActiveWeapon()
            local enabled = ply:GetNWBool("laser")

            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:Alive() then
                if not enabled then continue end

                local effect = wep:GetAttachmentEffects()
                local att_name = effect["LaserAttachment"]
                if not att_name then continue end
                local att = wep:GetAttachment(wep:LookupAttachment(att_name))

                -- glare
                local att_eyes = lply:GetAttachment(lply:LookupAttachment("eyes"))

                local flashdir = att.Ang:Forward() * -1
                local eyedir = att.Pos - att_eyes.Pos

                local dist = eyedir:Length()
                local maxdist = 1000
                local mult = math.Clamp(1 - dist/maxdist, 0, 1)
                local dot = flashdir:Dot(eyedir:GetNormalized()) - 0.95

                -- retarded,, will change later
                if dot > 0 then
                    local tr = util.QuickTrace(att.Pos, eyedir, {lply, ply})
                    local size = 16000 * mult * dot
                    local pos = att.Pos:ToScreen()
                    if not tr.Hit then
                        cam.Start2D()
                            local r, g, b, a = ply:GetNWInt("laser_r"), ply:GetNWInt("laser_g"), ply:GetNWInt("laser_b"), ply:GetNWInt("laser_a")
                            surface.SetDrawColor(r, g, b, a)
                            surface.SetMaterial(glow)
                            surface.DrawTexturedRect(pos.x - size/2, pos.y - size/2, size, size)
                        cam.End2D()
                    end
                end
            end
        end
    end)

    CreateClientConVar("hoodlum_laser_r", 255, true, true, "Hoodlum laser red value", 0, 255)
    cvars.AddChangeCallback("hoodlum_laser_r", function(name, old, new)
    	net.Start("ColorLaser")
    	net.WriteString("red")
    	net.WriteFloat(new)
    	net.SendToServer()
    end)

    CreateClientConVar("hoodlum_laser_g", 0, true, true, "Hoodlum laser green value", 0, 255)
    cvars.AddChangeCallback("hoodlum_laser_g", function(name, old, new)
    	net.Start("ColorLaser")
    	net.WriteString("green")
    	net.WriteFloat(new)
    	net.SendToServer()
    end)

    CreateClientConVar("hoodlum_laser_b", 0, true, true, "Hoodlum laser blue value", 0, 255)
    cvars.AddChangeCallback("hoodlum_laser_b", function(name, old, new)
    	net.Start("ColorLaser")
    	net.WriteString("blue")
    	net.WriteFloat(new)
    	net.SendToServer()
    end)

    CreateClientConVar("hoodlum_laser_a", 255, true, true, "Hoodlum laser alpha value", 0, 255)
    cvars.AddChangeCallback("hoodlum_laser_a", function(name, old, new)
    	net.Start("ColorLaser")
    	net.WriteString("alpha")
    	net.WriteFloat(new)
    	net.SendToServer()
    end)
end

if SERVER then
    concommand.Add("hoodlum_laser_toggle", function(ply)
        local enabled = ply:GetNWBool("laser")
        ply:SetNWBool("laser", !enabled)
        print(!enabled)
    end)

    hook.Add("PlayerRespawn", "laser_respawn", function(ply)
        ply:SetNWInt("laser_r", ply:GetInfo("hoodlum_laser_r"))
        ply:SetNWInt("laser_g", ply:GetInfo("hoodlum_laser_g"))
        ply:SetNWInt("laser_b", ply:GetInfo("hoodlum_laser_b"))
        ply:SetNWInt("laser_a", ply:GetInfo("hoodlum_laser_a"))
    end)

    util.AddNetworkString("ColorLaser")
    net.Receive("ColorLaser", function(len, ply)
        local color = net.ReadString()
        local val = net.ReadFloat()
        if color == "red" then
            ply:SetNWInt("laser_r", val)
        end
        if color == "green" then
            ply:SetNWInt("laser_g", val)
        end
        if color == "blue" then
            ply:SetNWInt("laser_b", val)
        end
        if color == "alpha" then
            ply:SetNWInt("laser_a", val)
        end
    end)
end