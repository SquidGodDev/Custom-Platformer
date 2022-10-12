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
    BlockList()
end

function LevelEditorScene:update()
    
end