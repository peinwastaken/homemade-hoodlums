local PLAYER = FindMetaTable("Player")

function PLAYER:GetHelmet()
    return self:GetNWEntity("helmet")
end

function PLAYER:GetArmor()
    return self:GetNWEntity("armor")
end

function PLAYER:GetArmors()
    return self:GetNWEntity("helmet"), self:GetNWEntity("armor")
end