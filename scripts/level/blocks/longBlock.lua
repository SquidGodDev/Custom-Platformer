import "scripts/level/blocks/wall"

class('LongBlock').extends(Wall)

function LongBlock:init(x)
    self.width = 64
    self.height = 16
    LongBlock.super.init(self, x, LEVEL_BASE_Y, self.width, self.height)
end