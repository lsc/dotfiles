function toggle_outputs()
	local fd = io.popen("xrandr")
	local status = fd:register("*all")
end
