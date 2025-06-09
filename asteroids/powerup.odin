package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

PowerType :: enum {
	Shot,
	Shield,
	Boost,
}

PowerUp :: struct {
	using entity: Entity,
	// PowerType Type = PowerType::Shot;
	type:         PowerType,
}
