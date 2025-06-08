package tetris

import rl "vendor:raylib"

blocks_deinit :: proc(blocks: [dynamic]Block) {
	// for block in blocks {
	// 	switch block.id {
	// 	case 1 ..< 4:
	// 		for i := 0; i < 4; i += 1 {
	// 			delete(block.cells[i])
	// 		}
	// 	case 4:
	// 		delete(block.cells[0])
	// 	case 5 ..< 8:
	// 		for i := 0; i < 4; i += 1 {
	// 			delete(block.cells[i])
	// 		}
	// 	}
	// }
	for &block in blocks {
		block_deinitialize(&block)
	}
	delete(blocks)
}

LBlock :: struct {
	using block: Block,
}

lblock :: proc() -> Block {
	lblock: LBlock

	block_initialize(&lblock)

	lblock.id = 1

	lblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&lblock.cells[0], position(0, 2))
	append(&lblock.cells[0], position(1, 0))
	append(&lblock.cells[0], position(1, 1))
	append(&lblock.cells[0], position(1, 2))

	lblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&lblock.cells[1], position(0, 1))
	append(&lblock.cells[1], position(1, 1))
	append(&lblock.cells[1], position(2, 1))
	append(&lblock.cells[1], position(2, 2))

	lblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&lblock.cells[2], position(1, 0))
	append(&lblock.cells[2], position(1, 1))
	append(&lblock.cells[2], position(1, 2))
	append(&lblock.cells[2], position(2, 0))

	lblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&lblock.cells[3], position(0, 0))
	append(&lblock.cells[3], position(0, 1))
	append(&lblock.cells[3], position(1, 1))
	append(&lblock.cells[3], position(2, 1))

	move(&lblock, 0, 3)

	return lblock
}

JBlock :: struct {
	using block: Block,
}

jblock :: proc() -> Block {
	jblock: JBlock

	block_initialize(&jblock)

	jblock.id = 2

	jblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&jblock.cells[0], position(0, 0))
	append(&jblock.cells[0], position(1, 0))
	append(&jblock.cells[0], position(1, 1))
	append(&jblock.cells[0], position(1, 2))

	jblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&jblock.cells[1], position(0, 1))
	append(&jblock.cells[1], position(0, 2))
	append(&jblock.cells[1], position(1, 1))
	append(&jblock.cells[1], position(2, 1))

	jblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&jblock.cells[2], position(1, 0))
	append(&jblock.cells[2], position(1, 1))
	append(&jblock.cells[2], position(1, 2))
	append(&jblock.cells[2], position(2, 2))

	jblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&jblock.cells[3], position(0, 1))
	append(&jblock.cells[3], position(1, 1))
	append(&jblock.cells[3], position(2, 0))
	append(&jblock.cells[3], position(2, 1))

	move(&jblock, 0, 3)

	return jblock
}

IBlock :: struct {
	using block: Block,
}

iblock :: proc() -> Block {
	iblock: IBlock

	block_initialize(&iblock)

	iblock.id = 3

	iblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&iblock.cells[0], position(1, 0))
	append(&iblock.cells[0], position(1, 1))
	append(&iblock.cells[0], position(1, 2))
	append(&iblock.cells[0], position(1, 3))

	iblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&iblock.cells[1], position(0, 2))
	append(&iblock.cells[1], position(1, 2))
	append(&iblock.cells[1], position(2, 2))
	append(&iblock.cells[1], position(3, 2))

	iblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&iblock.cells[2], position(2, 0))
	append(&iblock.cells[2], position(2, 1))
	append(&iblock.cells[2], position(2, 2))
	append(&iblock.cells[2], position(2, 3))

	iblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&iblock.cells[3], position(0, 1))
	append(&iblock.cells[3], position(1, 1))
	append(&iblock.cells[3], position(2, 1))
	append(&iblock.cells[3], position(3, 1))

	move(&iblock, -1, 3)

	return iblock
}

