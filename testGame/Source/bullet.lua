local M = {}

local function setVelocity(angle, speed)
    local vel = {x = 1, y = 0}
    local newVel = {x = 0, y = 0}

    local degToRad = math.pi / 180
    local angleRad = angle * degToRad

    local cos = math.cos(angleRad)
    local sin = math.sin(angleRad)

    newVel.x = cos * vel.x - sin * vel.y
    newVel.y = sin * vel.x + cos * vel.y

    newVel.x = newVel.x * speed
    newVel.y = newVel.y * speed
    M.bullet:setLinearVelocity(newVel.x, newVel.y)
end

 function updateBullet()
    if(M.bullet.x < -100 or M.bullet.x > display.contentWidth + 100 
    or M.bullet.y < -100 or M.bullet.y > display.contentHeight + 100) then
        M.bullet:removeSelf()
        Runtime:removeEventListener("enterFrame", updateBullet)
    end
end

function M.destroyBullet()
    M.bullet:removeSelf()
    print("yello")
    M.bullet = nil
end

function M.spawnBullet(params)
    bulletRadius = 10
    if (params.radius) then bulletRadius = params.radius end

    path = params.imageFile
    if(path == nil) then
        M.bullet = display.newCircle(params.startPosX, params.startPosY, bulletRadius)
    else
        M.bullet = display.newImage(path)
        M.bullet.x = params.startPosX
        M.bullet.y = params.startPosY
    end
    M.bullet.name = params.bulletName
    if(params.bulletName == nil) then 
        M.bullet.name = "Bullet"
    end
    M.bullet.damage = params.damage
    
    group = params.group
    group:insert(M.bullet)

    if(path == nil) then
        physics.addBody(M.bullet, "dynamic", {radius = bulletRadius, isSensor = true})
    else
        physics.addBody(M.bullet, "dynamic", {isSensor = true})
    end
    --updateBullet is unpredictable and causing errors
    --Runtime:addEventListener("enterFrame", updateBullet)
    
    --this will do for now since there are no super slow bullets
    --timer:performWithDelay(50, function() M.destroyBullet() end)
    
    if(params.bulletName == "PlayerBeam") then
        M.bullet.isBullet = true
    end
    setVelocity(params.angle, params.speed)
end

return M
