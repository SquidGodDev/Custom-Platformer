import "scripts/level/blocks/basic/wall"
import "scripts/level/blocks/hazard"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('MovingSpike').extends(Hazard)

function MovingSpike:init(x)
    MovingSpike.super.init(self)
    self.width = 32
    local spikeBallImage = gfx.image.new("images/blocks/spikeBall")
    self:setImage(spikeBallImage)
    self:setCenter(0, 0)
    self.minY = LEVEL_BASE_Y - 16
    self.maxY = self.minY - 96
    self.movingUp = true
    self:moveTo(x, self.minY)
    self:add()

    self.moveSpeed = 1

    self:setCollideRect(0, 0, self:getSize())

    Wall(x, LEVEL_BASE_Y, self.width, 16)
end

function MovingSpike:update()
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