local M = {}

local function initBoss(planetName, group)
    if(planetName == "Mercury") then
        M.boss = display.newImage("images/EnemyShips/6.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
     
	elseif(planetName == "Venus") then
        M.boss = display.newImage("images/EnemyShips/11.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Earth") then
        M.boss = display.newImage("images/EnemyShips/1.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Mars") then
        M.boss = display.newImage("images/EnemyShips/2.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Jupiter") then
        M.boss = display.newImage("images/EnemyShips/3.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Saturn") then
        M.boss = display.newImage("images/EnemyShips/4.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Uranus") then
        M.boss = display.newImage("images/EnemyShips/9.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Neptune") then
        M.boss = display.newImage("images/EnemyShips/13.png")
        M.boss.health = 100
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Pluto") then
        M.boss = display.newImage("images/EnemyShips/88.png")
        M.boss.health = 100
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