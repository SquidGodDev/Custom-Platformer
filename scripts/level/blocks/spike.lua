import "scripts/level/blocks/hazard"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Spike').extends(Hazard)

function Spike:init(x)
    Spike.super.init(self)

    local spikeImage = gfx.image.new("images/blocks/spike")
    self.width = self:getSize()
    self:setImage(spikeImage)
    self:setCenter(0, 0)
    self:moveTo(x, LEVEL_BASE_Y - 16)
    self:add()

    self:setCollideRect(0, 14, 32, 19)
end