import "scripts/levelList/levelListScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local util <const> = utilities

class('QrCodeScene').extends(gfx.sprite)

function QrCodeScene:init(levelCode, levelName, listIndex)
    gfx.setBackgroundColor(gfx.kColorBlack)
    local backgroundImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            backgroundImage:draw(0, 0)
        end
    )

    self.qrLoaded = false
    self.listIndex = listIndex

    local baseURL = "https://squidgoddev.github.io/?code="
    gfx.generateQRCode(baseURL .. levelCode, nil, function(image, err)
        self.qrLoaded = true
        self:setImage(image)
    end)

    local nameSprite = util.centeredTextSprite(levelName)
    nameSprite:setImageDrawMode(gfx.kDrawModeFillWhite)
    nameSprite:moveTo(200, 40)
    nameSprite:add()

    local loadingImageTable = gfx.imagetable.new("images/levelList/loading-table-100-30")
    self.loadingAnimationLoop = gfx.animation.loop.new(700, loadingImageTable, true)

    self:moveTo(200, 140)
    self:add()

    local playdateMenu = pd.getSystemMenu()
    playdateMenu:removeAllMenuItems()
end

function QrCodeScene:update()
    if not self.qrLoaded then
        self:setImage(self.loadingAnimationLoop:image())
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        SCENE_MANAGER:switchScene(LevelListScene, listIndex)
    end
end
