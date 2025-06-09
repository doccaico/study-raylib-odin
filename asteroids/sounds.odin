package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

sounds_effects: [dynamic]rl.Sound

sounds_bgm: rl.Music
sounds_thrust: rl.Music
sounds_boost: rl.Music

sounds_asteroid_hit := 0
sounds_destoryed := 0
sounds_sheld_hit := 0
sounds_shot := 0
sounds_upgrade := 0
sounds_gameover := 0
sounds_begin := 0

sounds_add_effect :: proc(name: cstring) -> int {
	append(&sounds_effects, rl.LoadSound(name))
	return len(sounds_effects) - 1
}

sounds_init :: proc() {
	rl.InitAudioDevice()

	sounds_bgm = rl.LoadMusicStream("resources/bgm.ogg")
	sounds_bgm.looping = true
	rl.SetMusicVolume(sounds_bgm, 0.25)

	sounds_thrust = rl.LoadMusicStream("resources/thruster.ogg")
	sounds_thrust.looping = true
	rl.SetMusicVolume(sounds_thrust, 1.0)

	sounds_boost = rl.LoadMusicStream("resources/boost.ogg")
	sounds_boost.looping = true

	sounds_asteroid_hit = sounds_add_effect("resources/asteroid_hit.ogg")
	sounds_destoryed = sounds_add_effect("resources/destoryed.ogg")
	sounds_sheld_hit = sounds_add_effect("resources/shield_hit.ogg")
	sounds_shot = sounds_add_effect("resources/shot.ogg")
	sounds_upgrade = sounds_add_effect("resources/upgrade.ogg")
	sounds_gameover = sounds_add_effect("resources/game_over.ogg")
	sounds_begin = sounds_add_effect("resources/begin.ogg")
}

sounds_shutdown :: proc() {
	if rl.IsMusicStreamPlaying(sounds_bgm) {
		rl.StopMusicStream(sounds_bgm)
	}

	if rl.IsMusicStreamPlaying(sounds_thrust) {
		rl.StopMusicStream(sounds_thrust)
	}

	if rl.IsMusicStreamPlaying(sounds_bgm) {
		rl.StopMusicStream(sounds_thrust)
	}

	rl.CloseAudioDevice()

	for effect in sounds_effects {
		rl.UnloadSound(effect)
	}

	delete(sounds_effects)
}

sounds_set_thrust_state :: proc(thrusting: bool, boosting: bool) {
	if !thrusting {
		if rl.IsMusicStreamPlaying(sounds_thrust) {
			rl.StopMusicStream(sounds_thrust)
		}
		if rl.IsMusicStreamPlaying(sounds_boost) {
			rl.StopMusicStream(sounds_boost)
		}
	} else {
		if !rl.IsMusicStreamPlaying(sounds_thrust) {
			rl.PlayMusicStream(sounds_thrust)
		}

		if boosting {
			if !rl.IsMusicStreamPlaying(sounds_boost) {
				rl.PlayMusicStream(sounds_boost)
			}
		} else {
			if rl.IsMusicStreamPlaying(sounds_boost) {
				rl.StopMusicStream(sounds_boost)
			}
		}
	}
}

sounds_update :: proc() {
	if rl.IsMusicStreamPlaying(sounds_bgm) {
		rl.UpdateMusicStream(sounds_bgm)
	}
	if rl.IsMusicStreamPlaying(sounds_thrust) {
		rl.UpdateMusicStream(sounds_thrust)
	}
	if rl.IsMusicStreamPlaying(sounds_boost) {
		rl.UpdateMusicStream(sounds_boost)
	}
}

sounds_start_bgm :: proc() {
	if !rl.IsMusicStreamPlaying(sounds_bgm) {
		rl.PlayMusicStream(sounds_bgm)
	}
}

sounds_stop_bgm :: proc() {
	if rl.IsMusicStreamPlaying(sounds_bgm) {
		rl.StopMusicStream(sounds_bgm)
	}
}
