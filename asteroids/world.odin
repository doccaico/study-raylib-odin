package asteroids

// import "core:fmt"
// import "core:mem"
import "core:math"
import rl "vendor:raylib"


world_instance: ^World = nil

World :: struct {
	// bounds : rl.Rectangle{-6000, -6000, 12000, 12000 }
	bounds:                rl.Rectangle,
	asteroids:             [dynamic]Asteroid,
	bullets:               [dynamic]Bullet,
	explosions:            [dynamic]Explosion,
	power_ups:             [dynamic]PowerUp,
	player_ship:           Player,
	level_clear:           bool,
	active_asteroid_count: int,
}

world_create :: proc() -> ^World {
	if world_instance == nil {
		world_instance = new(World)
	}
	world_instance.bounds = {-6000, -6000, 12000, 12000}
	return world_instance
}

world_destory :: proc() {
	delete(world_instance.asteroids)
	delete(world_instance.bullets)
	delete(world_instance.explosions)
	delete(world_instance.power_ups)
	if world_instance != nil {
		free(world_instance)
	}
	world_instance = nil
}

world_reset :: proc(world: ^World, level: int = 1) {
	safe_rad: f32 = 200

	world.level_clear = false
	clear(&world.asteroids)
	clear(&world.bullets)
	clear(&world.explosions)
	clear(&world.power_ups)

	player_respawn(&world.player_ship)

	world.bounds.x = f32(-3000 - (level * 500.0))
	world.bounds.y = f32(-3000 - (level * 500.0))
	world.bounds.width = -(world.bounds.x * 2)
	world.bounds.height = -(world.bounds.x * 2)
}

world_update :: proc(world: ^World) {
	world.active_asteroid_count = 0

	for &asteroid in world.asteroids {
		asteroid_update(&asteroid)

		if player_collide(&world.player_ship, &asteroid) {
			asteroid.alive = false
		}
		if asteroid.alive {
			world.active_asteroid_count += 1
		}
	}
	// TODO
}

world_bounce_bounds :: proc(world: ^World, entity: ^Entity) -> bool {
	hit := false

	left := world.bounds.x + entity.radius
	right := world.bounds.x + world.bounds.width - entity.radius
	if entity.position.x < left {
		entity.position.x = left
		entity.velocity.x *= -1
		hit = true
	} else if entity.position.x > right {
		entity.position.x = right
		entity.velocity.x *= -1
		hit = true
	}

	top := world.bounds.y + entity.radius
	bottom := world.bounds.y + world.bounds.height - entity.radius
	if entity.position.y < top {
		entity.position.y = top
		entity.velocity.y *= -1
		hit = true
	} else if entity.position.y > bottom {
		entity.position.y = bottom
		entity.velocity.y *= -1
		hit = true
	}

	return hit
}

world_shake :: proc(world: ^World) -> bool {
	return world.player_ship.alive && world.player_ship.boost
}

world_draw :: proc(world: ^World, screen_in_world: ^rl.Rectangle) {
	thickness := f32(30 + math.sin_f32(f32(rl.GetTime() * 10) * 10))
	bounds := rl.Rectangle {
		world.bounds.x - thickness,
		world.bounds.y - thickness,
		world.bounds.width + thickness * 2,
		world.bounds.height + thickness + 2,
	}
	rl.DrawRectangleLinesEx(bounds, thickness, rl.BLUE)

	inner_thickness := thickness / 2
	inner_thickoffset := thickness - (thickness - innerThickness) / 2
	bounds = {
		bounds.x - inner_thickoffset,
		bounds.y - inner_thickoffset,
		bounds.width + inner_thickoffset * 2,
		bounds.height + inner_thickoffset + 2,
	}
	rl.DrawRectangleLinesEx(bounds, inner_thickness, rl.SKYBLUE)

	view_rad_sq =
		math.pow_f32(screen_in_world.width * 0.65, 2) +
		math.pow_f32(screen_in_world.height * 0.65, 2)

	for asteroid in world.asteroids {
		// only draw asteroids that are near our viewable window
		if asteroid.alive && rl.Vector2DistanceSqrt(world.player_ship.position, asteroid.position) < view_rad_sq + (math.pow_f32(asteroid.radius, 2)) {
			// TODO
			asteroid_draw(&asteroid)
	}

}