OBlock :: struct {
	using block: Block,
}

oblock :: proc() -> Block {
	oblock: OBlock

	block_initialize(&oblock)

	oblock.id = 4

	oblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&oblock.cells[0], position(0, 0))
	append(&oblock.cells[0], position(0, 1))
	append(&oblock.cells[0], position(1, 0))
	append(&oblock.cells[0], position(1, 1))

	move(&oblock, 0, 4)

	return oblock
}

SBlock :: struct {
	using block: Block,
}

sblock :: proc() -> Block {
	sblock: SBlock

	block_initialize(&sblock)

	sblock.id = 5

	sblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&sblock.cells[0], position(0, 1))
	append(&sblock.cells[0], position(0, 2))
	append(&sblock.cells[0], position(1, 0))
	append(&sblock.cells[0], position(1, 1))

	sblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&sblock.cells[1], position(0, 1))
	append(&sblock.cells[1], position(1, 1))
	append(&sblock.cells[1], position(1, 2))
	append(&sblock.cells[1], position(2, 2))

	sblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&sblock.cells[2], position(1, 1))
	append(&sblock.cells[2], position(1, 2))
	append(&sblock.cells[2], position(2, 0))
	append(&sblock.cells[2], position(2, 1))

	sblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&sblock.cells[3], position(0, 0))
	append(&sblock.cells[3], position(1, 0))
	append(&sblock.cells[3], position(1, 1))
	append(&sblock.cells[3], position(2, 1))

	move(&sblock, 0, 3)

	return sblock
}

TBlock :: struct {
	using block: Block,
}

tblock :: proc() -> Block {
	tblock: TBlock

	block_initialize(&tblock)

	tblock.id = 6

	tblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&tblock.cells[0], position(0, 1))
	append(&tblock.cells[0], position(1, 0))
	append(&tblock.cells[0], position(1, 1))
	append(&tblock.cells[0], position(1, 2))

	tblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&tblock.cells[1], position(0, 1))
	append(&tblock.cells[1], position(1, 1))
	append(&tblock.cells[1], position(1, 2))
	append(&tblock.cells[1], position(2, 1))

	tblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&tblock.cells[2], position(1, 0))
	append(&tblock.cells[2], position(1, 1))
	append(&tblock.cells[2], position(1, 2))
	append(&tblock.cells[2], position(2, 1))

	tblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&tblock.cells[3], position(0, 1))
	append(&tblock.cells[3], position(1, 0))
	append(&tblock.cells[3], position(1, 1))
	append(&tblock.cells[3], position(2, 1))

	move(&tblock, 0, 3)

	return tblock
}

ZBlock :: struct {
	using block: Block,
}

zblock :: proc() -> Block {
	zblock: ZBlock

	block_initialize(&zblock)

	zblock.id = 7

	zblock.cells[0] = make([dynamic]Position, 0, 4)
	append(&zblock.cells[0], position(0, 0))
	append(&zblock.cells[0], position(0, 1))
	append(&zblock.cells[0], position(1, 1))
	append(&zblock.cells[0], position(1, 2))

	zblock.cells[1] = make([dynamic]Position, 0, 4)
	append(&zblock.cells[1], position(0, 2))
	append(&zblock.cells[1], position(1, 1))
	append(&zblock.cells[1], position(1, 2))
	append(&zblock.cells[1], position(2, 1))

	zblock.cells[2] = make([dynamic]Position, 0, 4)
	append(&zblock.cells[2], position(1, 0))
	append(&zblock.cells[2], position(1, 1))
	append(&zblock.cells[2], position(2, 1))
	append(&zblock.cells[2], position(2, 2))

	zblock.cells[3] = make([dynamic]Position, 0, 4)
	append(&zblock.cells[3], position(0, 1))
	append(&zblock.cells[3], position(1, 0))
	append(&zblock.cells[3], position(1, 1))
	append(&zblock.cells[3], position(2, 0))

	move(&zblock, 0, 3)

	return zblock
}
