package breakout

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

WINDOW_TITLE :: "breakout" + (" (debug)" when ODIN_DEBUG else "")
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600
PADDLE_WIDTH :: 100
PADDLE_HEIGHT :: 20
BALL_SIZE :: 10
FPS :: 60

Brick :: struct {
	rect:   rl.Rectangle,
	active: bool,
}

create_bricks :: proc() -> [dynamic]Brick {
	ROWS :: 5
	COLS :: 10
	SPACING :: 5
	BRICK_WIDTH :: (WINDOW_WIDTH - (COLS + 1) * SPACING) / COLS
	BRICK_HEIGHT :: 20
	bricks: [dynamic]Brick

	for y := 0; y < ROWS; y += 1 {
		for x := 0; x < COLS; x += 1 {
			brick: Brick
			brick.rect.x = f32(SPACING + x * (BRICK_WIDTH + SPACING))
			brick.rect.y = f32(SPACING + y * (BRICK_HEIGHT + SPACING))
			brick.rect.width = f32(BRICK_WIDTH)
			brick.rect.height = f32(BRICK_HEIGHT)
			brick.active = true
			append(&bricks, brick)
		}
	}

	return bricks
}

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
	rl.SetTargetFPS(FPS)

	// Paddle
	paddle := rl.Rectangle {
		WINDOW_WIDTH / 2 - PADDLE_WIDTH / 2,
		WINDOW_HEIGHT - 40,
		PADDLE_WIDTH,
		PADDLE_HEIGHT,
	}
	paddle_speed: f32 : 6.0

	// Ball
	ball_pos := rl.Vector2{WINDOW_WIDTH / 2.0, WINDOW_HEIGHT / 2.0}
	ball_vel := rl.Vector2{4.0, -4.0}

	// Bricks
	bricks := create_bricks()
	defer delete(bricks)

	gameover := false
	win := false

	for !rl.WindowShouldClose() {

		// Input
		if rl.IsKeyDown(.LEFT) && paddle.x > 0 {
			paddle.x -= paddle_speed
		}
		if rl.IsKeyDown(.RIGHT) && paddle.x + paddle.width < WINDOW_WIDTH {
			paddle.x += paddle_speed
		}

		if !gameover {
			// Ball Movement
			ball_pos.x += ball_vel.x
			ball_pos.y += ball_vel.y

			// Wall collision
			if ball_pos.x <= 0 || ball_pos.x >= WINDOW_WIDTH - BALL_SIZE {
				ball_vel.x *= -1
			}
			if ball_pos.y <= 0 {
				ball_vel.y *= -1
			}

			// Bottom (game over)
			if ball_pos.y >= WINDOW_HEIGHT {
				gameover = true
				win = false
			}

			// Paddle collision
			ball_rect := rl.Rectangle{ball_pos.x, ball_pos.y, BALL_SIZE, BALL_SIZE}
			if rl.CheckCollisionRecs(ball_rect, paddle) {
				ball_vel.y *= -1
				ball_pos.y = paddle.y - BALL_SIZE
			}

			// Brick collision
			for &b in bricks {
				if b.active && rl.CheckCollisionRecs(ball_rect, b.rect) {
					b.active = false
					ball_vel.y *= -1
					break
				}
			}

			// Win check
			win = true
			for b in bricks {
				if b.active {
					win = false
					break
				}
			}
			if win {
				gameover = true
			}
		}

		// Drawing
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		// Draw paddle
		rl.DrawRectangleRec(paddle, rl.DARKGRAY)

		// Draw ball
		rl.DrawRectangle(i32(ball_pos.x), i32(ball_pos.y), BALL_SIZE, BALL_SIZE, rl.MAROON)

		// Draw bricks
		for b in bricks {
			if b.active {
				rl.DrawRectangleRec(b.rect, rl.BLUE)
			}
		}

		// Messages
		if gameover {
			msg: cstring = "YOU WIN!" if win else "GAME OVER"
			rl.DrawText(
				msg,
				WINDOW_WIDTH / 2 - rl.MeasureText(msg, 40) / 2,
				WINDOW_HEIGHT / 2,
				40,
				rl.RED,
			)
			rl.DrawText(
				"Press R to Restart",
				WINDOW_WIDTH / 2 - 100,
				WINDOW_HEIGHT / 2 + 50,
				20,
				rl.DARKGRAY,
			)
			if rl.IsKeyPressed(.R) {
				// Reset
				ball_pos = rl.Vector2{WINDOW_WIDTH / 2.0, WINDOW_HEIGHT / 2.0}
				ball_vel = rl.Vector2{4.0, -4.0}
				paddle.x = WINDOW_WIDTH / 2 - PADDLE_WIDTH / 2
				delete(bricks)
				bricks = create_bricks()
				gameover = false
				win = false
			}
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
