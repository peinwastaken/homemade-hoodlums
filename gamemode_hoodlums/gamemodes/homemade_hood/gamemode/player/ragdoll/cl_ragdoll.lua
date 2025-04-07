// ripped from homemade grad, thank you homemade grad developer
net.Receive("RagdollTimer", function(len)
    local time = net.ReadFloat()
	
	local width = 150
	local height = 10
	local lerpstart = Color(0, 255, 0, 150)
	local lerpend = Color(255, 0, 0, 150)
	local color = Color(0, 0, 0)

	local start = CurTime()
	hook.Add("HUDPaint", "homemade.progressbar", function()
		local elapsed = CurTime() - start
		local alpha = 1 - math.Clamp(elapsed/time, 0, 1)

		if not LocalPlayer():Alive() or alpha <= 0 then
			hook.Remove("HUDPaint", "homemade.progressbar")
		end

		local color = LerpColor(alpha, lerpstart, lerpend)

		surface.SetDrawColor(color)
		surface.DrawRect(ScrW()/2 - (width*alpha^2)/2, ScrH()-15, width*alpha^2, height)

		local rounded = string.format("%.1f", time - elapsed)
		draw.SimpleText(rounded, "Default", ScrW()/2, ScrH()-height, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end)