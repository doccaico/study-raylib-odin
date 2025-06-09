package asteroids

// import "core:fmt"
// import "core:mem"
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
