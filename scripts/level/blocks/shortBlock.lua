import "scripts/level/blocks/wall"

class('ShortBlock').extends(Wall)

function ShortBlock:init(x)
    self.width = 16
    self.height = 16
    ShortBlock.super.init(self, x, LEVEL_BASE_Y, self.width, self.height)
end