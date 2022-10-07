import "scripts/level/blocks/basic/wall"
import "scripts/level/blocks/hazard"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('VerticalMovingSpike').extends(Hazard)

function VerticalMovingSpike:init(x)
    VerticalMovingSpike.super.init(self)
    self.width = 32
    local spikeBallImage = gfx.image.new("images/blocks/spikeBall")
    self:setImage(spikeBallImage)
    self:setCenter(0, 0)
    self.minY = LEVEL_BASE_Y
    self.maxY = self.minY - 32 * 3
    self.movingUp = true
    self:moveTo(x, self.minY)
    self:add()

    self.moveSpeed = 2

    self:setCollideRect(4, 4, 24, 24)

    Wall(x, LEVEL_BASE_Y, self.width, 16)
end

function VerticalMovingSpike:update()
    if self.movingUp then
        self:moveBy(0, -self.moveSpeed)
        if self.y <= self.maxY then
            self.movingUp = false
        end
    else
        self:moveBy(0, self.moveSpeed)
        if self.y >= self.minY then
            self.movingUp = true
        end
    end
end