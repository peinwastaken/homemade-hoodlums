local PLAYER = FindMetaTable("Player")

if CLIENT then
    function PLAYER:GetFlashlight()
        return self.flashlight
    end

    function PLAYER:CreateFlashlight(pos, ang)
        if not self.flashlight then
            self.flashlight = ProjectedTexture()
			self.flashlight:SetTexture("effects/flashlight001")
			self.flashlight:SetFarZ(1500)
			self.flashlight:SetNearZ(15)
			self.flashlight:SetFOV(75)
			self.flashlight:SetBrightness(1)
            self.flashlight:SetEnableShadows(true)
            if pos then self.flashlight:SetPos(pos) end
            if ang then self.flashlight:SetAngles(ang) end
            self.flashlight:Update()
            return self.flashlight
        end
    end

    function PLAYER:RemoveFlashlight()
        if self.flashlight then
            self.flashlight:Remove()
            self.flashlight = nil
        end
    end

    local white = Material("reticles/white")
    local glow = Material("Sprites/light_glow02_add_noz")
    hook.Add("PostDrawTranslucentRenderables", "flashlight_posttranslucent", function()
        local lply = LocalPlayer()
        for _,ply in player.Iterator() do
            local wep = ply:GetActiveWeapon()
            local enabled = ply:GetNWBool("flashlight")

            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:Alive() and ply ~= lply then
                if not enabled then continue end

                local effect = wep:GetAttachmentEffects()
                local att_name = effect["FlashlightAttachment"]
                if not att_name then continue end
                local att = wep:GetAttachment(wep:LookupAttachment(att_name))

                -- flashlight circle thingie
                att.Ang:RotateAroundAxis(att.Ang:Right(), 90)
                cam.Start3D2D(att.Pos + att.Ang:Up() * 0.1, att.Ang, 1)
                    surface.SetDrawColor(255, 255, 255, 255)
                    draw.Circle(0, 0, effect["FlashlightSize"], 16)
                cam.End3D2D()
            end
        end
    end)

    hook.Add("PostDrawEffects", "flashlight_posteffects", function()
        local lply = LocalPlayer()
        for _,ply in player.Iterator() do
            local wep = ply:GetActiveWeapon()
            local enabled = ply:GetNWBool("flashlight")

            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:Alive() and ply ~= lply then
                if not enabled then continue end

                local effect = wep:GetAttachmentEffects()
                local att_name = effect["FlashlightAttachment"]
                if not att_name then continue end
                local att = wep:GetAttachment(wep:LookupAttachment(att_name))
                att.Ang:RotateAroundAxis(att.Ang:Right(), 90)

                -- glare
                local att_eyes = lply:GetAttachment(lply:LookupAttachment("eyes"))

                local flashdir = att.Ang:Up()
                local eyedir = att.Pos - att_eyes.Pos

                local dist = eyedir:Length()
                local maxdist = 1000
                local mult = math.Clamp(1 - dist/maxdist, 0, 1)
                local dot = flashdir:Dot(eyedir:GetNormalized()) - 0.25

                if dot > 0 then
                    local tr = util.QuickTrace(att.Pos, -eyedir, {lply, ply})
                    local size = 1024 * dot * mult
                    local pos = att.Pos:ToScreen()
                    if not tr.Hit then
                        cam.Start2D()
                            surface.SetMaterial(glow)
                            surface.DrawTexturedRect(pos.x - size/2, pos.y - size/2, size, size)
                        cam.End2D()
                    end
                end
            end
        end
    end)

    hook.Add("Think", "flashlight.think", function()
        for _,ply in player.Iterator() do
            local wep = ply:GetActiveWeapon()
            local enabled = ply:GetNWBool("flashlight")

            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:Alive() then
                local effect = wep:GetAttachmentEffects()
                local att_name = effect["FlashlightAttachment"]
                if not att_name then ply:RemoveFlashlight() continue end
                local att = wep:GetAttachment(wep:LookupAttachment(att_name))

                local flashlight = ply:GetFlashlight()
                if enabled then
                    if flashlight then
                        -- light
                        flashlight:SetPos(att.Pos)
                        flashlight:SetAngles(att.Ang)
                        flashlight:Update()
                    else
                        ply:CreateFlashlight(att.Pos, att.Ang)
                    end
                else
                    ply:RemoveFlashlight()
                end
            else
                ply:RemoveFlashlight()
            end
        end
    end)
end

if SERVER then
    hook.Add("PlayerSwitchFlashlight", "homemade.flashlight", function(ply, enabled)
        local state = ply:GetNWBool("flashlight")
        ply:SetNWBool("flashlight", !state)

        return false
    end)
end