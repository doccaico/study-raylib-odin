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

center_window :: proc() {
	monitor := rl.GetCurrentMonitor()

	x := rl.GetMonitorWidth(monitor) / 2 - WINDOW_WIDTH / 2
	y := rl.GetMonitorHeight(monitor) / 2 - WINDOW_HEIGHT / 2

	rl.SetWindowPosition(x, y)
}
