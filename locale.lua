local function func(t, mt)
	setmetatable(t, mt)
	return t
end

return func({
	t_play_button = "Play",
	t_settings_button = "Settings",
	t_exit_button = "Exit",
	t_game_name = "Minesweeper",
	t_win_msg = "You Win!",
	t_lose_msg = "Game over!",
	t_copyright = "(C) UtoECat 2022-2022. (GNU GPL 3.0)",
	t_loading = "Loading",
	t_easteregg = "Amogus looks kinda sus.",
	t_music_volume = "Music :",
	t_sound_volume = "Sound :",
	t_back_button = "< Back",
	t_achievments = "Achievments",
	t_ach_button = "^-^",
	t_debug = "Debug mode",
	t_retry = "Retry",
	t_off_particles = "No Particles",
	t_howtoplay = "How to play :",
	t_help_button = "Help",
	t_field_size = "Field size",
	t_mines_percent = "Mines percent"
}, 
{__index = function(t, k) return "nil" end})
