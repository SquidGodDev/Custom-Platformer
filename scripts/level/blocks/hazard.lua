local gfx <const> = playdate.graphics

class('Hazard').extends(gfx.sprite)

function Hazard:init(removeOnReset)
    self.collisionResponse = gfx.sprite.kCollisionTypeOverlap
    self:setGroups(COLLISION_GROUPS.hazard)
    self:setCollidesWithGroups(COLLISION_GROUPS.player)

    local tempHazardList = TEMP_HAZARDS
    if removeOnReset then
        table.insert(tempHazardList, self)
    end
end
