package tetris

import rl "vendor:raylib"

darkgrey :: rl.Color{26, 31, 40, 255}
green :: rl.Color{47, 230, 23, 255}
red :: rl.Color{232, 18, 18, 255}
orange :: rl.Color{226, 116, 17, 255}
yellow :: rl.Color{237, 234, 4, 255}
purple :: rl.Color{166, 0, 247, 255}
cyan :: rl.Color{21, 204, 209, 255}
blue :: rl.Color{13, 64, 216, 255}
lightblue :: rl.Color{59, 85, 162, 255}
darkblue :: rl.Color{44, 44, 127, 255}

get_cell_colors :: proc() -> [dynamic]rl.Color {
	colors := make([dynamic]rl.Color, 0, 8)

	append(&colors, darkgrey)
	append(&colors, green)
	append(&colors, red)
	append(&colors, orange)
	append(&colors, yellow)
	append(&colors, purple)
	append(&colors, cyan)
	append(&colors, blue)

	return colors
}

colors_deinit :: proc(colors: [dynamic]rl.Color) {
	delete(colors)
}
