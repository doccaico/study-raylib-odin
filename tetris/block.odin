package tetris

import rl "vendor:raylib"

move :: proc(block: ^Block, rows: int, columns: int) {
	block.row_offset += rows
	block.column_offset += columns
}
