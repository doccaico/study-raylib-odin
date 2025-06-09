package asteroids

// import "core:fmt"
// import "core:mem"
import "core:math"
import rl "vendor:raylib"

player_nominal_shield: f32 : 1000
player_nominal_shield_recharge: f32 : 2
player_nominal_power: f32 : 1000
player_nominal_thrust: f32 : 400
player_nominal_boost_multiplyer: f32 : 3

player_base_reload_time: f32 = 0.5
player_shield_hit_max_life: f32 = 0.35
player_breaking_friction: f32 = 0.025

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

player_collide :: proc(player: ^Player, other: ^Entity) -> bool {
	if entity_collide(player, other) {
		explosion_create(other.position, other.radius)

		damage_factor: f32 = 1.0
		if player.boost {
			damage_factor = 3.0
		}

		player.shield -= other.radius * damage_factor

		sounds_play_sound_effect(sounds_sheld_hit)

		player.shield_hit_lifetime = player_shield_hit_max_life

		vect_to_hit := other.position - player.position
		player.shield_hit_angle = math.atan2_f32(vect_to_hit.x, -vect_to_hit.y) * rl.RAD2DEG

		if player.shield < 0 {
			explosion_create(player.position, 500)
			player.alive = false

			sounds_play_sound_effect(sounds_destoryed)
		}

		return true
	}

	return false
}
