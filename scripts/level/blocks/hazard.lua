local gfx <const> = playdate.graphics

class('Hazard').extends(gfx.sprite)

function Hazard:init()
    self.collisionResponse = gfx.sprite.kCollisionTypeOverlap
    self:setGroups(COLLISION_GROUPS.hazard)
    self:setCollidesWithGroups(COLLISION_GROUPS.player)
end