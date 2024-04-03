if SERVER then
    AddCSLuaFile("cl_pip.lua")
    AddCSLuaFile("sh_flashlight.lua")
    include("sh_flashlight.lua")
end
if CLIENT then
    include("cl_pip.lua")
    include("sh_flashlight.lua")
end

-- currently added attachment effects
--[[
WEAPON PROPERTIES

Automatic - bool
RecoilVertical - number
RecoilHorizontal - number
Suppressed - bool
WeaponSound - sound

SIGHTS

HoloSight - bool
AimPosAttachment - string attachment
AimOffset - vector
ReticleMaterial - material
ReticleSize - number
SightSize - table {x = 0, y = 0}
]]

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	},
    ["stock"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
    },
    ["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
    },
    ["magazine"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
    },
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	}
}

if SERVER then
    util.AddNetworkString("SendAttachments")

    function SWEP:SetRandomAttachments(tbl)
        local attachments = self:GetRandomAttachments()
    
        for slot, tbl in pairs(attachments) do
            local rnd = math.random(1, #tbl)
            self:SetAttachmentSlot(slot, tbl[rnd])
        end

        net.Start("SendAttachments")
        net.WriteEntity(self)
        net.WriteTable(self.EquippedAttachments)
        net.Broadcast()
    end

    concommand.Add("hoodlum_rand_atts", function(ply)
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep.Base == "immersive_sweps" then
            wep:SetRandomAttachments(wep:GetRandomAttachments())
        end
    end, false, "Randomize current weapon attachments")
end

if CLIENT then
    net.Receive("SendAttachments", function()
        local lply = LocalPlayer()
        local ent = net.ReadEntity()
        local attachments = net.ReadTable()

        for i,v in pairs(attachments) do
            ent:SetAttachmentSlot(i, v)
        end
    end)
end

function SWEP:GetRandomAttachments()
    local all_slots = {}
    for key, _ in pairs(self.EquippedAttachments) do
        if key ~= "BaseClass" then
            table.insert(all_slots, key)
        end
    end

    local available_atts = {}
    for i,v in ipairs(all_slots) do
        if self.Attachments[v] then
            --print("getting attachments for slot: " .. v)
            local available = {}

            for att, tbl in pairs(self.Attachments[v]) do
                if att ~= "BaseClass" then -- FUCK OFF!!!!!
                    table.insert(available, att)
                    --print("found attachment " .. tostring(att) .. " for slot " .. tostring(v))
                end
            end
            
            available_atts[v] = available
        end
    end

    return available_atts
end

function SWEP:GetAttachmentSlot(slot)
    if self.Attachments[slot][self.EquippedAttachments[slot]] then
        return self.Attachments[slot][self.EquippedAttachments[slot]]
    end
    return nil
end

function SWEP:SetAttachmentSlot(slot, new)
    if not self.Attachments[slot] then return end
    if self.Attachments[slot][new] then
        self.EquippedAttachments[slot] = new
        self:UpdateAttachment(slot)
    end
end

function SWEP:UpdateAttachment(slot)
    local att_slot = self:GetAttachmentSlot(slot)
	local att_effects = self:GetAttachmentEffects()
    local id, value = att_slot["bodygroup_id"], att_slot["bodygroup_value"]

    self:SetBodygroup(id, value)

    --PrintTable(att_effects)

    if att_effects["ClipSize"] then
        self.Primary.ClipSize = att_effects["ClipSize"]
        self:SetClip1(self.Primary.ClipSize)
    end
    
    if att_effects["Automatic"] == true then
		self.Primary.Automatic = true
	elseif att_effects["Automatic"] == false then
		self.Primary.Automatic = false
	end

    if att_effects["WeaponName"] then
        self.PrintName = att_effects["WeaponName"]
    end
end

function SWEP:GetAttachmentEffects()
    local effect_list = {}
    for slot, attachment in pairs(self.EquippedAttachments) do
        if not self.Attachments[slot] then continue end
        local tbl = self.Attachments[slot][attachment]["effects"]

        for effect, value in pairs(tbl) do
            if type(value) == "boolean" then
                effect_list[effect] = value
            elseif type(value) == "number" then
                if effect_list[effect] then
                    effect_list[effect] = effect_list[effect] + value
                else
                    effect_list[effect] = value
                end
            else
                effect_list[effect] = value
            end
        end
    end
    return effect_list
end

hook.Add("PostDrawTranslucentRenderables", "hoodlum_attachments_sights", function()
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep.Base ~= "immersive_sweps" then return end
    local effect = wep.Attachments["sight"][wep.EquippedAttachments["sight"]]["effects"]

    if effect and effect["HoloSight"] then
        local sight_att, reticle_mat, reticle_size, sight_size = effect["AimPosAttachment"], effect["ReticleMaterial"], effect["ReticleSize"], effect["SightSize"]
        local att = wep:GetAttachment(wep:LookupAttachment(sight_att))
        local att_pos, att_ang = att.Pos, att.Ang
        att_ang:RotateAroundAxis(att_ang:Right(), 90)

        cam.Start3D2D(att.Pos - att_ang:Up() * 64, att_ang, 0.01)
            cam.Start3D2D(att.Pos, att_ang, 0.01)
                -- no fucking clue
                render.ClearStencil()
                render.SetStencilEnable(true)
                render.SetStencilTestMask(255)
                render.SetStencilWriteMask(255)
                render.SetStencilReferenceValue(64)
                render.SetStencilCompareFunction(STENCIL_ALWAYS)
                render.SetStencilPassOperation(STENCIL_REPLACE)
                render.SetStencilFailOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_REPLACE)

                surface.SetDrawColor(0, 0, 0, 1)
                surface.DrawRect(-sight_size.x/2, -sight_size.y/2, sight_size.x, sight_size.y)
                draw.NoTexture()

                -- no fucking clue
                render.SetStencilCompareFunction(STENCIL_EQUAL)
                render.SetStencilFailOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_KEEP)
            cam.End3D2D()

            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(reticle_mat)
            surface.DrawTexturedRect(-reticle_size/2, -reticle_size/2, reticle_size, reticle_size)

            render.SetStencilEnable(false)
        cam.End3D2D()
    elseif effect and effect["PIPSight"] then
        local sight_att, reticle_mat, reticle_size, sight_size = effect["AimPosAttachment"], effect["ReticleMaterial"], effect["ReticleSize"], effect["SightSize"]
        local att = wep:GetAttachment(wep:LookupAttachment(sight_att))
        local att_pos, att_ang = att.Pos, att.Ang
        att_ang:RotateAroundAxis(att_ang:Right(), 90)

        DoPip(wep, att_pos, att_ang)
    end
end)