package tetris

import rl "vendor:raylib"

Grid :: struct {
	grid:      [20][10]int,
	num_rows:  int,
	num_cols:  int,
	cell_size: int,
	colors:    [dynamic]rl.Color,
}

grid :: proc() -> Grid {
	grid: Grid

	grid.num_rows = 20
	grid.num_cols = 10
	grid.cell_size = 30
	grid_initialize(&grid)
	grid.colors = get_cell_colors()

	return grid
}

grid_initialize :: proc(grid: ^Grid) {
	for row := 0; row < grid.num_rows; row += 1 {
		for column := 0; column < grid.num_cols; column += 1 {
			grid.grid[row][column] = 0
		}
	}
}

grid_deinit :: proc(grid: ^Grid) {
	colors_deinit(grid.colors)
}

is_cell_outside :: proc(grid: ^Grid, row: int, column: int) -> bool {
	if row >= 0 && row < grid.num_rows && column >= 0 && column < grid.num_cols {
		return false
	}
	return true
}

is_cell_empty :: proc(grid: ^Grid, row: int, column: int) -> bool {
	if grid.grid[row][column] == 0 {
		return true
	}
	return false
}

clear_full_rows :: proc(grid: ^Grid) -> int {
	completed := 0
	for row := grid.num_rows - 1; row >= 0; row -= 1 {
		if is_row_full(grid, row) {
			clear_row(grid, row)
			completed += 1
		} else if completed > 0 {
			move_row_down(grid, row, completed)
		}
	}
	return completed
}

is_row_full :: proc(grid: ^Grid, row: int) -> bool {
	for column := 0; column < grid.num_cols; column += 1 {
		if grid.grid[row][column] == 0 {
			return false
		}
	}
	return true
}

clear_row :: proc(grid: ^Grid, row: int) {
	for column := 0; column < grid.num_cols; column += 1 {
		grid.grid[row][column] = 0
	}
}

move_row_down :: proc(grid: ^Grid, row: int, num_rows: int) {
	for column := 0; column < grid.num_cols; column += 1 {
		grid.grid[row + num_rows][column] = grid.grid[row][column]
		grid.grid[row][column] = 0
	}
}

draw_grid :: proc(grid: ^Grid) {
	for row := 0; row < grid.num_rows; row += 1 {
		for column := 0; column < grid.num_cols; column += 1 {
			cell_value := grid.grid[row][column]
			rl.DrawRectangle(
				i32(column * grid.cell_size + 11),
				i32(row * grid.cell_size + 11),
				i32(grid.cell_size - 1),
				i32(grid.cell_size - 1),
				grid.colors[cell_value],
			)
		}
	}
}
