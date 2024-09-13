local blur = Material("pp/blurscreen")

local function CreateDeathScreen(headshot)
    if headshot then
        hook.Add("PostDrawHUD", "deathscreen", function()
            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

            draw.SimpleText("You were shot in the head.", "FancyOldTimey", ScrW()/2, ScrH()/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)

        hook.Add("RenderScreenspaceEffects", "deathscreen", function()
            -- nothing is ever being added here :(
        end)
    else
        hook.Add("PostDrawHUD", "deathscreen", function()
            -- maybe ill add something here :)
        end)

        hook.Add("RenderScreenspaceEffects", "deathscreen", function()
            DrawMotionBlur(0.1, 1, FrameTime())
        end)

        LocalPlayer():ScreenFade(2, Color(0, 0, 0, 255), 3, 2.1)
    end

    timer.Create("checkalive", 0.1, 0, function()
        if LocalPlayer():Alive() then
            hook.Remove("PostDrawHUD", "deathscreen")
            hook.Remove("RenderScreenspaceEffects", "deathscreen")
            timer.Remove("checkalive")
        end
    end)
end

local function BodycamDeath()
    hook.Add("PostDrawHUD", "deathscreen", function()
        
    end)

    hook.Add("RenderScreenspaceEffects", "deathscreen", function()
        for i = 1, 8 do
            blur:SetFloat("$blur", i * 3)
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.SetMaterial(blur)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        end
    end)

    LocalPlayer():ScreenFade(2, Color(0, 0, 0, 255), 3, 2.1)

    timer.Create("checkalive", 0.1, 0, function()
        if LocalPlayer():Alive() then
            hook.Remove("PostDrawHUD", "deathscreen")
            hook.Remove("RenderScreenspaceEffects", "deathscreen")
            timer.Remove("checkalive")
        end
    end)
end

net.Receive("DeathEvent", function()
    local headshot = net.ReadBool()

    if BodycamEnabled() then
        BodycamDeath()
    else
        CreateDeathScreen(headshot)
    end

    hook.Run("ClientDeath")
end)