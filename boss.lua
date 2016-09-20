local M = {}

local function initBoss(planetName, group)
    if(planetName == "Mercury") then
        M.boss = display.newImage("images/EnemyShips/6.png")
        M.boss.health = 100
        --physics.addBody(M.boss, "dynamic", {isSensor = true})
        physics.addBody(M.boss, "kinematic")
    end    
end

local function fire(bulletGroup)
    --[[local spawnBullet = require("bullet").spawnBullet
    spawnBullet({startPosX = M.boss.x, 
        startPosY = M.boss.y, 
        shipPosX = M.boss.x,
        shipPosY = M.boss.y,
        bulletName = "BossBullet",
        angle = 90,
        speed = 150,
        damage = 10,
        group = bulletGroup
    })]]
    M.boss.pattern = require("pattern")
    M.boss.pattern.startPattern({
        startPosX = M.boss.x,
        startPosY = M.boss.y,
        bulletName = "BossBullet",
        damage = 10,
        group = bulletGroup,
        bulletImage = nil,
        bulletRadius = 8
    })
end

function M.onDeath()
    M.boss.pattern.stopPattern()
end

local function onTransitionComplete(bulletGroup)
    canShoot = true
    fire(bulletGroup)
end

function M.LooseHealth(amount)
    M.boss.health = M.boss.health - amount
    if(M.boss.health <= 0) then
        
    end
end

function M.spawnBoss(params)
    planetName = params.planetName
    group = params.group
    bulletGroup = params.bulletGroup

    initBoss(planetName, group)
    M.boss.name = "BossShip"
    M.boss.x = display.contentWidth / 2
    M.boss.y = -M.boss.height / 2
    M.boss.canShoot = false
    M.boss.health = 100
    transition.to(M.boss, {y = M.boss.height / 2, 10, onComplete = function() onTransitionComplete(bulletGroup) end})
end



return M