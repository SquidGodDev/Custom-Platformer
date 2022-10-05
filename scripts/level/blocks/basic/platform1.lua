import "scripts/level/blocks/basic/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform1').extends(Wall)

function Platform1:init(x)
    local blockImage = gfx.image.new("images/blocks/platform1")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    Platform1.super.init(self, x, LEVEL_BASE_Y)
end