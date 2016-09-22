local M = {}

local function fireBullet()

    for i = 1, M.numBulletsTogether do
        local bullet = require("bullet")
        bullet.spawnBullet({
            startPosX = M.startPosX, 
            startPosY = M.startPosY, 
            bulletName = M.bulletName,
            angle = M.angle + (M.angleBetweenBullets * (i - 1)),
            speed = M.speedOfBullet,
            damage = M.damage,
            group = M.group,
            imageFile = M.bulletImage,
            radius = M.bulletRadius
        })
    end
end

local function updatePattern()
    M.currentFrame = M.currentFrame + 1

    if((M.rateAnglePerFrame > 0 and M.angle > M.startAngle + 30) or (M.rateAnglePerFrame < 0 and M.angle < M.startAngle - 30)) then
        M.rateAnglePerFrame = M.rateAnglePerFrame * -1
    end

    M.angle = M.angle + M.rateAnglePerFrame

    if(M.currentFrame >= M.timeGapFrames) then
        M.currentFrame = 0
        fireBullet()
    end

end

function M.startPattern(params)

    --[[M.numBulletsTogether = 3
    M.angleBetweenBullets = 30
    M.speedOfBullet = 300
    M.timeGapFrames = 10
    M.angle = 60
    M.rateAnglePerFrame = 0.8
    M.maxRotation = 60]]

    M.numBulletsTogether = params.numBulletsTogether
    M.angleBetweenBullets = params.angleBetweenBullets
    M.speedOfBullet = params.speedOfBullet
    M.timeGapFrames = params.timeGapFrames
    M.angle = params.angle
    M.rateAnglePerFrame = params.rateAnglePerFrame
    M.maxRotation = params.maxRotation

    M.startPosX = params.startPosX
    M.startPosY = params.startPosY
    M.bulletName = params.bulletName
    M.damage = params.damage
    M.group = params.group
    M.bulletImage = params.bulletImage
    M.bulletRadius = params.bulletRadius

    M.startAngle = M.angle
    M.currentFrame = 1

    Runtime:addEventListener("enterFrame", updatePattern)

end

function M.stopPattern()
    Runtime:removeEventListener("enterFrame", updatePattern)
end

function M.destroyAll(group)
    group:removeSelf()
end


return M