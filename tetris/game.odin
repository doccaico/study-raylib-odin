package tetris

import rl "vendor:raylib"

Game :: struct {
	gameover:     bool,
	score:        int,
	music:        rl.Music,
	grid:         Grid,
	// blocks:        [dynamic]Block,
	// current_block: Block,
	// next_block:    Block,
	rotate_sound: rl.Sound,
	clear_sound:  rl.Sound,
}

game :: proc() -> Game {
	game: Game
	game.grid = grid()

	return game
}
