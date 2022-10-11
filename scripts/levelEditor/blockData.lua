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
local height2 = height1 - 32
local height3 = height2 - 32

local function blockData(blockImage, letter, height)
    local ditheredBlock = getDitheredImage(blockImage)
    local iconImage = blockImage:scaledImage(0.5)
    return {
        icon = iconImage,
        blockImage = blockImage,
        ditheredBlock = ditheredBlock,
        height = height,
        letter = letter
    }
end

local function platform1Data(letter, height)
    local blockImage = gfx.image.new("images/block/platform1")
    return blockData(blockImage, letter, height)
end

local function spikeData(letter, height)
    local blockImage = gfx.image.new("images/levelEditor/blocks/spike")
    return blockData(blockImage, letter, height - 16)
end

local function horizontalMovingSpikeData(letter, height)
    local blockImage = gfx.image.new("images/block/horizontalMovingSpike")
    return blockData(blockImage, letter, height)
end

local function verticalMovingSpikeData(letter)
    local blockImage = gfx.image.new("images/block/verticalMovingSpike")
    return blockData(blockImage, letter, height1)
end

local function spurData(letter, height)
    local blockImage = gfx.image.new("images/block/spur")
    return blockData(blockImage, letter, height)
end

local function turretData(letter, height, flipped)
    local blockImage = gfx.image.new("images/levelEditor/blocks/turret")
    if flipped then
        blockImage = gfx.image.new("images/levelEditor/blocks/turretFlipped")
    end
    return blockData(blockImage, letter, height - 48)
end

local function crumblingPlatformData(letter, height)
    local blockImage = gfx.image.new("images/block/crumblingPlatform")
    return blockData(blockImage, letter, height)
end

local function movingPlatformData(letter, height)
    local blockImage = gfx.image.new("images/block/movingPlatform")
    return blockData(blockImage, letter, height)
end

local blockTable = {
    blocks = {
        platform1Data('a', height1),
        platform1Data('b', height2),
        platform1Data('c', height3)
    },
    spikes = {
        verticalMovingSpikeData('k'),
        spikeData('o', height1),
        spikeData('p', height2),
        spikeData('q', height3),
        horizontalMovingSpikeData('u', height1),
        horizontalMovingSpikeData('v', height2),
        horizontalMovingSpikeData('w', height3),
        spurData('x', height1),
        spurData('y', height2),
        spurData('z', height3)
    },
    platforms = {
        crumblingPlatformData('l', height1),
        crumblingPlatformData('m', height2),
        crumblingPlatformData('n', height3),
        movingPlatformData('r', height1),
        movingPlatformData('s', height2),
        movingPlatformData('t', height3)
    },
    turrets = {
        turretData('e', height1, false),
        turretData('f', height1, true),
        turretData('g', height2, false),
        turretData('h', height2, true),
        turretData('i', height3, false),
        turretData('j', height3, true)
    }
}

function getBlockData()
    return blockTable
end