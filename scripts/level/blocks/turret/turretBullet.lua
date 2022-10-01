import "scripts/level/blocks/hazard"
import "scripts/level/blocks/turret/turretBullet"
import "scripts/level/player/player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('TurretBullet').extends(Hazard)

function TurretBullet:init(x, y, flipped)
    TurretBullet.super.init(self)
    self:setCollidesWithGroups({COLLISION_GROUPS.player, COLLISION_GROUPS.wall})
    local bulletSize = 16
    local blockImage = gfx.image.new(bulletSize, bulletSize)
    gfx.pushContext(blockImage)
        gfx.fillCircleInRect(0, 0, bulletSize, bulletSize)
    gfx.popContext()
    self:setImage(blockImage)

    self:setCollideRect(0, 0, self:getSize())

    self:moveTo(x, y)
    self:add()

    self.speed = 3
    if flipped then
        self.direction = 1
    else
        self.direction = -1
    end

    self.despawnTime = 10000
    pd.timer.new(self.despawnTime, function()
        self:remove()
    end)
end

function TurretBullet:update()
    local _, _, collisions, _ = self:moveWithCollisions(self.x + self.speed * self.direction, self.y)
    for _, collision in ipairs(collisions) do
        if collision.other:isa(Player) then
            collision.other:resetPlayer()
            self:remove()
        elseif not collision.other:isa(Turret) then
            self:remove()
        end
    end
end