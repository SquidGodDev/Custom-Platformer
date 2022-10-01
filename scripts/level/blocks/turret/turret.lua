import "scripts/level/blocks/wall"
import "scripts/level/blocks/turret/turretBullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Turret').extends(Wall)

function Turret:init(x, flipped)
    local blockImage = gfx.image.new("images/blocks/turret")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    Turret.super.init(self, x, LEVEL_BASE_Y - 38)

    if flipped then
        self:setImageFlip(gfx.kImageFlippedX, true)
    end

    local turretTime = 2000
    local turretTimer = pd.timer.new(turretTime, function()
        if flipped then
            TurretBullet(self.x + 32, self.y + 11, true)
        else
            TurretBullet(self.x, self.y + 11, false)
        end
    end)
    turretTimer.repeats = true
end