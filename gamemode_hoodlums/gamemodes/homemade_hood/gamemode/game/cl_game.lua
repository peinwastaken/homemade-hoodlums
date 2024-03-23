print("client game")

net.Receive("PlayerDeath", function()
    local ply = net.ReadPlayer()
    local weapon = net.ReadEntity()
    local killer = net.ReadEntity()

    if ply == killer then
        chat.AddText(Color(246, 173, 27), string.format("%s killed themself", ply:Name()))
    else
        chat.AddText(Color(246, 173, 27), string.format("%s was killed by %s", ply:Name(), killer:Name()))
    end
end)

local hide = {
	["CHudCrosshair"] = true,
    ["CHUDQuickInfo"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end)

hook.Add("DrawDeathNotice", "hoodlums_drawdeathnotice", function()
    return false
end)

hook.Add("HUDDrawTargetID", "hoodlums_drawtargetid", function()
    return false
end)