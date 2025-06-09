package asteroids

// import "core:fmt"
// import "core:mem"
import "core:math/rand"
import rl "vendor:raylib"

FIXED_FRAME_RATE :: 60

set_fps_cap :: proc() {
	when ODIN_DEBUG {
		rl.SetTargetFPS(FIXED_FRAME_RATE)
	} else {
		rl.SetTargetFPS(144)
	}
}

get_random_value_f :: proc(min: f32, max: f32) -> f32 {
	new_min := min
	new_max := max

	if min > max {
		tmp := new_max
		new_max = new_min
		new_min = tmp
	}

	param := f64(rand.int31() / 0x7fff)
	return f32(f64(new_min) + (f64(new_max) - f64(new_min)) * param)
}

get_random_vector2 :: proc(range: rl.Rectangle) -> rl.Vector2 {
	return {
		get_random_value_f(range.x, range.x + range.width),
		get_random_value_f(range.y, range.y + range.height),
	}
}
