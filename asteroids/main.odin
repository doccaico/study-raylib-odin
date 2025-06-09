package asteroids

import "core:fmt"
import "core:math"
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
	set_fps_cap()
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

	// setup the camera for the game world
	world_camera := rl.Camera2D{}
	world_camera.zoom = 0.5

	// setup world
	world := world_create()
	defer world_destory()
	player_reset(&world.player_ship)
	world.player_ship.alive = false
	world_reset(world, 10)

	// setup gamestate
	game_state = GameStates.Menu

	// start some music
	sounds_start_bgm()

	// game loop
	for !rl.WindowShouldClose() {
		// input that is unrelated to the game

		// check for fullscreen toggle
		if rl.IsKeyPressed(.ENTER) && (rl.IsKeyDown(.LEFT_ALT) || rl.IsKeyDown(.RIGHT_ALT)) {
			// ToggleFullscreenState()
			toggle_fullscreen_state()
		}

		// update the world camera
		center := get_display_size() * 0.5
		world_camera.offset = center

		if rl.IsKeyDown(.EQUAL) {
			world_camera.zoom += 0.125 * get_delta_time()
		}
		if rl.IsKeyDown(.MINUS) {
			world_camera.zoom -= 0.125 * get_delta_time()
		}

		world_camera.zoom += rl.GetMouseWheelMove() * 0.125 * get_delta_time()

		// clamp the zoom
		if world_camera.zoom <= 0 {
			world_camera.zoom = 0.25
		}

		if world_camera.zoom > 1 {
			world_camera.zoom = 1
		}

		// update the world and all that is in it
		world_update(world)
		world_camera.target = world.player_ship.position


		// update the sound system
		sounds_update()

		// drawing
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		// if we need to shake, shake the world camera
		// TODO
		if world_shake(world) {
			world_camera.offset = {
				center.x + math.cos_f32(f32(get_current_time() * 90)) * 2,
				center.y + math.cos_f32(f32(get_current_time() * 180)) * 2,
			}
		} else {
			world_camera.offset = center
		}

		// draw the world inside it's view
		rl.BeginMode2D(world_camera)

		// compute the size of the background and shift it based on our movement
		screen := rl.Rectangle{0, 0, center.x * 2, center.y * 2}
		screen_origin_in_world := rl.GetScreenToWorld2D(rl.Vector2(0), world_camera)
		screen_edge_in_world := rl.GetScreenToWorld2D({screen.width, screen.height}, world_camera)
		screen_in_world := rl.Rectangle {
			screen_origin_in_world.x,
			screen_origin_in_world.y,
			screen_edge_in_world.x - screen_origin_in_world.x,
			screen_edge_in_world.y - screen_origin_in_world.y,
		}

		bg_scale: f32 = 0.5
		source_rect := rl.Rectangle {
			screen_in_world.x * bg_scale,
			screen_in_world.y * bg_scale,
			screen_in_world.width * bg_scale,
			screen_in_world.height * bg_scale,
		}
		rl.DrawTexturePro(background, source_rect, screen_in_world, rl.Vector2(0), 0, rl.WHITE)

		// draw the world and pass in the viewport window in world space for culling
		// world.Draw(screenInWorld);
		world_draw(world, &screen_in_world)


		rl.EndMode2D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
