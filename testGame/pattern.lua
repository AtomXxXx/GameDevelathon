local M = {}

local function fireBullet()

    for i = 1, M.numBulletsTogether do
        local bullet = require("bullet")
        bullet.spawnBullet({
            startPosX = M.startPosX, 
            startPosY = M.startPosY, 
            bulletName = M.bulletName,
            angle = M.angle * i,
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

    M.numBulletsTogether = 3
    M.angleBetweenBullets = 10
    M.speedOfBullet = 275
    M.timeGapFrames = 7
    M.angle = 50
    M.rateAnglePerFrame = 0.8
    M.maxRotation = 30

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


return M