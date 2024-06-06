local PLAYER = FindMetaTable("Player")
local clickSound = "pein/attachments/click.wav"

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
        local ragdoll = lply:GetNWEntity("ragdoll")
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
                if IsValid(ragdoll) then
                    lply = ragdoll
                end

                local att_eyes = lply:GetAttachment(lply:LookupAttachment("eyes"))

                local flashdir = att.Ang:Up()
                local eyedir = att.Pos - att_eyes.Pos

                local dist = eyedir:Length()
                local maxdist = 1000
                local dot = flashdir:Dot(eyedir:GetNormalized())
                local scale = dist / maxdist
                local dotLimit = 0.6

                if dot > dotLimit then
                    local tr = util.QuickTrace(att.Pos, -eyedir, {lply, ply})
                    local mult = (dot - dotLimit) / (1 - dotLimit)
                    local size = 512 * mult * (1 - scale)
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
    concommand.Add("hoodlum_flashlight_toggle", function(ply)
        local enabled = ply:GetNWBool("flashlight")
        local wep = ply:GetActiveWeapon()
        if wep.GetAttachmentEffects then
            local att_effects = wep:GetAttachmentEffects()
            if att_effects["Flashlight"] then
                ply:SetNWBool("flashlight", !enabled)
                ply:EmitSound(clickSound, 35)
            end
        end
    end)

    hook.Add("PlayerSwitchFlashlight", "homemade.flashlight", function(ply, enabled)
        return false
    end)
end