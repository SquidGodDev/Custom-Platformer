import "scripts/levelEditor/blockList"
import "scripts/level/levelScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelEditorScene').extends(gfx.sprite)

function LevelEditorScene:init(levelString, levels, levelIndex)
    self.levels = levels
    self.levelIndex = levelIndex

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
    self.spaceLetter = "d"
    for i=1,self.maxX do
        self.blockCodeArray[i] = self.spaceLetter
    end

    self:updateSelectedBlock()
    self:add()

    local playdateMenu = pd.getSystemMenu()
    playdateMenu:removeAllMenuItems()
    playdateMenu:addMenuItem("Play Level", function()
        local calculatedLevelString = self:calculateLevelString()
        self:saveLevel(calculatedLevelString)
        SCENE_MANAGER:switchScene(LevelScene, calculatedLevelString, true)
    end)
    playdateMenu:addMenuItem("Return to Levels", function()
        SCENE_MANAGER:switchScene(LevelListScene)
    end)

    if levelString then
        local letterToBlock = getLetterToBlock()
        for i=1,#levelString do
            local curChar = levelString:sub(i,i)
            if curChar ~= self.spaceLetter then
                self.blockCodeArray[i] = curChar
                local blockData = letterToBlock[curChar]
                local blockImage = blockData.blockImage
                local blockHeight = blockData.blockHeight
                if not blockHeight then
                    blockHeight = self.defaultHeight
                end
                local curSprite = gfx.sprite.new(blockImage)
                curSprite:setCenter(0, 0)
                curSprite:moveTo(i * self.blockSize, blockHeight)
                curSprite:add()
                self.blockArray[i] = curSprite
            end
        end
    end
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
        self.blockCodeArray[self.curX] = self:getBlockLetter()
        curSprite:setImage(self.selectedBlockData.blockImage)
        curSprite:moveTo(self.ditheredBlockSprite.x, self.ditheredBlockSprite.y)
    elseif pd.buttonJustPressed(pd.kButtonB) then
        local curSprite = self.blockArray[self.curX]
        if curSprite then
            curSprite:remove()
            self.blockArray[self.curX] = nil
            self.blockCodeArray[self.curX] = self.spaceLetter
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
    self.ditheredBlockSprite:setImage(self.selectedBlockData.ditheredBlock)
    self:updateBlockXPosition()
    self:updateBlockYPosition()
end

function LevelEditorScene:updateBlockXPosition()
    self.ditheredBlockSprite:moveTo(self.curX * self.blockSize, self.ditheredBlockSprite.y)
    self:animateScroll(-self.curX * self.blockSize + self.scrollOffset)
    self:updateBlockYPosition()
end

function LevelEditorScene:updateBlockYPosition()
    if self.selectedBlockData.adjustableHeight then
        self.ditheredBlockSprite:moveTo(self.ditheredBlockSprite.x, self.blockHeight - (self.curY - 1) * self.blockSize)
    else
        self.ditheredBlockSprite:moveTo(self.ditheredBlockSprite.x, self.blockHeight)
    end
end

function LevelEditorScene:animateScroll(newPos)
    self.scrollAnimator:reset()
    self.scrollAnimator.startValue = self.scrollPosition
    self.scrollAnimator.endValue = newPos
    self.scrollAnimator:start()
end

function LevelEditorScene:getBlockLetter()
    local blockByte = string.byte(self.selectedBlockData.letter)
    if self.selectedBlockData.adjustableHeight then
        blockByte += self.curY - 1
    end
    return string.char(blockByte)
end

function LevelEditorScene:calculateLevelString()
    local levelStringEndIndex = self.maxX
    while self.blockCodeArray[levelStringEndIndex] ~= self.spaceLetter and levelStringEndIndex >= 1 do
        levelStringEndIndex -= 1
    end

    local blockCodes = {table.unpack(self.blockCodeArray, 1, levelStringEndIndex)}
    return table.concat(blockCodes)
end

function LevelEditorScene:saveLevel(levelString)
    self.levels[self.levelIndex].levelCode = levelString
    local gameData = pd.datastore.read()
    if gameData then
       gameData.levels = self.levels
    else
        gameData = {
            levels = self.levels
        }
    end
    pd.datastore.write(gameData)
end