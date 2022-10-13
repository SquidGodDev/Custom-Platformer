import "scripts/levelEditor/blockList"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelEditorScene').extends(gfx.sprite)

function LevelEditorScene:init()
    gfx.setBackgroundColor(gfx.kColorBlack)
    local backgroundImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            backgroundImage:draw(0, 0)
        end
    )

    self.scrollOffset = 100
    self.scrollPosition = -32 + self.scrollOffset
    self.scrollAnimator = pd.timer.new(250)
    self.scrollAnimator.discardOnCompletion = false
    self.scrollAnimator.easingFunction = pd.easingFunctions.outCubic
    self.scrollAnimator:pause()
    self.scrollAnimator.updateCallback = function(timer)
        self.scrollPosition = timer.value
    end
    self.scrollAnimator.timerEndedCallback = function(timer)
        self.scrollPosition = timer.endValue
    end

    self.ditheredBlockSprite = gfx.sprite.new()
    self.ditheredBlockSprite:setZIndex(100)
    self.ditheredBlockSprite:setCenter(0, 0)
    self.ditheredBlockSprite:add()
    self.blockList = BlockList(self)

    self.defaultHeight = LEVEL_BASE_Y
    self.blockSize = 32
    self.curX = 1
    self.curY = 1
    self.maxX = 100

    self.blockArray = {}
    self.blockCodeArray = {}

    self:updateSelectedBlock()
    self:add()
end

function LevelEditorScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        local curSprite = self.blockArray[self.curX]
        if not curSprite then
            curSprite = gfx.sprite.new()
            curSprite:setCenter(0, 0)
            curSprite:add()
            self.blockArray[self.curX] = curSprite
        end
        self.blockCodeArray[self.curX] = self.selectedBlockData.letter
        curSprite:setImage(self.selectedBlockData.blockImage)
        curSprite:moveTo(self.ditheredBlockSprite.x, self.ditheredBlockSprite.y)
    elseif pd.buttonJustPressed(pd.kButtonB) then
        local curSprite = self.blockArray[self.curX]
        if curSprite then
            curSprite:remove()
            self.blockArray[self.curX] = nil
        end
    end

    if pd.buttonJustPressed(pd.kButtonLeft) then
        if self.curX > 1 then
            self.curX -= 1
            self:updateBlockXPosition()
        end
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        if self.curX < self.maxX then
            self.curX += 1
        end
        self:updateBlockXPosition()
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        if self.curY < 3 then
            self.curY += 1
            self:updateBlockYPosition()
        end
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        if self.curY > 1 then
            self.curY -= 1
            self:updateBlockYPosition()
        end
    end

    gfx.setDrawOffset(self.scrollPosition, 0)
end

function LevelEditorScene:updateSelectedBlock()
    self.selectedBlockData = self.blockList:getSelectedBlockData()
    self.blockHeight = self.selectedBlockData.baseHeight
    if not self.blockHeight then
        self.blockHeight = self.defaultHeight
    end
    self.ditheredBlockSprite:setImage(self.selectedBlockData.ditheredBlock)
    self:updateBlockXPosition()
    self:updateBlockYPosition()
end

function LevelEditorScene:updateBlockXPosition()
    self.ditheredBlockSprite:moveTo(self.curX * self.blockSize, self.ditheredBlockSprite.y)
    self:animateScroll(-self.curX * self.blockSize + self.scrollOffset)
end

function LevelEditorScene:updateBlockYPosition()
    if self.selectedBlockData.baseHeight then
        self.ditheredBlockSprite:moveTo(self.ditheredBlockSprite.x, self.blockHeight - (self.curY - 1) * self.blockSize)
    end
end

function LevelEditorScene:animateScroll(newPos)
    self.scrollAnimator:reset()
    self.scrollAnimator.startValue = self.scrollPosition
    self.scrollAnimator.endValue = newPos
    self.scrollAnimator:start()
end