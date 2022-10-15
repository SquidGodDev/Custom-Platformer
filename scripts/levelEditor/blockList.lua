import "scripts/levelEditor/blockData"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local blockData <const> = getBlockData()
local util <const> = utilities

class('BlockList').extends(gfx.sprite)

function BlockList:init(levelEditor)
    self.levelEditor = levelEditor

    self.blockList = pd.ui.gridview.new(16, 16)
    self.blockList:setNumberOfRows(#blockData)
    self.blockList:setCellPadding(0, 0, 4, 4)
    self.blockList:setContentInset(8, 8, 4, 4)
    self.blockListWidth = 32
    self.blockListHeight = 240
    self.blockList.backgroundImage = gfx.image.new(self.blockListWidth, self.blockListHeight, gfx.kColorBlack)

    local selectCursorImage = gfx.image.new("images/levelEditor/selectCursor")
    self.selectCursor = gfx.sprite.new(selectCursorImage)
    self.selectCursor:setIgnoresDrawOffset(true)
    self.selectCursor:setCenter(0, 0)
    self.selectCursor:moveTo(400 - self.blockListWidth + 4, 0)
    self.selectCursor:setZIndex(1500)
    self.selectCursor:add()

    local blockListMetatable = getmetatable(self.blockList)
    blockListMetatable.selectCursor = self.selectCursor
    function self.blockList:drawCell(_, row, _, selected, x, y, _, _)
        if selected then
            self.selectCursor:moveTo(self.selectCursor.x, y - 4)
        end
        local blockIcon = blockData[row].icon
        blockIcon:draw(x, y)
    end
    self:setIgnoresDrawOffset(true)
    self:setZIndex(1000)
    self:setCenter(0, 0)
    self:moveTo(400 - self.blockListWidth, 0)
    self:add()

    local borderImage = gfx.image.new(4, 240, gfx.kColorWhite)
    local borderSprite = gfx.sprite.new(borderImage)
    borderSprite:setIgnoresDrawOffset(true)
    borderSprite:setZIndex(1000)
    borderSprite:setCenter(1, 0)
    borderSprite:moveTo(400 - self.blockListWidth, 0)
    borderSprite:add()

    self.blockNameSprite = gfx.sprite.new()
    self.blockNameSprite:setIgnoresDrawOffset(true)
    self.blockNameSprite:setCenter(0, 0)
    self.blockNameSprite:moveTo(20, 20)
    self.blockNameSprite:add()
    self:updateBlockName()
end

function BlockList:update()
    local crankTicks = pd.getCrankTicks(3)
    if crankTicks == 1 then
        self.blockList:selectNextRow(true)
        self.levelEditor:updateSelectedBlock()
        self:updateBlockName()
    elseif crankTicks == -1 then
        self.blockList:selectPreviousRow(true)
        self.levelEditor:updateSelectedBlock()
        self:updateBlockName()
    end

    if self.blockList.needsDisplay then
        local gridviewImage = gfx.image.new(self.blockListWidth, self.blockListHeight)
        gfx.pushContext(gridviewImage)
            self.blockList:drawInRect(0, 0, self.blockListWidth, self.blockListHeight)
        gfx.popContext()
        self:setImage(gridviewImage)
    end
end

function BlockList:getSelectedBlockData()
    local selectedRow = self.blockList:getSelectedRow()
    return blockData[selectedRow]
end

function BlockList:updateBlockName()
    local selectedBlockData = self:getSelectedBlockData()
    local blockName = selectedBlockData.name
    gfx.pushContext()
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        local blockNameImage = util.centeredTextImage(blockName)
    gfx.popContext()
    self.blockNameSprite:setImage(blockNameImage)
end