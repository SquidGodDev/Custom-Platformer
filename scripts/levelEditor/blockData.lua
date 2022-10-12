local pd <const> = playdate
local gfx <const> = playdate.graphics

local function getDitheredImage(image)
    local ditheredImage = gfx.image.new(image:getSize())
    gfx.pushContext(ditheredImage)
        image:drawFaded(0, 0, 0.5, gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    return ditheredImage
end

local height1 = LEVEL_BASE_Y

local function blockData(blockImage, letter, baseHeight, iconImage)
    local ditheredBlock = getDitheredImage(blockImage)
    if not iconImage then
        iconImage = blockImage:scaledImage(0.5)
    end
    return {
        icon = iconImage,
        blockImage = blockImage,
        ditheredBlock = ditheredBlock,
        baseHeight = baseHeight,
        letter = letter
    }
end

local function platform1Data(letter)
    local blockImage = gfx.image.new("images/blocks/platform1")
    return blockData(blockImage, letter, height1)
end

local function spikeData(letter)
    local blockImage = gfx.image.new("images/levelEditor/blocks/spike")
    local iconImage = gfx.image.new("images/levelEditor/blocks/spikeIcon")
    return blockData(blockImage, letter, height1 - 16, iconImage)
end

local function horizontalMovingSpikeData(letter)
    local blockImage = gfx.image.new("images/blocks/spikeBall")
    return blockData(blockImage, letter, height1)
end

local function verticalMovingSpikeData(letter)
    local blockImage = gfx.image.new("images/blocks/spikeBall")
    return blockData(blockImage, letter, nil)
end

local function spurData(letter)
    local blockImage = gfx.image.new("images/blocks/spur")
    return blockData(blockImage, letter, height1)
end

local function turretData(letter, flipped)
    local blockImage = gfx.image.new("images/levelEditor/blocks/turret")
    local iconImage = gfx.image.new("images/levelEditor/blocks/turretIcon")
    if flipped then
        blockImage = gfx.image.new("images/levelEditor/blocks/turretFlipped")
        iconImage = gfx.image.new("images/levelEditor/blocks/turretIconFlipped")
    end
    return blockData(blockImage, letter, height1 - 48, iconImage)
end

local function crumblingPlatformData(letter)
    local blockImage = gfx.image.new("images/blocks/crumblingPlatform")
    return blockData(blockImage, letter, height1)
end

local function movingPlatformData(letter)
    local blockImage = gfx.image.new("images/blocks/movingPlatform")
    return blockData(blockImage, letter, height1)
end

local blockTable = {
    platform1Data('a'),
    verticalMovingSpikeData('k'),
    spikeData('o'),
    horizontalMovingSpikeData('u'),
    spurData('x'),
    crumblingPlatformData('l'),
    movingPlatformData('r'),
    turretData('e', false),
    turretData('h', true)
}

function getBlockData()
    return blockTable
end