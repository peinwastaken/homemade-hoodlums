if SERVER then
    AddCSLuaFile()
end

ENT.Base = "armor_base"

ENT.Name = "6B23 Assault Armor"
ENT.Model = Model("models/pein/armors/6b23/6b23.mdl")
ENT.Attachment = "spine"

ENT.Offset = Vector(3, 3, 0)
ENT.AngOffset = Angle(90, -85, 0)
ENT.Scale = 1.1

ENT.Durability = 250
ENT.AimSpeedMult = 1
ENT.WalkSpeedMult = 0.85

ENT.HudMaterial = Material("gui/armor/vests/armor_6b23.png", "smooth")
ENT.ArmorType = "armor"