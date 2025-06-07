package lifegame

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

CELL_SIZE :: 2
INITIAL_CELL_COUNT :: 80
FPS :: 30

WINDOW_TITLE :: "lifegame" + (" (debug)" when ODIN_DEBUG else "")
WINDOW_WIDTH :: 480
WINDOW_HEIGHT :: 640
COL_SIZE :: WINDOW_WIDTH / CELL_SIZE + 2
ROW_SIZE :: WINDOW_HEIGHT / CELL_SIZE + 2

#assert(INITIAL_CELL_COUNT <= COL_SIZE - 2)

grid: [ROW_SIZE][COL_SIZE]int
neighbors: [ROW_SIZE][COL_SIZE]int
cell_color := rl.BLACK
bg_color := rl.RAYWHITE


main :: proc() {
	initialize_grid()
	randomize()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(FPS)

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.R) {
			initialize_grid()
			randomize()
		} else if rl.IsKeyPressed(.B) {
			change_bg_color()
		} else if rl.IsKeyPressed(.C) {
			change_cell_color()
		}

		rl.BeginDrawing()
		rl.ClearBackground(bg_color)
		draw()
		next_generation()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

initialize_grid :: proc() {
	for i := 0; i < COL_SIZE; i += 1 {
		// top
		grid[0][i] = 0
		// bottom
		grid[ROW_SIZE - 1][i] = 0
	}

	for i := 0; i < ROW_SIZE; i += 1 {
		// left
		grid[i][0] = 0
		// right
		grid[i][COL_SIZE - 1] = 0
	}

	for i := 1; i < ROW_SIZE - 1; i += 1 {
		for j := 1; j < COL_SIZE - 1; j += 1 {
			grid[i][j] = 1 if 1 <= j && j <= INITIAL_CELL_COUNT else 0
		}
	}
}

draw :: proc() {
	for i := 1; i < ROW_SIZE - 1; i += 1 {
		for j := 1; j < COL_SIZE - 1; j += 1 {
			if grid[i][j] == 1 {
				rl.DrawRectangle(
					i32(CELL_SIZE * (j - 1)),
					i32(CELL_SIZE * (i - 1)),
					i32(CELL_SIZE),
					i32(CELL_SIZE),
					cell_color,
				)
			}
		}
	}
}

randomize :: proc() {
	for i := 1; i < ROW_SIZE - 1; i += 1 {
		rand.shuffle(grid[i][1:COL_SIZE - 1])
	}
}

next_generation :: proc() {
	for i := 1; i < ROW_SIZE - 1; i += 1 {
		for j := 1; j < COL_SIZE - 1; j += 1 {
			// top = top-left + top-middle + top-right
			top := grid[i - 1][j - 1] + grid[i - 1][j] + grid[i - 1][j + 1]
			// middle = left + right
			middle := grid[i][j - 1] + grid[i][j + 1]
			// bottom = bottom-left + bottom-middle + bottom-right
			bottom := grid[i + 1][j - 1] + grid[i + 1][j] + grid[i + 1][j + 1]

			neighbors[i][j] = top + middle + bottom
		}
	}

	for i := 1; i < ROW_SIZE - 1; i += 1 {
		for j := 1; j < COL_SIZE - 1; j += 1 {
			switch neighbors[i][j] {
			case 2:
				// Do nothing
				break
			case 3:
				grid[i][j] = 1
			case:
				grid[i][j] = 0
			}
		}
	}

}

//   rand_range(0, 5) = 0..=5
rand_range :: proc(lhs: int, rhs: int) -> u8 {
	return u8(lhs + rand.int_max(rhs - lhs + 1))
}

change_bg_color :: proc() {
	bg_color = rl.Color{rand_range(0, 255), rand_range(0, 255), rand_range(0, 255), 255}
}

change_cell_color :: proc() {
	cell_color = rl.Color{rand_range(0, 255), rand_range(0, 255), rand_range(0, 255), 255}
}
