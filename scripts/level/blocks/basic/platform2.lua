import "scripts/level/blocks/basic/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform2').extends(Wall)

function Platform2:init(x)
    local blockImage = gfx.image.new("images/blocks/platform2")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    Platform2.super.init(self, x, LEVEL_BASE_Y)
end