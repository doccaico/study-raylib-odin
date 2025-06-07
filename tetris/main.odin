package tetris

import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

WINDOW_TITLE :: "tetris" + (" (debug)" when ODIN_DEBUG else "")
WINDOW_WIDTH :: 500
WINDOW_HEIGHT :: 620
FPS :: 60

// last_update_time: f64 : 0.0
last_update_time := 0.0

event_triggered :: proc(interval: f64) -> bool {
	current_time := rl.GetTime()
	if current_time - last_update_time >= interval {
		last_update_time = current_time
		return true
	}
	return false
}

main :: proc() {

	// when ODIN_DEBUG {
	// 	track: mem.Tracking_Allocator
	// 	mem.tracking_allocator_init(&track, context.allocator)
	// 	context.allocator = mem.tracking_allocator(&track)
	//
	// 	defer {
	// 		if len(track.allocation_map) > 0 {
	// 			fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
	// 			for _, entry in track.allocation_map {
	// 				fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
	// 			}
	// 		}
	// 		if len(track.bad_free_array) > 0 {
	// 			fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
	// 			for entry in track.bad_free_array {
	// 				fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
	// 			}
	// 		}
	// 		mem.tracking_allocator_destroy(&track)
	// 	}
	// }

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(FPS)

	font := rl.LoadFontEx("fonts/monogram.ttf", 64, nil, 0)
	defer rl.UnloadFont(font)

	game := game()
	defer game_deinit(&game)

	for !rl.WindowShouldClose() {
		rl.UpdateMusicStream(game.music)
		handle_input(&game)
		// if (EventTriggered(0.2)) {
		// 	game.MoveBlockDown()
		// }

		rl.BeginDrawing()
		rl.ClearBackground(darkblue)
		// DrawTextEx(font, "Score", {365, 15}, 38, 2, WHITE)
		// DrawTextEx(font, "Next", {370, 175}, 38, 2, WHITE)
		// if (game.gameOver) {
		// 	DrawTextEx(font, "GAME OVER", {320, 450}, 38, 2, WHITE)
		// }
		// DrawRectangleRounded({320, 55, 170, 60}, 0.3, 6, lightBlue)
		//
		// char;scoreText[10]
		// sprintf(scoreText, "%d", game.score)
		// Vector2;textSize = MeasureTextEx(font, scoreText, 38, 2)
		//
		// DrawTextEx(font, scoreText, {320 + (170 - textSize.x) / 2, 65}, 38, 2, WHITE)
		// DrawRectangleRounded({320, 215, 170, 180}, 0.3, 6, lightBlue)
		// game.Draw()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
