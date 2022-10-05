import "scripts/libraries/AnimatedSprite"
import "scripts/level/blocks/hazard"
import "scripts/level/blocks/movingPlatform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
    self.respawnX = x
    self.respawnY = y

    local playerImageTable = gfx.imagetable.new("images/player/player-table-32-32")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 1)
    self:addState("run", 2, 5, {tickStep = 4})
    self:addState("climb", 6, 7, {tickStep = 4})
    self:addState("jumpAscent", 8, 8)
    self:addState("jumpPeak", 8, 8)
    self:addState("jumpDescent", 8, 8)

    self.xVelocity = 0
    self.adjustedXVelocity = 0
    self.yVelocity = 0
    self.gravity = 9.8 / 20
    self.fastFalling = false
    self.fastFallingGravity = self.gravity * 2
    self.maxSpeed = 3
    self.startVelocity = 2
    self.jumpVelocity = -6

    self.frictionDisabled = false
    self.friction = 0.5
    self.drag = 0.1
    self.acceleration = 0.5

    self:setCollideRect(2, 2, 28, 30)
    self:setGroups(COLLISION_GROUPS.player)
    self:setCollidesWithGroups({COLLISION_GROUPS.wall, COLLISION_GROUPS.hazard})

    self.collisionResponse = gfx.sprite.kCollisionTypeSlide

    self:playAnimation()
    self:moveTo(x, y)
end

function Player:update()
    self:updateAnimation()

    if self.currentState == "idle" then
        if pd.buttonIsPressed(pd.kButtonA) then
            self.yVelocity = self.jumpVelocity
            self:changeState("jumpAscent")
        elseif pd.buttonIsPressed(pd.kButtonLeft) then
            self.xVelocity = -self.startVelocity
            self.globalFlip = 1
            self:changeState("run")
        elseif pd.buttonIsPressed(pd.kButtonRight) then
            self.xVelocity = self.startVelocity
            self.globalFlip = 0
            self:changeState("run")
        end
        self:applyFriction()
    elseif self.currentState == "run" then
        if pd.buttonIsPressed(pd.kButtonA) then
            self.yVelocity = self.jumpVelocity
            self:changeState("jumpAscent")
        elseif pd.buttonIsPressed(pd.kButtonLeft) then
            self:accelerateLeft()
        elseif pd.buttonIsPressed(pd.kButtonRight) then
            self:accelerateRight()
        else
            self:changeState("idle")
        end
    elseif self.currentState == "jumpAscent" then
        self:handleJumpPhysics()
        if math.abs(self.yVelocity) < 0.5 then
            self:changeState("jumpPeak")
        end
    elseif self.currentState == "jumpPeak" then
        self:handleJumpPhysics()
        if self.yVelocity > 0.5 then
            self:changeState("jumpDescent")
        end
    elseif self.currentState == "jumpDescent" then
        self:handleJumpPhysics()
        if self.yVelocity == 0 then
            if pd.buttonIsPressed(pd.kButtonLeft) then
                self.xVelocity = -self.startVelocity
                self.globalFlip = 1
                self:changeState("run")
            elseif pd.buttonIsPressed(pd.kButtonRight) then
                self.xVelocity = self.startVelocity
                self.globalFlip = 0
                self:changeState("run")
            else
                self:changeState("idle")
            end
        end
    end

    self:applyGravity()

    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity + self.adjustedXVelocity, self.y + self.yVelocity)
    local touchedGround = false
    local touchedHazard = false
    for i=1,length do
        local collision = collisions[i]
        if collision.normal.y == -1 then
            touchedGround = true
            self.fastFalling = false
        elseif collision.normal.y == 1 then
            self.yVelocity = 0
        end
        if collision.other:isa(Hazard) then
            touchedHazard = true
        end
        if collision.other:isa(MovingPlatform) and self.currentState == "idle" then
            self.frictionDisabled = true
            self.xVelocity = collision.other:getVelocity()
        else
            self.frictionDisabled = false
        end

        if collision.other.collided then
            collision.other:collided(self)
        end
    end
    if touchedGround then
        self.yVelocity = 0
    end
    if touchedHazard or self.y > 250 then
        self:resetPlayer()
    end

    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end
    gfx.setDrawOffset(-self.x + 200, 0)
end

function Player:resetPlayer()
    self:moveTo(self.respawnX, self.respawnY)
    self.xVelocity = 0
    self.yVelocity = 0
end

function Player:handleJumpPhysics()
    self.fastFalling = pd.buttonIsPressed(pd.kButtonDown)

    if pd.buttonIsPressed(pd.kButtonLeft) then
        self:accelerateLeft()
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self:accelerateRight()
    else
        self:applyDrag()
    end
end

function Player:accelerateLeft()
    if self.xVelocity > 0 then
        self.xVelocity = 0
    end
    self.xVelocity -= self.acceleration
    if self.xVelocity <= -self.maxSpeed then
        self.xVelocity = -self.maxSpeed
    end
end

function Player:accelerateRight()
    if self.xVelocity < 0 then
        self.xVelocity = 0
    end
    self.xVelocity += self.acceleration
    if self.xVelocity >= self.maxSpeed then
        self.xVelocity = self.maxSpeed
    end
end

function Player:applyGravity()
    if self.fastFalling then
        self.yVelocity += self.fastFallingGravity
    else
        self.yVelocity += self.gravity
    end
end

function Player:applyDrag()
    if self.xVelocity > 0 then
        self.xVelocity -= self.drag
    elseif self.xVelocity < 0 then
        self.xVelocity += self.drag
    end

    if math.abs(self.xVelocity) < 0.5 then
        self.xVelocity = 0
    end
end

function Player:applyFriction()
    if self.frictionDisabled then
        return
    end

    if self.xVelocity > 0 then
        self.xVelocity -= self.friction
    elseif self.xVelocity < 0 then
        self.xVelocity += self.friction
    end

    if math.abs(self.xVelocity) < 0.5 then
        self.xVelocity = 0
    end
end