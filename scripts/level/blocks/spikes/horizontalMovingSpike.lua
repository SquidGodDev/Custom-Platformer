import "scripts/level/blocks/basic/wall"
import "scripts/level/blocks/hazard"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('HorizontalMovingSpike').extends(Hazard)

function HorizontalMovingSpike:init(x, y)
    HorizontalMovingSpike.super.init(self)
    self.width = 32
    local spikeBallImage = gfx.image.new("images/blocks/spikeBall")
    self:setImage(spikeBallImage)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self.moveSpeed = 2
    self.direction = 1

    self:setCollideRect(4, 4, 24, 24)
    self:setCollidesWithGroups({COLLISION_GROUPS.player, COLLISION_GROUPS.wall})
    self.collisionResponse = gfx.sprite.kCollisionTypeFreeze
end

function HorizontalMovingSpike:update()
    local touchedWall = false
    local _, _, collisions, _ = self:moveWithCollisions(self.x + self:getVelocity(), self.y)
    for _, collision in ipairs(collisions) do
        if collision.other:isa(Wall) then
            touchedWall = true
        end
    end
    if touchedWall then
        self.direction *= -1
    end
end

function HorizontalMovingSpike:getVelocity()
    return self.direction * self.moveSpeed
end