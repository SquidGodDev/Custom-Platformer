import "scripts/levelEditor/blockData"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local blockData <const> = getBlockData()

class('BlockList').extends(gfx.sprite)

function BlockList:init()
    self.blockList = pd.ui.gridview.new(16, 16)
    self.blockList:setNumberOfRows()
end