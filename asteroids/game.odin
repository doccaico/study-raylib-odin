package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

WINDOW_TITLE :: "asteroids" + (" (debug)" when ODIN_DEBUG else "")
WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 800
FPS :: 60

GameStates :: enum {
	Menu,
	Playing,
	ChangingLevels,
	Paused,
	GameOver,
}

game_state := GameStates.Menu
game_time: f64 = 0.0

center_window :: proc() {
	monitor := rl.GetCurrentMonitor()

	x := rl.GetMonitorWidth(monitor) / 2 - WINDOW_WIDTH / 2
	y := rl.GetMonitorHeight(monitor) / 2 - WINDOW_HEIGHT / 2

	rl.SetWindowPosition(x, y)
}

toggle_fullscreen_state :: proc() {
	if rl.IsWindowFullscreen() {
		rl.ToggleFullscreen()
		rl.SetWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT)
		center_window()
	} else {
		monitor := rl.GetCurrentMonitor()
		rl.SetWindowSize(rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor))
		rl.ToggleFullscreen()
	}
}

get_display_size :: proc() -> rl.Vector2 {
	if rl.IsWindowFullscreen() {
		return {
			f32(rl.GetMonitorWidth(rl.GetCurrentMonitor())),
			f32(rl.GetMonitorHeight(rl.GetCurrentMonitor())),
		}
	} else {
		return {f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}
	}
}

// to support pause, and make debugging easier, we track our own delta time
get_delta_time :: proc() -> f32 {
	if game_state == GameStates.Paused {
		return 0.0
	}

	// if we are debugging, use a fixed frame rate so that we doin't get lag spikes when hitting breakpoints
	return 1.0 / FIXED_FRAME_RATE when ODIN_DEBUG else GetFrameTime()
}

get_current_time :: proc() -> f64 {
	return game_time
}
