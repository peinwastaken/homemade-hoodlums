local PLAYER = FindMetaTable("Player")

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "debugrespawn", function(data)
    timer.Simple(0.5, function()
        print(Player(data.userid):GetModel())
    end)
end)

hook.Add("HUDPaintBackground", "drawhelmetoverlay", function()
    local ply = LocalPlayer()
    local helmet = ply:GetNWEntity("helmet")

    --if IsValid(helmet) and helmet.Overlay then
    --    draw.NoTexture()
--
    --    surface.SetMaterial(helmet.OverlayMaterial)
    --    surface.SetDrawColor(255, 255, 255)
    --    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    --end
end)