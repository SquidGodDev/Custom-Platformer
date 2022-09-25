import "scripts/level/blocks/wall"

class('MediumBlock').extends(Wall)

function MediumBlock:init(x)
    self.width = 32
    self.height = 16
    MediumBlock.super.init(self, x, LEVEL_BASE_Y, self.width, self.height)
end