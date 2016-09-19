local M = {}

local function followPattern()
    local vel = {x = 0, y = 1}
    vel.x = vel.x * M.bullet.speed
    vel.y = vel.y * M.bullet.speed
    M.bullet:setLinearVelocity(vel.x, vel.y)
end

function M.spawnBullet(params)
    bulletRadius = 10

    M.bullet = display.newCircle(params.shipPosX, params.shipPosY, bulletRadius)
    M.bullet.name = params.bulletName
    M.bullet.radius = bulletRadius
    M.bullet.startPosX = params.startPosX
    M.bullet.startPosY = params.startPosY

    M.bullet.shipPosX = params.shipPosX
    M.bullet.shipPosY = params.shipPosY

    M.bullet.angle = params.angle
    M.bullet.speed = params.speed

    group = params.group
    group:insert(M.bullet)

    physics.addBody(M.bullet, "dynamic", {radius = bulletRadius, isSensor = true})
    
    transition.to(M.bullet, {x = startPosX, y = startPosY, 10, onComplete = function() followPattern() end})
end

function M.changeDirection(params)

end

return M