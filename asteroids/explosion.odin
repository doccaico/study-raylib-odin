package asteroids

// import "core:fmt"
// import "core:mem"
import "core:math"
import rl "vendor:raylib"

explosion_max_lifetime: f32 : 0.5

Explosion :: struct {
	using entity: Entity,
	// tint = rl.WHITE
	tint:         rl.Color,
	lifetime:     f32,
	particles:    [dynamic]Entity,
}

explosion_create :: proc(pos: rl.Vector2, size: f32) {
	slot: ^Explosion = nil
	// find an empty shot

	for &explosion in world_instance.explosions {
		if !explosion.alive {
			slot = &explosion
			break
		}
	}

	if slot == nil {
		append(&world_instance.explosions, Explosion{})
		last_index := len(world_instance.explosions) - 1
		slot = &world_instance.explosions[last_index]
	}

	slot.alive = true
	slot.position = pos
	slot.velocity = {0, 0}
	slot.orientation = 0
	slot.rotational_velocity = 0
	slot.lifetime = explosion_max_lifetime

	clear(&slot.particles)

	particles := rl.GetRandomValue(3, 8)

	add := i32(size / 3.0)
	particles += add

	for i := 0; i < int(particles); i += 1 {
		particle: Entity
		particle.alive = true
		particle.orientation = f32(rl.GetRandomValue(0, 180))
		particle.rotational_velocity = f32(rl.GetRandomValue(180, 720))

		random_angle := f32(rl.GetRandomValue(-180, 180)) * rl.DEG2RAD
		random_speed := f32(rl.GetRandomValue(20, 500))

		particle.velocity = {
			math.cos_f32(random_angle) * random_speed,
			math.sin_f32(random_angle) * random_speed,
		}

		append(&slot.particles, particle)
	}
}
