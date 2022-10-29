import "scripts/level/blocks/basic/platform1"
import "scripts/level/blocks/basic/platform2"
import "scripts/level/blocks/basic/platform3"
import "scripts/level/blocks/spikes/spike"
import "scripts/level/blocks/spikes/verticalMovingSpike"
import "scripts/level/blocks/spikes/horizontalMovingSpike"
import "scripts/level/blocks/spikes/spur"
import "scripts/level/blocks/shortSpace"
import "scripts/level/blocks/movingPlatform"
import "scripts/level/blocks/turret/turret"
import "scripts/level/blocks/crumblingPlatform"
import "scripts/level/player/player"

import "scripts/levelEditor/levelEditorScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(levelString, fromLevelEditor)
    TEMP_HAZARDS = {}
    local backgroundImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            backgroundImage:draw(0, 0)
        end
    )
    -- Wall(100, 200, 400, 16)

    -- LongBlock(180)
    -- Spike(180+64)
    -- MovingSpike(180+64+32)
    -- LongBlock(180+64+32+32)
    -- ShortSpace(180+64+32+32+64)
    -- LongBlock(180+64+32+32+64+16)

    -- levelString = "abrdddaammpaafaaoaaoaaobabsdzddyddzddbbb"
    self:processLevelString(levelString)

    Player(200, 150)
    self:add()

    local playdateMenu = pd.getSystemMenu()
    playdateMenu:removeAllMenuItems()
    if fromLevelEditor then
        playdateMenu:addMenuItem("Level Editor", function()
            SCENE_MANAGER:switchScene(LevelEditorScene, levelString)
        end)
    end
end

function LevelScene:update()
    if pd.buttonJustPressed(pd.kButtonB) then
        SCENE_MANAGER:switchScene(LevelLoadScene)
    end
end

function LevelScene:processLevelString(levelString)
    local longBlock = Platform1(180, LEVEL_BASE_Y)
    local blockX = 180 + longBlock.width
    for i=1,#levelString do
        local curBlock = self:getBlockType(levelString:sub(i, i), blockX)
        blockX += curBlock.width
    end
end

function LevelScene:getBlockType(letter, blockX)
    local height1 = LEVEL_BASE_Y
    local height2 = height1 - 32
    local height3 = height2 - 32
    if     letter == 'a' then return Platform1(blockX, height1)
    elseif letter == 'b' then return Platform1(blockX, height2)
    elseif letter == 'c' then return Platform1(blockX, height3)
    elseif letter == 'd' then return ShortSpace(blockX)
    elseif letter == 'e' then return Turret(blockX, height1, false)
    elseif letter == 'f' then return Turret(blockX, height2, false)
    elseif letter == 'g' then return Turret(blockX, height3, false)
    elseif letter == 'h' then return Turret(blockX, height1, true)
    elseif letter == 'i' then return Turret(blockX, height2, true)
    elseif letter == 'j' then return Turret(blockX, height3, true)
    elseif letter == 'k' then return VerticalMovingSpike(blockX)
    elseif letter == 'l' then return CrumblingPlatform(blockX, height1)
    elseif letter == 'm' then return CrumblingPlatform(blockX, height2)
    elseif letter == 'n' then return CrumblingPlatform(blockX, height3)
    elseif letter == 'o' then return Spike(blockX, height1)
    elseif letter == 'p' then return Spike(blockX, height2)
    elseif letter == 'q' then return Spike(blockX, height3)
    elseif letter == 'r' then return MovingPlatform(blockX, height1)
    elseif letter == 's' then return MovingPlatform(blockX, height2)
    elseif letter == 't' then return MovingPlatform(blockX, height3)
    elseif letter == 'u' then return HorizontalMovingSpike(blockX, height1)
    elseif letter == 'v' then return HorizontalMovingSpike(blockX, height2)
    elseif letter == 'w' then return HorizontalMovingSpike(blockX, height3)
    elseif letter == 'x' then return Spur(blockX, height1)
    elseif letter == 'y' then return Spur(blockX, height2)
    elseif letter == 'z' then return Spur(blockX, height3)
    end
end