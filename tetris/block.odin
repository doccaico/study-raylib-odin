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

block_initialize :: proc(block: ^Block) {
	block.cell_size = 30
	block.rotation_state = 0
	block.colors = get_cell_colors()
	block.row_offset = 0
	block.column_offset = 0
}

block_deinitialize :: proc(block: ^Block) {
	switch block.id {
	case 1 ..< 4:
		for i := 0; i < 4; i += 1 {
			delete(block.cells[i])
		}
	case 4:
		delete(block.cells[0])
	case 5 ..< 8:
		for i := 0; i < 4; i += 1 {
			delete(block.cells[i])
		}
	}

	delete(block.cells)
	delete(block.colors)
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

draw_block :: proc(block: ^Block, offset_x: int, offset_y: int) {
	tiles := get_cell_positions(block)
	defer delete(tiles)
	for item in tiles {
		rl.DrawRectangle(
			i32(item.column * block.cell_size + offset_x),
			i32(item.row * block.cell_size + offset_y),
			i32(block.cell_size - 1),
			i32(block.cell_size - 1),
			block.colors[block.id],
		)
	}
}
