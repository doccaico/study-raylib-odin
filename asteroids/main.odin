package asteroids

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

background := rl.Texture{}

main :: proc() {

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	center_window()
	rl.SetTargetFPS(FPS)
	// rl.SetExitKey(.KEY_NULL)

	// hide the OS cursor, we are going to draw our own
	rl.HideCursor()

	// set up sounds
	sounds_init()
	defer sounds_shutdown()
	rl.SetMasterVolume(0.5)

	// load images
	sprites_init()
	defer sprites_shutdown()
	background = rl.LoadTexture("resources/darkPurple.png")
	defer rl.UnloadTexture(background)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
