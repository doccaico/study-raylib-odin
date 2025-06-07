package tetris

Position :: struct {
	row:    int,
	column: int,
}

position :: proc(row: int, column: int) -> Position {
	position: Position

	position.row = row
	position.column = column

	return position
}
