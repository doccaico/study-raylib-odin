package tetris

import rl "vendor:raylib"

Game :: struct {
	gameover:      bool,
	score:         int,
	music:         rl.Music,
	grid:          Grid,
	blocks:        [dynamic]Block,
	current_block: Block,
	next_block:    Block,
	rotate_sound:  rl.Sound,
	clear_sound:   rl.Sound,
}

game :: proc() -> Game {
	game: Game
	game.grid = grid()
	game.blocks = get_all_blocks()
	game.current_block = get_random_block(&game)
	game.next_block = get_random_block(&game)


	return game
}

get_all_blocks :: proc() -> [dynamic]Block {
	blocks := make([dynamic]Block, 7)

	append(&blocks, iblock())
	append(&blocks, jblock())
	append(&blocks, lblock())
	append(&blocks, oblock())
	append(&blocks, sblock())
	append(&blocks, tblock())
	append(&blocks, zblock())

	return blocks
}

// https://github.com/educ8s/Cpp-Tetris-Game-with-raylib/blob/main/src/game.cpp
get_random_block :: proc(game: ^Game) -> Block {
	if len(game.blocks) == 0 {
		game.blocks = get_all_blocks()
	}

	return Block{}
}
