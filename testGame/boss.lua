local M = {}

local function initBoss(planetName, group)
    if(planetName == "Mercury") then
        M.boss = display.newImage("images/EnemyShips/6.png")
        M.boss.health = 1000
        M.boss.patternNum = 1
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Venus") then
        --M.boss = display.newImage("images/EnemyShips/11.png")
        M.boss = display.newImage("images/EnemyShips/9.png")
        M.boss.health = 150
        M.boss.patternNum = 2
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Earth") then
        M.boss = display.newImage("images/EnemyShips/1.png")
        M.boss.health = 150
        M.boss.patternNum = 4
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Mars") then
        --M.boss = display.newImage("images/EnemyShips/2.png")
        M.boss = display.newImage("images/EnemyShips/6.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Jupiter") then
        M.boss = display.newImage("images/EnemyShips/3.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Saturn") then
        M.boss = display.newImage("images/EnemyShips/4.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Uranus") then
        M.boss = display.newImage("images/EnemyShips/9.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Neptune") then
        M.boss = display.newImage("images/EnemyShips/13.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	elseif(planetName == "Pluto") then
        M.boss = display.newImage("images/EnemyShips/88.png")
        M.boss.health = 150
        M.boss.patternNum = math.random(5)
        physics.addBody(M.boss, "kinematic")
	
    end    
end

local function getPatternOptions(num, bulletGroup)

    local options = {}
    options.startPosX = M.boss.x
    options.startPosY = M.boss.y
    options.bulletName = "BossBullet"
    options.damage = 10
    options.group = bulletGroup
    if(math.random(2) == 1) then
        options.bulletImage = "images/bossbulletred14.png"
    else
        options.bulletImage = "images/bossbulletpurple14.png"
    end
    options.bulletRadius = 7
    if(num == 1) then
        options.numBulletsTogether = 10
        options.angleBetweenBullets = 13
        options.speedOfBullet = 250
        options.timeGapSec = 28 / 30
        options.angle = 45
        options.rateAnglePerSec = 2 * 30
        options.maxRotation = 60
    elseif(num == 2) then
        options.numBulletsTogether = 3
        options.angleBetweenBullets = 30
        options.speedOfBullet = 250
        options.timeGapSec = 13 / 30
        options.angle = 60
        options.rateAnglePerSec = 0.8* 30
        options.maxRotation = 60
    elseif(num == 3) then
        options.numBulletsTogether = 3
        options.angleBetweenBullets = 30
        options.speedOfBullet = 250
        options.timeGapSec = 13 / 30
        options.angle = 60
        options.rateAnglePerSec = 0.8 * 30
        options.maxRotation = 60
        --[[options.numBulletsTogether = 2
        options.angleBetweenBullets = 30
        options.speedOfBullet = 275
        options.timeGapSec = 12 / 30
        options.angle = 75
        options.rateAnglePerSec = 0.8 * 30
        options.maxRotation = 60

        options.damage = 20
        options.bulletImage = nil
        options.bulletRadius = 18]]
    elseif(num == 4) then
        options.numBulletsTogether = 20
        options.angleBetweenBullets = 18
        options.speedOfBullet = 180
        options.timeGapSec = 18 / 30
        options.angle = 0
        options.rateAnglePerSec = 0.5 * 30
        options.maxRotation = 360
    elseif(num == 5) then
        options.numBulletsTogether = 10
        options.angleBetweenBullets = 13
        options.speedOfBullet = 250
        options.timeGapSec = 28 / 30
        options.angle = 45
        options.rateAnglePerSec = 2 * 30
        options.maxRotation = 60
        --[[options.numBulletsTogether = 1
        options.angleBetweenBullets = 0
        options.speedOfBullet = 275
        options.timeGapSec = 16 / 30
        options.angle = 85
        options.rateAnglePerSec = 0.5 * 30
        options.maxRotation = 10

        options.damage = 30
        options.bulletImage = nil
        options.bulletRadius = 25]]
    end

    return options
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
    if(M.boss.x and M.boss.y) then
        M.boss.shooting = true
        M.boss.pattern = require("pattern")
        --M.boss.pattern.startPattern(getPatternOptions(4, bulletGroup))
        M.boss.pattern.startPattern(getPatternOptions(M.boss.patternNum, bulletGroup))
    end
end

function M.onDeath()
    if(M.boss.shooting) then
        M.boss.shooting = false
        M.boss.pattern.stopPattern()
    end
end

local function onTransitionComplete(bulletGroup)
    --fire(bulletGroup)
end

function M.LooseHealth(amount)
    M.boss.health = M.boss.health - amount
    if(M.boss.health <= 0) then
        
    end
end

function M.updateBoss()
    local velX, velY = M.boss:getLinearVelocity()
    if(M.boss.y + velY * _G.deltaTime > M.boss.height / 2) then
        M.boss.y = M.boss.height / 2
        M.boss:setLinearVelocity(0,0)
        onTransitionComplete(M.boss.bulletGroup)
        Runtime:removeEventListener("enterFrame", M.updateBoss)
    end
end

function M.spawnBoss(params)
    local planetName = params.planetName
    local group = params.group

    initBoss(planetName, group)
    M.boss.bulletGroup = params.bulletGroup
    M.boss.name = "BossShip"
    M.boss.x = display.contentWidth / 2
    M.boss.y = -M.boss.height / 2
    M.boss.shooting = false
    group:insert(M.boss)
    --transition.to(M.boss, {y = M.boss.height / 2, 10, onComplete = function() onTransitionComplete(bulletGroup) end})
    M.boss:setLinearVelocity(0, 100)
    Runtime:addEventListener("enterFrame", M.updateBoss)
end

function M.destroyImmediate()
    if(M.boss) then
        M.boss:removeSelf()
    end
    if(M.boss.pattern) then
        if(M.boss.shooting) then
            M.boss.pattern.stopPattern()
        end
        M.boss.pattern.destroyAll(M.boss.bulletGroup)
    end
end

return M