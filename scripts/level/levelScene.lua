import "scripts/level/blocks/wall"
import "scripts/level/blocks/shortBlock"
import "scripts/level/blocks/mediumBlock"
import "scripts/level/blocks/longBlock"
import "scripts/level/blocks/spike"
import "scripts/level/blocks/movingSpike"
import "scripts/level/blocks/shortSpace"
import "scripts/level/player/player"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(levelString)
    -- Wall(100, 200, 400, 16)

    -- LongBlock(180)
    -- Spike(180+64)
    -- MovingSpike(180+64+32)
    -- LongBlock(180+64+32+32)
    -- ShortSpace(180+64+32+32+64)
    -- LongBlock(180+64+32+32+64+16)

    self:processLevelString(levelString)


    Player(200, 150)
    self:add()
end

function LevelScene:update()
    if pd.buttonJustPressed(pd.kButtonB) then
        SCENE_MANAGER:switchScene(LevelLoadScene)
    end
end

function LevelScene:processLevelString(levelString)
    LongBlock(180)
    local blockX = 180 + 64
    for i=1,#levelString do
        local curBlock = self:getBlockType(levelString:sub(i, i), blockX)
        blockX += curBlock.width
    end
end

function LevelScene:getBlockType(letter, blockX)
    if letter == 'a' then
        return ShortBlock(blockX)
    elseif letter == 'b' then
        return MediumBlock(blockX)
    elseif letter == 'c' then
        return LongBlock(blockX)
    elseif letter == 'd' then
        return ShortSpace(blockX)
    elseif letter == 'e' then
        return Spike(blockX)
    elseif letter == 'f' then
        return MovingSpike(blockX)
    else
        return ShortBlock(blockX)
    end
end