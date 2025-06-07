package tetris

import rl "vendor:raylib"

Block :: struct {
	id:             int,
	cells:          map[int][dynamic]Position,
	cell_size:      int,
	rotation_state: int,
	colors:         [dynamic]rl.Color,
	row_offset:     int,
	column_offset:  int,
}

move :: proc(block: ^Block, rows: int, columns: int) {
	block.row_offset += rows
	block.column_offset += columns
}

get_cell_positions :: proc(block: ^Block) -> [dynamic]Position {
	tiles := block.cells[block.rotation_state]
	moved_tiles: [dynamic]Position
	for item in tiles {
		new_pos := Position{item.row + block.row_offset, item.column + block.column_offset}
		append(&moved_tiles, new_pos)
	}
	return moved_tiles
}

rotate :: proc(block: ^Block) {
	block.rotation_state += 1
	if block.rotation_state == len(block.cells) {
		block.rotation_state = 0
	}
}

undo_rotation :: proc(block: ^Block) {
	block.rotation_state -= 1
	if block.rotation_state == -1 {
		block.rotation_state = len(block.cells) - 1
	}
}
