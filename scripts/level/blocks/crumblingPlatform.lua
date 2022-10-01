import "scripts/level/blocks/wall"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('CrumblingPlatform').extends(Wall)

function CrumblingPlatform:init(x)
    local blockImage = gfx.image.new("images/blocks/crumblingPlatform")
    self:setImage(blockImage)
    self.width = self:getSize()

    self:setCollideRect(0, 0, self:getSize())

    CrumblingPlatform.super.init(self, x, LEVEL_BASE_Y)

    self.crumbling = false

    self.crumbleTime = 1000
    self.crumbleRespawnTime = 2000
end

function CrumblingPlatform:collided()
    if self.crumbling then
        return
    end

    self.crumbling = true
    pd.timer.new(self.crumbleTime, function()
        self:remove()
        pd.timer.new(self.crumbleRespawnTime, function()
            self.crumbling = false
            self:add()
        end)
    end)
end