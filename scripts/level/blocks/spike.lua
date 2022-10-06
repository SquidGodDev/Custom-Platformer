import "scripts/level/blocks/hazard"
import "scripts/level/blocks/basic/platform1"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Spike').extends(Hazard)

function Spike:init(x, y)
    Spike.super.init(self)
    Platform1(x, y)

    local spikeImage = gfx.image.new("images/blocks/spike")
    self.width = self:getSize()
    self:setImage(spikeImage)
    self:setCenter(0, 0)
    self:moveTo(x, y - 16)
    self:add()

    self:setCollideRect(6, 6, 20, 8)
end