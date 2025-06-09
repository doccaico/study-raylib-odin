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

entity_update :: proc(entity: ^Entity) {
	if !entity.alive {
		return
	}

	// move
	entity.position = entity.position + (entity.velocity * get_delta_time())

	// rotate
	entity.orientation += entity.rotational_velocity * get_delta_time()

	// normalize angle
	for entity.orientation > 180 {
		entity.orientation -= 360
	}
	for entity.orientation < -180 {
		entity.orientation += 360
	}
}

entity_collide :: proc(entity: ^Entity, other: ^Entity) -> bool {
	return(
		other.alive &&
		entity.alive &&
		rl.CheckCollisionCircles(entity.position, entity.radius, other.position, other.radius) \
	)
}
