-- currently added attachment effects
--[[
Automatic = true/false - changes firemode
RecoilVertical = number - adds/removes vertical recoil
RecoilHorizontal = number - adds/removes horizontal recoil
]]

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	},
	["grip"] = {
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

SWEP.EquippedAttachments = {}

function SWEP:GetAttachmentSlot(slot)
    if self.Attachments[slot][self.EquippedAttachments[slot]] then
        return self.Attachments[slot][self.EquippedAttachments[slot]]
    end
    return nil
end

function SWEP:SetAttachmentSlot(slot, new)
    if self.Attachments[slot][new] then
        self.EquippedAttachments[slot] = new
        self:UpdateAttachment(slot)
    end
end

function SWEP:UpdateAttachment(slot)
    local att_slot = self:GetAttachmentSlot(slot)
	local att_effects = self:GetAttachmentEffects()
    local id, value = att_slot["bodygroup_id"], att_slot["bodygroup_value"]

	if att_effects["Automatic"] then
		self.Primary.Automatic = true
	end

    self:SetBodygroup(id, value)
end

function SWEP:GetAttachment(slot, att)

end

function SWEP:GetAttachmentEffects()
    local effect_list = {}
    for slot, attachment in pairs(self.EquippedAttachments) do
       	local tbl = self.Attachments[slot][attachment]["effects"]

        for effect, value in pairs(tbl) do
            if type(value) == "boolean" then
                effect_list[effect] = value
            elseif type(value) == "number" then
                effect_list[effect] = value
            end
        end
    end
    return effect_list
end