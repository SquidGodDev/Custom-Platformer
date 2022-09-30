import "scripts/level/blocks/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MediumBlock').extends(Wall)

function MediumBlock:init(x)
    local blockImage = gfx.image.new("images/blocks/platformMedium")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    MediumBlock.super.init(self, x, LEVEL_BASE_Y)
end