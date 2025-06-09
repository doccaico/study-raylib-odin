package asteroids

// import "core:fmt"
// import "core:mem"
import rl "vendor:raylib"

player_nominal_shield: f32 : 1000
player_nominal_shield_recharge: f32 : 2
player_nominal_power: f32 : 1000
player_nominal_thrust: f32 : 400
player_nominal_boost_multiplyer: f32 : 3

Player :: struct {
	using entity:          Entity,
	reload:                f32,
	thrusting:             bool,
	boost:                 bool,
	shot_speed_multiplyer: f32,

	// float MaxShield = NominalShield;
	max_shield:            f32,
	// float Shield = MaxShield;
	shield:                f32,

	// float MaxPower = NominalPower;
	max_power:             f32,
	// float Power = MaxPower;
	power:                 f32,

	// float MaxThrust = NominalThrust;
	max_thrust:            f32,
	// float BoostMultiplyer = NominalBoostMultiplyer;
	boost_multiplyer:      f32,

	// float ShieldRecharge = NominalShieldRecharge;
	shield_recharge:       f32,
	shield_hit_angle:      f32,
	shield_hit_lifetime:   f32,
	score:                 int,
}

player_reset :: proc(player: ^Player) {
	player.alive = true
	player.score = 0
	player.power = player.max_power
	player.shield = player.max_shield
	player.boost_multiplyer = player_nominal_boost_multiplyer
	player.max_thrust = player_nominal_thrust
	player.shield_recharge = player_nominal_shield_recharge
	player_respawn(player)
}

player_respawn :: proc(player: ^Player) {
	player.boost = false
	player.thrusting = false

	sounds_set_thrust_state(player.thrusting, player.boost)

	player.velocity = {0, 0}
	player.position = {0, 0}
	player.orientation = 0
	player.reload = 0
}
