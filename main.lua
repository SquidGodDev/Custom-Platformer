LEVEL_BASE_Y = 200

COLLISION_GROUPS = {
    player = 1,
    wall = 2,
    hazard = 3
}

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/keyboard"
import "CoreLibs/qrcode"
import "CoreLibs/animation"

import "scripts/libraries/Utilities"
import "scripts/libraries/SceneManager"
import "scripts/levelLoad/levelLoadScene"
import "scripts/level/levelScene"
import "scripts/levelEditor/levelEditorScene"
import "scripts/levelList/levelListScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local m5x7font = gfx.font.new("images/fonts/m5x7-24")
gfx.setFont(m5x7font)

SCENE_MANAGER = SceneManager()

-- LevelLoadScene()
-- LevelScene()
-- LevelEditorScene()
LevelListScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(4, 4)
end