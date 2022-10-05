
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Wall').extends(gfx.sprite)

function Wall:init(x, y)
    self:setCenter(0, 0)
    self:moveTo(x, y)

    self:setGroups(COLLISION_GROUPS.wall)
    self:add()
end