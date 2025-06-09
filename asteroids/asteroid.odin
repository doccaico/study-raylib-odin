package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

Asteroid :: struct {
	using entity: Entity,
	sprite:       int,
	tint:         rl.Color,
}
