local M = {}

local function initBoss(planetName, group)
    if(planetName == "Mercury") then
        M.boss = display.newImage("images/EnemyShips/2.png")
        physics.addBody(M.boss, "dynamic", {isSensor = true})
    end    
end

function M.spawnBoss(params)
    planetName = params.planetName
    group = params.group

    initBoss(planetName, group)
    M.boss.x = display.contentWidth / 2
    M.boss.y = -M.boss.height / 2
    M.boss.canShoot = false
    M.boss.health = 100
    transition.to(M.boss, {y = M.boss.height / 2, 10, onComplete = function() M.boss.canShoot = true end})
end

return M