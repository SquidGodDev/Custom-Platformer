import "scripts/level/blocks/hazard"
import "scripts/level/blocks/basic/platform1"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Spur').extends(Hazard)

function Spur:init(x, y)
    Spur.super.init(self)

    local spurImage = gfx.image.new("images/blocks/spur")
    self.width = self:getSize()
    self:setImage(spurImage)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:setCollideRect(8, 8, 16, 16)
end