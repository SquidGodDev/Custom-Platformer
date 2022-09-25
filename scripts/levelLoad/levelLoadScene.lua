import "scripts/libraries/Utilities"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local util <const> = utilities

-- 50 = 2,3
-- 100 = 4,5,6
-- 150 = 7, 8
-- 200 = 9, 10, 11
-- 250 = 12, 13
-- 500 = 25

class('LevelLoadScene').extends(gfx.sprite)

function LevelLoadScene:init()
    pd.display.setRefreshRate(50)

    self.listeningSprite = util.centeredTextSprite("Listening")
    self.listeningSprite:moveTo(200, 120)
    self.listeningState = false

    self.receivedCodeSprite = gfx.sprite.new()
    self.receivedCodeSprite:moveTo(200, 50)
    self.receivedCodeSprite:add()

    self.micBuffer = {}
    self.isRecordingCode = false
    self.curCharNumber = ""
    self.codeString = ""

    self:add()
end

function LevelLoadScene:cleanup()
    pd.display.setRefreshRate(30)
end

function LevelLoadScene:update()
    if self.listeningState then
        local micLevel = pd.sound.micinput.getLevel()
        if micLevel > 0.01 then
            table.insert(self.micBuffer, micLevel)
        else
            local toneLength = #self.micBuffer
            if toneLength > 0 then
                if not self.isRecordingCode and toneLength >= 24 then
                    self.isRecordingCode = true
                    self.curCharNumber = ""
                    self.codeString = ""
                else
                    if toneLength >= 24 then
                        self.isRecordingCode = false
                        self:stopListeningState()
                        print(self.codeString)
                        self:updateReceivedCodeSprite(self.codeString)
                    else
                        print(toneLength)
                        local toneNumber = self:toneLengthToNumber(toneLength)
                        self.curCharNumber = self.curCharNumber .. toneNumber
                        if #self.curCharNumber == 3 then
                            local curCharacter = self:numberToCharacter(self.curCharNumber)
                            self.codeString = self.codeString .. curCharacter
                            self:updateReceivedCodeSprite(self.codeString)
                            self.curCharNumber = ""
                        end
                    end
                end
            end
            self.micBuffer = {}
        end
        if pd.buttonJustPressed(pd.kButtonA) then
            self:stopListeningState()
            self:clearCode()
        end
    else
        if pd.buttonJustPressed(pd.kButtonA) then
            self:startListeningState()
        end
        if pd.buttonJustPressed(pd.kButtonB) then
            if self.codeString ~= "" then
                SCENE_MANAGER:switchScene(LevelScene, self.codeString)
            end
        end
    end
end

function LevelLoadScene:updateReceivedCodeSprite(text)
    if text == "" then
        return
    end
    local receivedCodeText = util.centeredTextImage(text)
    self.receivedCodeSprite:setImage(receivedCodeText)
end

function LevelLoadScene:toneLengthToNumber(toneLength)
    if toneLength >= 10 then
        return "2"
    elseif toneLength >= 5 then
        return "1"
    else
        return "0"
    end
end

function LevelLoadScene:numberToCharacter(number)
    local baseByte = string.byte('a')
    local numberBase10 = tonumber(number, 3)
    local asciiNum = baseByte + numberBase10
    return string.char(asciiNum)
end

function LevelLoadScene:startListeningState()
    self:clearCode()
    self.listeningState = true
    self.listeningSprite:add()
    pd.sound.micinput.startListening()
end

function LevelLoadScene:stopListeningState()
    self.listeningState = false
    self.listeningSprite:remove()
    pd.sound.micinput.stopListening()
end

function LevelLoadScene:clearCode()
    local blankImage = gfx.image.new(10, 10)
    self.receivedCodeSprite:setImage(blankImage)
    self.curCharNumber = ""
    self.codeString = ""
    self.micBuffer = {}
    self.isRecordingCode = false
end