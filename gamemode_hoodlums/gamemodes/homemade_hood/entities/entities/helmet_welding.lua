if SERVER then
    AddCSLuaFile()
end

ENT.Base = "armor_base"

ENT.Name = "Plastic Welding Mask"
ENT.Model = Model("models/pein/helmets/weldingmask/weldingmask.mdl")
ENT.Attachment = "eyes"

ENT.Offset = Vector(-2, 1.5, 0)
ENT.Scale = 1

ENT.Durability = 50
ENT.AimSpeedMult = 0.9
ENT.WalkSpeedMult = 1

ENT.Overlay = true
ENT.OverlayMaterial = Material("overlay/welding_overlay.png")

ENT.HudMaterial = Material("gui/armor/helmets/helmet_welding.png", "smooth")
ENT.ArmorType = "helmet"