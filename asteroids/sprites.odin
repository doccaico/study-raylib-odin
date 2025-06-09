package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

SpriteFrame :: struct {
	sheet:   int,
	frame:   rl.Rectangle,
	borders: rl.Rectangle,
}

sprite_frame_init :: proc(sheet: int, x, y, w, h: f32) -> SpriteFrame {
	sf: SpriteFrame

	sf.sheet = sheet
	sf.frame = {x, y, w, h}

	return sf
}

sprites_sprite_sheets: [dynamic]rl.Texture
sprites_frames: [dynamic]SpriteFrame
sprites_asteroid_sprites: [dynamic]int

sprites_ship_sprite := 0
sprites_shot_sprite := 0
sprites_thrust_sprite := 0
sprites_turbo_thust_sprite := 0
sprites_particle_sprite := 0

// UI
sprites_mini_map_sprite := 0
sprites_shield_icon := 0
sprites_boost_icon := 0

sprites_shield_bar := 0
sprites_boost_bar := 0

sprites_shield_progress := 0
sprites_boost_progress := 0

sprites_shield_hit_base := 0
sprites_shield_hit_mid := 0
sprites_shield_hit_end := 0

sprites_shield_powerup := 0
sprites_boost_powerup := 0
sprites_shot_powerup := 0

sprites_cursor := 0

sprites_nav_arrow := 0

sprites_add_frame :: proc(sheet_id: int, x, y, w, h: f32) -> int {
	append(&sprites_frames, sprite_frame_init(sheet_id, x, y, w, h))
	return len(sprites_frames) - 1
}

sprites_add_texture :: proc(name: cstring) -> int {
	tx := rl.LoadTexture(name)
	rl.GenTextureMipmaps(&tx)
	rl.SetTextureFilter(tx, .TRILINEAR)

	append(&sprites_sprite_sheets, tx)

	return len(sprites_sprite_sheets) - 1
}

sprites_init :: proc() {
	sprites_add_texture("resources/sheet.png")
	sprites_add_texture("resources/interfacePack_sheet@2.png")

	sprites_ship_sprite = sprites_add_frame(0, 224, 832, 99, 75)
	sprites_shot_sprite = sprites_add_frame(0, 843, 977, 13, 37)
	sprites_thrust_sprite = sprites_add_frame(0, 812, 206, 16, 40)
	sprites_turbo_thust_sprite = sprites_add_frame(0, 827, 867, 16, 38)
	sprites_particle_sprite = sprites_add_frame(0, 364, 814, 18, 18)

	sprites_mini_map_sprite = sprites_add_frame(1, 0, 344, 272, 272)

	sprites_shield_icon = sprites_add_frame(0, 482, 325, 34, 33)
	sprites_boost_icon = sprites_add_frame(0, 539, 989, 34, 33)
	sprites_boost_bar = sprites_add_frame(0, 0, 78, 222, 39)
	sprites_shield_bar = sprites_add_frame(0, 0, 39, 222, 39)

	sprites_shield_progress = sprites_add_frame(0, 774, 761, 34, 33)
	sprites_frames[sprites_shield_progress].borders = rl.Rectangle{12, 12, 22, 21}

	sprites_boost_progress = sprites_add_frame(0, 696, 329, 34, 33)
	sprites_frames[sprites_boost_progress].borders = rl.Rectangle{12, 12, 22, 21}

	sprites_shield_hit_end = sprites_add_frame(0, 0, 412, 133, 108)
	sprites_shield_hit_mid = sprites_add_frame(0, 0, 293, 143, 119)
	sprites_shield_hit_base = sprites_add_frame(0, 0, 156, 144, 137)

	sprites_shield_powerup = sprites_add_frame(0, 222, 129, 22, 21)
	sprites_boost_powerup = sprites_add_frame(0, 674, 262, 22, 21)
	sprites_shot_powerup = sprites_add_frame(0, 222, 108, 22, 21)

	sprites_cursor = sprites_add_frame(0, 382, 814, 17, 17)

	sprites_nav_arrow = sprites_add_frame(1, 832, 1152, 32, 36)

	append(&sprites_asteroid_sprites, sprites_add_frame(0, 224, 664, 101, 84))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 0, 520, 120, 98))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 518, 810, 89, 82))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 327, 452, 98, 96))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 651, 447, 43, 43))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 237, 452, 45, 40))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 406, 234, 28, 28))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 778, 587, 29, 26))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 224, 748, 101, 84))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 0, 618, 120, 98))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 516, 728, 89, 82))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 327, 548, 98, 96))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 674, 219, 43, 43))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 282, 452, 45, 40))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 406, 262, 28, 28))
	append(&sprites_asteroid_sprites, sprites_add_frame(0, 396, 413, 29, 26))
}

sprites_shutdown :: proc() {
	for sheet in sprites_sprite_sheets {
		rl.UnloadTexture(sheet)
	}
	delete(sprites_asteroid_sprites)
	delete(sprites_frames)
	delete(sprites_sprite_sheets)
}

sprites_draw :: proc() {

}
