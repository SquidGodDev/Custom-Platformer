import "scripts/level/blocks/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShortBlock').extends(Wall)

function ShortBlock:init(x)
    local blockImage = gfx.image.new("images/blocks/platformShort")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    ShortBlock.super.init(self, x, LEVEL_BASE_Y)
end