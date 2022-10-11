import "scripts/levelEditor/blockData"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local blockData <const> = getBlockData()

class('LevelEditorScene').extends(gfx.sprite)

function LevelEditorScene:init()
    -- category
    -- icon
    -- block
    -- height
    -- dithered block
    -- letter
end

function LevelEditorScene:update()
    
end