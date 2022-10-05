import "scripts/level/blocks/basic/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MovingPlatform').extends(Wall)

function MovingPlatform:init(x)
    local blockImage = gfx.image.new("images/blocks/platformShort")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups({COLLISION_GROUPS.player, COLLISION_GROUPS.wall})

    self.moveSpeed = 2
    self.direction = 1

    MovingPlatform.super.init(self, x, LEVEL_BASE_Y)
end

function MovingPlatform:update()
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

function MovingPlatform:getVelocity()
    return self.direction * self.moveSpeed
end