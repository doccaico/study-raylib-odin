package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

Entity :: struct {
	alive:               bool,
	position:            rl.Vector2,
	orientation:         f32,
	velocity:            rl.Vector2,
	rotational_velocity: f32,
	radius:              f32,
}
