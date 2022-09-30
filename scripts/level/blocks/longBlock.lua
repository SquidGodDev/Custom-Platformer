import "scripts/level/blocks/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('LongBlock').extends(Wall)

function LongBlock:init(x)
    local blockImage = gfx.image.new("images/blocks/platformLong")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    LongBlock.super.init(self, x, LEVEL_BASE_Y)
end