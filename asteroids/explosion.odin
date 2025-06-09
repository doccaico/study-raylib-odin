package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

Explosion :: struct {
	using entity: Entity,
	// tint = rl.WHITE
	tint:         rl.Color,
	lifetime:     f32,
	particles:    [dynamic]Entity,
}
