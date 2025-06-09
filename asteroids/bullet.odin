package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

Bullet :: struct {
	using entity: Entity,
	// tint = rl.WHITE
	tint:         rl.Color,
	lifetime:     f32,
}
