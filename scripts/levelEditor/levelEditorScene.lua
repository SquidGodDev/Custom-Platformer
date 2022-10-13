import "scripts/levelEditor/blockList"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelEditorScene').extends(gfx.sprite)

function LevelEditorScene:init()
    local backgroundImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            backgroundImage:draw(0, 0)
        end
    )

    self.ditheredBlockSprite = gfx.sprite.new()
    self.ditheredBlockSprite:setCenter(0, 0)
    self.ditheredBlockSprite:add()
    self.blockList = BlockList(self)

    self.defaultHeight = LEVEL_BASE_Y
    self.blockSize = 32
    self.curX = 1
    self.curY = 1

    self:updateSelectedBlock()
    self:add()
end

function LevelEditorScene:update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        if self.curX > 1 then
            self.curX -= 1
            self:updateBlockXPosition()
        end
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self.curX += 1
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
end

function LevelEditorScene:updateBlockYPosition()
    if self.selectedBlockData.baseHeight then
        self.ditheredBlockSprite:moveTo(self.ditheredBlockSprite.x, self.blockHeight - (self.curY - 1) * self.blockSize)
    end
end