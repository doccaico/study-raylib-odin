package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

Asteroid :: struct {
	using entity: Entity,
	sprite:       int,
	tint:         rl.Color,
}

asteroid_update :: proc(asteroid: ^Asteroid) {
	entity_update(asteroid)
	if !asteroid.alive {
		return
	}
	// World::Instance->BounceBounds(*this);
	world_bounce_bounds(world_instance, asteroid)
}

asteroid_draw :: proc(asteroid: ^Asteroid) {
	if !asteroids.alive {
		return
	}

	// TODO
	Sprites :: Draw(Sprite, Position, Orientation, Radius, Tint)
}
