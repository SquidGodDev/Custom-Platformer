import "scripts/level/blocks/basic/platform1"
import "scripts/level/blocks/turret/turretBullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Turret').extends(Wall)

function Turret:init(x, y, flipped)
    local blockImage = gfx.image.new("images/blocks/turret")
    self:setImage(blockImage)
    self.width = self:getSize()

    -- self:setCollideRect(0, 0, self:getSize())

    Turret.super.init(self, x, y - 48)
    Platform1(x, y)

    if flipped then
        self:setImageFlip(gfx.kImageFlippedX, true)
    end

    local turretTime = 2000
    local turretTimer = pd.timer.new(turretTime, function()
        if flipped then
            TurretBullet(self.x + 32, y - 28, true)
        else
            TurretBullet(self.x, y - 28, false)
        end
    end)
    turretTimer.repeats = true
end