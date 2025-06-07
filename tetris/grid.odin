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
