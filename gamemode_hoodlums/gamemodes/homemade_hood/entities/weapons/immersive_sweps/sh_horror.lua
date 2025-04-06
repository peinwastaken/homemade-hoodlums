if CLIENT then
    local scaryImages = {
        Material("overlay/scary/SCARY1.png"),
        Material("overlay/scary/SCARY2.png"),
        Material("overlay/scary/SCARY3.png")
    }
    local scaryIndex = 1
    local horrorScale = 0
    local timeSinceLastHorror = 0
    local scaryDelay = 0.5
    local scaryImageTime = 1
    local scaryStation = nil

    timeSinceLastHorror = 999
    RunConsoleCommand("stopsound")

    local cc = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0,
        [ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 1,
        [ "$pp_colour_mulr" ] = 5,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    }

    net.Receive("DoHorror", function(len)
        horrorScale = 1
        timeSinceLastHorror = 0
        scaryIndex = math.random(1, 3)

        if IsValid(scaryStation) then
            scaryStation:Stop()
            scaryStation = nil
        end

        sound.PlayFile("sound/pein/pm9/evil.mp3", "", function(station, errCode, errStr)
            if IsValid(station) then
                scaryStation = station
                station:Play()
            end
        end)

        sound.PlayFile("sound/npc/stalker/go_alert2a.wav", "", function(station, errCode, errStr)
            if IsValid(station) then
                station:Play()
            end
        end)
    end)

    hook.Add("Think", "horror_think", function()
        horrorScale = Lerp(0.025 * RealFrameTime(), horrorScale, 0)
        timeSinceLastHorror = timeSinceLastHorror + RealFrameTime()
    end)

    hook.Add("RenderScreenspaceEffects", "horror_screenspace", function()
        if horrorScale > 0.01 then
            cc["$pp_colour_mulr"] = 5 * horrorScale
            cc["$pp_colour_addr"] = 0.1 * horrorScale
            DrawColorModify(cc)
            DrawMotionBlur(0.03, 1, 0.01 * RealFrameTime())

            local scaryAlpha = math.Clamp(1 + scaryDelay - (timeSinceLastHorror / scaryImageTime), 0, 1)

            surface.SetMaterial(scaryImages[scaryIndex])
            surface.SetDrawColor(255, 255, 255, 255 * scaryAlpha)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        end
    end)
end

if SERVER then
    util.AddNetworkString("DoHorror")

    hook.Add("DoPlayerDeath", "horror_doplayerdeath", function(ply, attacker, dmginfo)
        if attacker:IsPlayer() and ply != attacker and attacker:GetActiveWeapon().ClassName == "weapon_pm9" then
            net.Start("DoHorror")
            net.Send(attacker)
        end
    end)
end