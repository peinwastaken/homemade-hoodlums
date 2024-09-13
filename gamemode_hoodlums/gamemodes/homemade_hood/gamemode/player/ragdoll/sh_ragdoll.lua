local PLAYER = FindMetaTable("Player")

function PLAYER:GetRagdoll()
    return self:GetNWEntity("ragdoll")
end