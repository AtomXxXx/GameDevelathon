local M = {}

local function fireBullets()

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
    M.currentDelta = M.currentDelta + _G.deltaTime

    -- Change direction of the rate of angle when angle exceeds max rotation 
    if((M.rateAnglePerSec > 0 and M.angle > M.startAngle + M.maxRotation / 2) or (M.rateAnglePerSec < 0 and M.angle < M.startAngle - M.maxRotation / 2)) then
        M.rateAnglePerSec = M.rateAnglePerSec * -1
    end

    M.angle = M.angle + M.rateAnglePerSec * _G.deltaTime

    if(M.currentDelta >= M.timeGapSec) then
        M.currentDelta = 0
        fireBullets()
    end

end

function M.startPattern(params)

    --[[M.numBulletsTogether = 3
    M.angleBetweenBullets = 30
    M.speedOfBullet = 300
    M.timeGapSec = 10
    M.angle = 60
    M.rateAnglePerSec = 0.8
    M.maxRotation = 60]]

    M.numBulletsTogether = params.numBulletsTogether
    M.angleBetweenBullets = params.angleBetweenBullets
    M.speedOfBullet = params.speedOfBullet
    M.timeGapSec = params.timeGapSec
    M.angle = params.angle
    M.rateAnglePerSec = params.rateAnglePerSec
    M.maxRotation = params.maxRotation

    M.startPosX = params.startPosX
    M.startPosY = params.startPosY
    M.bulletName = params.bulletName
    M.damage = params.damage
    M.group = params.group
    M.bulletImage = params.bulletImage
    M.bulletRadius = params.bulletRadius

    M.startAngle = M.angle
    M.currentDelta = 0

    Runtime:addEventListener("enterFrame", updatePattern)

end

function M.stopPattern()
    M.currentDelta = 0
    Runtime:removeEventListener("enterFrame", updatePattern)
end

function M.destroyAll(group)
    group:removeSelf()
end


return M