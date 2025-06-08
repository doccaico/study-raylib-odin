package tetris

import "core:fmt"
import "core:math/rand"
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
	game.gameover = false
	game.score = 0
	rl.InitAudioDevice()
	game.music = rl.LoadMusicStream("sounds/music.mp3")
	rl.PlayMusicStream(game.music)
	game.rotate_sound = rl.LoadSound("sounds/rotate.mp3")
	game.clear_sound = rl.LoadSound("sounds/clear.mp3")

	return game
}

game_deinit :: proc(game: ^Game) {
	blocks_deinit(game.blocks)
	grid_deinit(&game.grid)

	rl.UnloadSound(game.rotate_sound)
	rl.UnloadSound(game.clear_sound)
	rl.UnloadMusicStream(game.music)
	rl.CloseAudioDevice()
}

get_all_blocks :: proc() -> [dynamic]Block {
	blocks := make([dynamic]Block, 0, 7)

	append(&blocks, iblock())
	append(&blocks, jblock())
	append(&blocks, lblock())
	append(&blocks, oblock())
	append(&blocks, sblock())
	append(&blocks, tblock())
	append(&blocks, zblock())

	return blocks
}

get_random_block :: proc(game: ^Game) -> Block {
	//
	// Meaningless code.
	//
	// if len(game.blocks) == 0 {
	// 	game.blocks = get_all_blocks()
	// }

	random_index := rand.int31() % i32(len(game.blocks))
	block := game.blocks[random_index]

	//
	// The source of the memory leak. Maybe.
	//
	// ordered_remove(&game.blocks, random_index)

	return block
}

handle_input :: proc(game: ^Game) {
	key_pressed := rl.GetKeyPressed()
	if game.gameover && key_pressed != .KEY_NULL {
		game.gameover = false
		reset(game)
	}
	#partial switch key_pressed {
	case .LEFT:
		move_block_left(game)
	case .RIGHT:
		move_block_right(game)
	case .DOWN:
		move_block_down(game)
		update_score(game, 0, 1)
	case .UP:
		rotate_block(game)
	}
}

reset :: proc(game: ^Game) {
	grid_initialize(&game.grid)
	//
	// Unnecessary code.
	//
	// game.blocks = get_all_blocks()
	game.current_block = get_random_block(game)
	game.next_block = get_random_block(game)
	game.score = 0
}

move_block_left :: proc(game: ^Game) {
	if !game.gameover {
		move(&game.current_block, 0, -1)
		if is_block_outside(game) || block_fits(game) == false {
			move(&game.current_block, 0, 1)
		}
	}
}

move_block_right :: proc(game: ^Game) {
	if !game.gameover {
		move(&game.current_block, 0, 1)
		if is_block_outside(game) || block_fits(game) == false {
			move(&game.current_block, 0, -1)
		}
	}
}

move_block_down :: proc(game: ^Game) {
	if !game.gameover {
		move(&game.current_block, 1, 0)
		if is_block_outside(game) || block_fits(game) == false {
			move(&game.current_block, -1, 0)
			lock_block(game)
		}
	}
}

is_block_outside :: proc(game: ^Game) -> bool {
	tiles := get_cell_positions(&game.current_block)
	defer delete(tiles)
	for item in tiles {
		if is_cell_outside(&game.grid, item.row, item.column) {
			return true
		}
	}
	return false
}

block_fits :: proc(game: ^Game) -> bool {
	tiles := get_cell_positions(&game.current_block)
	defer delete(tiles)
	for item in tiles {
		if is_cell_empty(&game.grid, item.row, item.column) == false {
			return false
		}
	}
	return true
}

lock_block :: proc(game: ^Game) {
	tiles := get_cell_positions(&game.current_block)
	defer delete(tiles)
	for item in tiles {
		game.grid.grid[item.row][item.column] = game.current_block.id
	}

	game.current_block = game.next_block

	if block_fits(game) == false {
		game.gameover = true
	}

	game.next_block = get_random_block(game)
	rows_cleared := clear_full_rows(&game.grid)
	if rows_cleared > 0 {
		rl.PlaySound(game.clear_sound)
		update_score(game, rows_cleared, 0)
	}
}

update_score :: proc(game: ^Game, lines_cleared: int, move_down_points: int) {
	switch lines_cleared {
	case 1:
		game.score += 100
	case 2:
		game.score += 300
	case 3:
		game.score += 500
	case:
		break
	}
	game.score += move_down_points
}

rotate_block :: proc(game: ^Game) {
	if !game.gameover {
		rotate(&game.current_block)
		if is_block_outside(game) || block_fits(game) == false {
			undo_rotation(&game.current_block)
		} else {
			rl.PlaySound(game.rotate_sound)
		}
	}
}

draw_game :: proc(game: ^Game) {
	draw_grid(&game.grid)
	draw_block(&game.current_block, 11, 11)

	switch game.next_block.id {
	case 3:
		draw_block(&game.next_block, 255, 290)
	case 4:
		draw_block(&game.next_block, 255, 280)
	case:
		draw_block(&game.next_block, 270, 270)
	}
}
