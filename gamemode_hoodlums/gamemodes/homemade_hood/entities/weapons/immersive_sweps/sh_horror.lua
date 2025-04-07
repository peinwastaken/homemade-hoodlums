if CLIENT then
    local scaryImages = {
        Material("overlay/scary/SCARY1.png"),
        Material("overlay/scary/SCARY2.png"),
        Material("overlay/scary/SCARY3.png"),
        Material("overlay/scary/basement.png"),
        Material("overlay/scary/catcorner.png"),
        Material("overlay/scary/catcorner2.png"),
        Material("overlay/scary/dog.png"),
        Material("overlay/scary/footman.png"),
        Material("overlay/scary/hous.png"),
        Material("overlay/scary/neverforget.png")
    }
    local scarySounds = {
        "sound/ambient/voices/citizen_beaten3.wav",
        "sound/ambient/voices/f_scream1.wav",
        "sound/weapons/bugbait/bugbait_squeeze2.wav",
        "sound/beams/beamstart5.wav",
        "sound/npc/stalker/go_alert2a.wav",
        "sound/doors/vent_open1.wav",
        "sound/doors/door_metal_large_open1.wav"
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
        scaryIndex = math.random(1, 10)

        if IsValid(scaryStation) then
            scaryStation:Stop()
            scaryStation = nil
        end

        sound.PlayFile("sound/pein/pm9/evil_song.mp3", "", function(station, errCode, errStr)
            if IsValid(station) then
                scaryStation = station
                station:Play()
            end
        end)

        sound.PlayFile(scarySounds[math.random(1, #scarySounds)], "", function(station, errCode, errStr)
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
            cc["$pp_colour_mulr"] = 4 * horrorScale
            cc["$pp_colour_addr"] = 0.1 * horrorScale
            DrawColorModify(cc)

            DrawMotionBlur(0.03, 1 * horrorScale, 0.01 * RealFrameTime())
        end
    end)

    hook.Add("PostDrawHUD", "scary_postdrawhud", function()
        local scaryAlpha = math.Clamp(1 + scaryDelay - (timeSinceLastHorror / scaryImageTime), 0, 1)

        surface.SetMaterial(scaryImages[scaryIndex])
        surface.SetDrawColor(255, 255, 255, 255 * scaryAlpha)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
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