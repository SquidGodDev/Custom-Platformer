
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Wall').extends(gfx.sprite)

function Wall:init(x, y, width, height)
    local rectImage = gfx.image.new(width, height, gfx.kColorBlack)
    self:setImage(rectImage)

    self:setCenter(0, 0)
    self:moveTo(x, y)

    self:setCollideRect(0, 0, width, height)
    self:setGroups(COLLISION_GROUPS.wall)
    self:setCollidesWithGroups(COLLISION_GROUPS.player)
    self:add()
end