import "scripts/level/blocks/basic/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform3').extends(Wall)

function Platform3:init(x, y)
    local blockImage = gfx.image.new("images/blocks/platform3")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    Platform3.super.init(self, x, y)
end