-- Popup
-- 1. Play level
-- 2. Edit level
-- 3. Delete

-- Panel
-- 1. Name
-- 2. Best Time
-- 3. Preview?
-- 4. QR Code?

-- Level Editor Menu
-- 1. Play Level
-- 2. Return Home

-- Level Menu (From List)
-- 1. Restart
-- 2. Remix
-- 3. Return Home

-- Level Menu (From Editor)
-- 1. Return to Level Editor
-- 2. Restart
-- 3. Return Home

import "scripts/levelEditor/LevelEditorScene"
import "scripts/levelList/qrCodeScene"
import "scripts/level/LevelScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelListScene').extends(gfx.sprite)

function LevelListScene:init(levelIndex)
    local backgroundImage = gfx.image.new("images/levelList/levelListBackground")
    local backgroundSprite = gfx.sprite.new(backgroundImage)
    backgroundSprite:moveTo(200, 120)
    backgroundSprite:add()

    self.listview = pd.ui.gridview.new(138, 28)
    self.listview:setContentInset(5, 5, 5, 5)
    self.listview:setCellPadding(0, 0, 0, 5)

    self.listviewObject = getmetatable(self.listview)
    self.listviewObject.selectImage = gfx.image.new("images/levelList/levelListSelector")

    local gameData = pd.datastore.read()
    if gameData then
        self.levels = gameData.levels
    else
        self.levels = {}
    end
    self.listview:setNumberOfRows(#self.levels + 1)

    self.listviewObject.levels = self.levels
    self.listviewObject.addRow = #self.levels + 1
    self.listviewObject.addRowImage = gfx.image.new("images/levelList/newLevelButton")
    self.listviewObject.fontHeight = gfx.getSystemFont():getHeight()

    if levelIndex and levelIndex <= #self.levels then
        self.listview:setSelectedRow(levelIndex)
    end

    function self.listview:drawCell(section, row, column, selected, x, y, width, height)
        if row == self.addRow then
            self.addRowImage:draw(x, y)
        else
            local levelName = self.levels[row].levelName
            gfx.pushContext()
                gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
                gfx.drawTextInRect(levelName, x, y + (height - self.fontHeight) / 2 + 2, width, height, 0, "...", kTextAlignment.center)
            gfx.popContext()
        end

        if selected then
            self.selectImage:draw(x, y)
        end
    end

    self.listWidth, self.listHeight = 148, 222
    self:setCenter(0, 0)
    self:moveTo(9, 9)
    self:add()

    self.panelSprite = gfx.sprite.new()
    self.panelSprite:setCenter(0, 0)
    self.panelSprite:moveTo(172, 9)
    self.panelWidth, self.panelHeight = 219, 222
    self.panelSprite:add()

    self:updatePanel()

    local popupImage = gfx.image.new("images/levelList/popup")
    self.popupSprite = gfx.sprite.new(popupImage)
    self.popupSprite:moveTo(200, 120)
    self.popupSprite:setVisible(false)
    self.popupSprite:add()

    local popupSelectorImage = gfx.image.new("images/levelList/popupSelector")
    self.popupSelectorSprite = gfx.sprite.new(popupSelectorImage)
    self.popupSelectorSprite:setCenter(0, 0)
    self.popupSelectorBaseX = 122
    self.popupSelectorBaseY = 99
    self.popupSelectorGap = 57
    self.popupIndex = 1
    self.popupSelectorSprite:moveTo(self.popupSelectorBaseX, self.popupSelectorBaseY)
    self.popupSelectorSprite:setVisible(false)
    self.popupSelectorSprite:add()

    -- Delete Prompt
    local deletePromptImage = gfx.image.new("images/levelList/deleteLevelPrompt")
    self.deletePromptSprite = gfx.sprite.new(deletePromptImage)
    self.deletePromptSprite:moveTo(200, 120)
    self.deletePromptSprite:setVisible(false)
    self.deletePromptSprite:add()

    -- Name Input
    self.nameInputActive = false
    local nameInputImage = gfx.image.new("images/levelList/nameInput")
    self.nameInputSprite = gfx.sprite.new(nameInputImage)
    self.nameInputSprite:add()
    self.nameInputStart = -120
    self.nameInputEnd = 120
    self.nameInputSprite:moveTo(200, self.nameInputStart)

    self.nameInputPosition = self.nameInputStart
    self.nameInputAnimator = pd.timer.new(250)
    self.nameInputAnimator.discardOnCompletion = false
    self.nameInputAnimator:pause()
    self.nameInputAnimator.updateCallback = function(timer)
        self.nameInputPosition = timer.value
    end
    self.nameInputAnimator.timerEndedCallback = function(timer)
        self.nameInputPosition = timer.endValue
    end

    self.nameBoxWidth = 182
    self.nameBoxHeight = 54
    self.nameBoxSprite = gfx.sprite.new()
    self.nameBoxSprite:setCenter(0, 0)
    self.nameBoxOffset = self.nameInputEnd - 107
    self.nameBoxSprite:moveTo(10, self.nameInputStart - self.nameBoxOffset)
    self.nameBoxSprite:add()

    pd.keyboard.keyboardWillHideCallback = function(flag)
        if self.nameInputActive and flag then
            local levelName = pd.keyboard.text
            if levelName ~= "" then
                local newLevel = {
                    levelName = levelName,
                    levelCode = ""
                }
                table.insert(self.levels, newLevel)
                self:saveGameData()
                SCENE_MANAGER:switchScene(LevelEditorScene, "", #self.levels)
            end
        end
    end

    pd.keyboard.keyboardDidHideCallback = function()
        self:animateOutNameInput()
    end

    pd.keyboard.textChangedCallback = function()
        local maxNameLen = 15
        if #pd.keyboard.text > maxNameLen then
            pd.keyboard.text = string.sub(pd.keyboard.text, 1, maxNameLen)
        end
        local inputBoxTextImage = gfx.image.new(self.nameBoxWidth, self.nameBoxHeight)
        gfx.pushContext(inputBoxTextImage)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.drawTextAligned(pd.keyboard.text, self.nameBoxWidth / 2 + 1, 6, kTextAlignment.center)
        gfx.popContext()
        self.nameBoxSprite:setImage(inputBoxTextImage)
    end

    local playdateMenu = pd.getSystemMenu()
    playdateMenu:removeAllMenuItems()
    playdateMenu:addMenuItem("Share Level QR", function()
        local curListRow = self.listview:getSelectedRow()
        local curLevelData = self.levels[curListRow]
        if curLevelData then
            SCENE_MANAGER:switchScene(QrCodeScene, curLevelData.levelCode, curLevelData.levelName, curListRow)
        end
    end)
end

function LevelListScene:update()
    local forceUpdateList = false

    if self.nameInputActive then
        -- Nothing
    elseif self.deletePromptSprite:isVisible() then
        if pd.buttonJustPressed(pd.kButtonA) then
            local curListRow = self.listview:getSelectedRow()
            table.remove(self.levels, curListRow)
            self:saveGameData()
            self.listviewObject = getmetatable(self.listview)
            self.listviewObject.levels = self.levels
            self.listviewObject.addRow = #self.levels + 1
            self.listview:setNumberOfRows(#self.levels + 1)
            self.deletePromptSprite:setVisible(false)
            self.popupSprite:setVisible(false)
            self.popupSelectorSprite:setVisible(false)
            self:updatePanel()
        elseif pd.buttonJustPressed(pd.kButtonB) then
            self.deletePromptSprite:setVisible(false)
        end
    elseif self.popupSprite:isVisible() then
        if pd.buttonJustPressed(pd.kButtonLeft) then
            if self.popupIndex > 1 then
                self.popupIndex -= 1
                self.popupSelectorSprite:moveTo(self.popupSelectorBaseX + (self.popupIndex - 1)*self.popupSelectorGap, self.popupSelectorBaseY)
                gfx.sprite.addDirtyRect(108, 86, 184, 66)
            end
        elseif pd.buttonJustPressed(pd.kButtonRight) then
            if self.popupIndex < 3 then
                self.popupIndex += 1
                self.popupSelectorSprite:moveTo(self.popupSelectorBaseX + (self.popupIndex - 1)*self.popupSelectorGap, self.popupSelectorBaseY)
                gfx.sprite.addDirtyRect(108, 86, 184, 66)
            end
        elseif pd.buttonJustPressed(pd.kButtonA) then
            local curListRow = self.listview:getSelectedRow()
            local selectedLevel = self.levels[curListRow]
            if self.popupIndex == 1 then
                SCENE_MANAGER:switchScene(LevelScene, selectedLevel.levelCode, false, curListRow)
            elseif self.popupIndex == 2 then
                SCENE_MANAGER:switchScene(LevelEditorScene, selectedLevel.levelCode, curListRow)
            elseif self.popupIndex == 3 then
                self.deletePromptSprite:setVisible(true)
            end
        elseif pd.buttonJustPressed(pd.kButtonB) then
            self.popupSelectorSprite:setVisible(false)
            self.popupSprite:setVisible(false)
        end
    else
        local crankTicks = pd.getCrankTicks(4)
        if pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
            self.listview:selectPreviousRow(true)
            self:updatePanel()
        elseif pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
            self.listview:selectNextRow(true)
            self:updatePanel()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            local curListRow = self.listview:getSelectedRow()
            if curListRow == #self.levels + 1 then
                self:animateInNameInput()
            else
                self.popupSelectorSprite:setVisible(true)
                self.popupSprite:setVisible(true)
            end
        end
    end

    if self.listview.needsDisplay or forceUpdateList then
        local listviewImage = gfx.image.new(self.listWidth, self.listHeight)
        gfx.pushContext(listviewImage)
            self.listview:drawInRect(0, 0, self.listWidth, self.listHeight)
        gfx.popContext()
        self:setImage(listviewImage)
    end

    self.nameInputSprite:moveTo(self.nameInputSprite.x, self.nameInputPosition)
    self.nameBoxSprite:moveTo(self.nameBoxSprite.x, self.nameInputPosition - self.nameBoxOffset)
end

function LevelListScene:updatePanel()
    local curListRow = self.listview:getSelectedRow()
    local curLevelData = self.levels[curListRow]

    local panelImage = gfx.image.new(self.panelWidth, self.panelHeight)
    if curLevelData then
        local levelName = curLevelData.levelName
        gfx.pushContext(panelImage)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.drawTextAligned(levelName, self.panelWidth/2, 20, kTextAlignment.center)
        gfx.popContext()
    else
        gfx.pushContext(panelImage)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.drawTextAligned("Create New Level", self.panelWidth/2, self.panelHeight/2 - 8, kTextAlignment.center)
        gfx.popContext()
    end
    self.panelSprite:setImage(panelImage)
end

function LevelListScene:animateInNameInput()
    self.nameInputActive = true
    pd.keyboard.text = ""
    pd.keyboard.show()
    self.nameInputAnimator.easingFunction = pd.easingFunctions.outCubic
    self.nameInputAnimator:reset()
    self.nameInputAnimator.startValue = self.nameInputPosition
    self.nameInputAnimator.endValue = self.nameInputEnd
    self.nameInputAnimator:start()
end

function LevelListScene:animateOutNameInput()
    self.nameInputActive = false
    self.nameInputAnimator.easingFunction = pd.easingFunctions.inCubic
    self.nameInputAnimator:reset()
    self.nameInputAnimator.startValue = self.nameInputPosition
    self.nameInputAnimator.endValue = self.nameInputStart
    self.nameInputAnimator:start()
end

function LevelListScene:saveGameData()
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