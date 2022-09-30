
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/libraries/Utilities"
import "scripts/libraries/SceneManager"
import "scripts/levelLoad/levelLoadScene"
import "scripts/level/levelScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

COLLISION_GROUPS = {
    player = 1,
    wall = 2,
    hazard = 3
}

LEVEL_BASE_Y = 200

SCENE_MANAGER = SceneManager()

-- LevelLoadScene()
LevelScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(10, 10)
end