local pd <const> = playdate
local gfx <const> = playdate.graphics

local function getDitheredImage(image)
    local ditheredImage = gfx.image.new(image:getSize())
    gfx.pushContext(ditheredImage)
        image:drawFaded(0, 0, 0.3, gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    return ditheredImage
end

local height1 = LEVEL_BASE_Y

local function blockData(blockImage, letter, baseHeight, adjustableHeight, iconImage)
    local ditheredBlock = getDitheredImage(blockImage)
    if not iconImage then
        iconImage = blockImage:scaledImage(0.5)
    end
    return {
        icon = iconImage,
        blockImage = blockImage,
        ditheredBlock = ditheredBlock,
        baseHeight = baseHeight,
        adjustableHeight = adjustableHeight,
        letter = letter
    }
end

local function platform1Data(letter)
    local blockImage = gfx.image.new("images/blocks/platform1")
    return blockData(blockImage, letter, height1, true)
end

local function spikeData(letter)
    local blockImage = gfx.image.new("images/levelEditor/blocks/spike")
    local iconImage = gfx.image.new("images/levelEditor/blocks/spikeIcon")
    return blockData(blockImage, letter, height1 - 16, true, iconImage)
end

local function horizontalMovingSpikeData(letter)
    local blockImage = gfx.image.new("images/blocks/spikeBall")
    return blockData(blockImage, letter, height1, true)
end

local function verticalMovingSpikeData(letter)
    local blockImage = gfx.image.new("images/levelEditor/blocks/verticalMovingSpike")
    local iconImage = gfx.image.new("images/levelEditor/blocks/spikeBallIcon")
    return blockData(blockImage, letter, height1 - 64, false, iconImage)
end

local function spurData(letter)
    local blockImage = gfx.image.new("images/blocks/spur")
    return blockData(blockImage, letter, height1, true)
end

local function turretData(letter, flipped)
    local blockImage = gfx.image.new("images/levelEditor/blocks/turret")
    local iconImage = gfx.image.new("images/levelEditor/blocks/turretIcon")
    if flipped then
        blockImage = gfx.image.new("images/levelEditor/blocks/turretFlipped")
        iconImage = gfx.image.new("images/levelEditor/blocks/turretIconFlipped")
    end
    return blockData(blockImage, letter, height1 - 48, true, iconImage)
end

local function crumblingPlatformData(letter)
    local blockImage = gfx.image.new("images/blocks/crumblingPlatform")
    return blockData(blockImage, letter, height1, true)
end

local function movingPlatformData(letter)
    local blockImage = gfx.image.new("images/blocks/movingPlatform")
    return blockData(blockImage, letter, height1, true)
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

local letterToBlock = {}
for _, blockTableData in ipairs(blockTable) do
    local blockLetter = blockTableData.letter
    local blockHeight = blockTableData.baseHeight
    local blockImage = blockTableData.blockImage
    letterToBlock[blockLetter] = {
        blockImage = blockImage,
        blockHeight = blockHeight
    }
    if blockHeight then
        local blockSize = 32
        letterToBlock[string.char(string.byte(blockLetter) + 1)] = {
            blockImage = blockImage,
            blockHeight = blockHeight - blockSize
        }
        letterToBlock[string.char(string.byte(blockLetter) + 2)] = {
            blockImage = blockImage,
            blockHeight = blockHeight - blockSize * 2
        }
    end
end

function getLetterToBlock()
    return letterToBlock
end

function getBlockData()
    return blockTable
end