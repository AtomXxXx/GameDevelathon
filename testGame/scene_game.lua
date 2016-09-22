local composer = require( "composer" )
local json = require("json")
local scene = composer.newScene()
local gameRunning = true


local planetNames = {"Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"}
local currentPlanet = 2
local onPlanet = false
local inBossBattle = false
local shipMaxSpeed = 275
local numLanes = 5
local laneWidth = display.contentWidth / numLanes
local laneMiddleX = laneWidth / 2
local currentLane = 2
local lanes = {}
local score = 0
local bossCount = 0

local scoreText
local bossHealthText
local countDownText
local fireButton
local starbg
local getPlanet
local ship
local bottomOfScreen
local hpBg
local hpFg
local hpWarningOnScreen = false
local hp
local energy = 100
local energyPerBullet = 20
local maxEnergy = 100
local energyBg
local energyFg

local bossHpBg
local bossHpFg
local bossHp
local maxBossHp

local enableAccelerometer
local enableMusic
local shipImage
local enableKeyboard = true

local physics = require("physics")
local onAllPlanetsDone

function scene:create(event)

system.setIdleTimer(false)

local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
local file, errorstring = io.open(path, "r")
local string = file:read("*a")
local settings = json.decode(string)
file:close()
file = nil

enableAccelerometer = settings.accelerometerOn
enableMusic = settings.musicOn
shipImage = settings.ship

container = display.newContainer(display.contentWidth, display.contentHeight)
container.x = display.contentWidth / 2
container.y = display.contentHeight / 2

self.view = container

background5 = display.newGroup()
background5.x = -display.contentWidth / 2
background5.y = -display.contentHeight / 2
container:insert(background5)

background4 = display.newGroup()
background4.x = -display.contentWidth / 2
background4.y = -display.contentHeight / 2
container:insert(background4)

background3 = display.newGroup()
background3.x = -display.contentWidth / 2
background3.y = -display.contentHeight / 2
container:insert(background3)

background2 = display.newGroup()
background2.x = -display.contentWidth / 2
background2.y = -display.contentHeight / 2
container:insert(background2)

background1 = display.newGroup()
background1.x = -display.contentWidth / 2
background1.y = -display.contentHeight / 2
container:insert(background1)

bullets = display.newGroup()
bullets.x = -display.contentWidth / 2
bullets.y = -display.contentHeight / 2
container:insert(bullets)

enemyGroup = display.newGroup()
enemyGroup.x = -display.contentWidth / 2
enemyGroup.y = -display.contentHeight / 2
container:insert(enemyGroup)

group = display.newGroup()
group.x = -display.contentWidth / 2
group.y = -display.contentHeight / 2
container:insert(group)

spaceDusts = display.newGroup()
spaceDusts.x = -display.contentWidth / 2
spaceDusts.y = -display.contentHeight / 2
container:insert(spaceDusts)

hud = display.newGroup()
hud.x = -display.contentWidth / 2
hud.y = -display.contentHeight / 2
container:insert(hud)


-- CREATING HEADS UP DISPLAY

scoreText = display.newText({text = score, font = native.systemFontBold, fontSize = 34})
scoreText.anchorX = 0
scoreText.anchorY = 0
scoreText:setFillColor(1,1,1)
hud:insert(scoreText)

bossHealthText = display.newText({text = "", font = native.systemFontBold, fontSize = 34})
bossHealthText.anchorX = 0
bossHealthText.anchorY = 0
bossHealthText:setFillColor(1,1,1)
bossHealthText.x = display.contentWidth - bossHealthText.width
bossHealthText.y = 0
hud:insert(bossHealthText)

countDownText = display.newText({text = "", font = native.systemFontBold, fontSize = 30})
countDownText:setFillColor(1,1,1)
countDownText.x = display.contentWidth / 2
countDownText.y = display.contentHeight * 0.05
hud:insert(countDownText)

hpBg = display.newRect( 5, display.contentHeight - 25, 104, 25 )
hpBg.anchorX = 0
hpBg:setFillColor( 1, 1, 1, 0.5 )
hud:insert(hpBg)

hpFg = display.newRect( hpBg.x + 2, hpBg.y, 100, 18 )
hpFg.anchorX = 0
hpFg:setFillColor( 0.2, 0.85, 0.4 )
hud:insert(hpFg)

energyBg = display.newRect(display.contentWidth - 105, display.contentHeight - 25, 104, 25)
energyBg.anchorX = 0
energyBg:setFillColor( 1, 1, 1, 0.5 )
hud:insert(energyBg)

energyFg = display.newRect( energyBg.x + 2, energyBg.y, 100, 18 )
energyFg.anchorX = 0
energyFg:setFillColor( 0.2, 0.4, 0.85 )
hud:insert(energyFg)

hpWarningText = display.newText({text = "", font = native.systemFontBold, fontSize = 30})
hpWarningText.x = display.contentWidth / 2
hpWarningText.y = display.contentHeight / 2
hud:insert(hpWarningText)

-- ANIMATION
local sheetOptions =
{
    width = 128,
    height = 128,
    numFrames = 64
	
}
local sheetExplosion = graphics.newImageSheet( "images/boom.png", sheetOptions )
local sequencesExplosion = {
    {
        name = "Explode",
        start = 1,
        count = 64,
        time = 800,
        loopCount = 1,
        loopDirection = "forward"	
    }
}

local function animateExplode(x, y)
    local Explosion = display.newSprite( sheetExplosion, sequencesExplosion)
	Explosion:setSequence( "Explode" )
    Explosion.x = x
    Explosion.y = y
	Explosion:play()
    timer.performWithDelay(805, function() Explosion:removeSelf() end)
end

if(enableAccelerometer == false) then
    fireButton = display.newImage("images/fire.png")
    fireButton.alpha = 0.3
    fireButton.x = display.contentWidth - fireButton.width
    fireButton.y = display.contentCenterY +100
    hud:insert(fireButton)
end

-- CREATING ALL THE OBJECTS ON SCREEN
if (enableMusic) then
    local backgroundMusic = audio.loadStream( "ingame.mp3" )
    local backgroundMusic = audio.play( backgroundMusic, { channel=1, loops=-1} )
end

starbg = display.newImage("images/starsbackground.png")
starbg:scale(1.0, 1.2)
starbg.anchorX = 0
starbg.anchorY = 0
background5:insert(starbg)

getPlanet = require("planets").getPlanet
--local planet = getPlanet({planetName = "Sun"})
--background1:insert(planet)

ship = display.newImage(shipImage)
ship.name = "PlayerShip"
ship:translate(0,display.contentHeight - 100)

--ship.x = laneWidth * currentLane + laneMiddleX
ship.x = display.contentWidth / 2
group:insert(ship)

local function setHp( hp )
	hpFg.width = (hpBg.width - 4) * hp / 100
	hpFg:setFillColor( 100/hp, hp/100, 0 )
end

local function setBossHp( bhp )
	bossHpFg.width = (bossHpBg.width - 4) * bhp / maxBossHp
	bossHpFg:setFillColor( 100/maxBossHp, bhp/maxBossHp, 0 )
end

local function setEnergy(enrgy)
    energy = enrgy
    if(energy < 0) then
        energy = 0
    elseif(energy >= maxEnergy) then
        energy = maxEnergy
    end
    energyFg.width = (energyBg.width - 4) * energy / 100
end

hp = 100
setHp(hp)

local function blinkHpWarning()

    if(gameRunning) then
    if(hp <= 20) then

        if(hpWarningOnScreen == false) then
            hpWarningText.text = "HP LOW"
            hpWarningOnScreen = true
        else
            hpWarningText.text = ""
            hpWarningOnScreen = false
        end
    else
        hpWarningText.text = ""
        hpWarningOnScreen = false
    end
    timer.performWithDelay(500, blinkHpWarning)
    end
end

blinkHpWarning()

local function boundShipToScreen(speed)
    if (ship.x < ship.width / 2) then
        print("hi")
        ship.x = ship.width / 2
        ship:setLinearVelocity(0, 0 )
    elseif (ship.x > display.contentWidth - ship.width / 2) then
        ship.x = display.contentWidth - ship.width / 2
        ship:setLinearVelocity(0, 0 )
    elseif (ship.x == ship.width / 2 and speed < 0) then
        ship:setLinearVelocity(0, 0)
    elseif(ship.x == display.contentWidth - ship.width / 2 and speed > 0) then
        ship:setLinearVelocity(0, 0)
    end
end

local function onTilt(event)
    local speed = event.xRaw / 0.3

    if(speed > 1) then
        speed = 1
    elseif(speed < -1) then
        speed = -1
    end

    ship:setLinearVelocity( speed * shipMaxSpeed, 0 )
    boundShipToScreen(speed)
end
if(enableAccelerometer) then
    Runtime:addEventListener( "accelerometer", onTilt )
end

local function moveShipLeft()
    if (holding and gameRunning) then
        ship:setLinearVelocity( -shipMaxSpeed, 0 )
        boundShipToScreen(-shipMaxSpeed)
    end
end
local function moveShipRight()
    if(holding and gameRunning) then
        ship:setLinearVelocity( shipMaxSpeed, 0 )
        boundShipToScreen(shipMaxSpeed)
    end
end

local function touchHandler( event )
    local fireButtonLeft = fireButton.x - fireButton.width / 2
    local fireButtonRight = fireButton.x + fireButton.width / 2
    local fireButtonTop = fireButton.y - fireButton.height / 2
    local fireButtonBottom = fireButton.y + fireButton.height / 2
    if(not (event.x > fireButtonLeft and event.x < fireButtonRight and event.y < fireButtonBottom and event.y > fireButtonTop)) then
        if (event.phase == "began") then

            display.getCurrentStage():setFocus( event.target )
            event.target.isFocus = true

            if (event.x <= display.contentWidth / 2) then
                Runtime:addEventListener( "enterFrame", moveShipLeft )
            elseif(event.x > display.contentWidth / 2) then
                Runtime:addEventListener( "enterFrame", moveShipRight )
            end

            holding = true

        elseif (event.target.isFocus) then
            if (event.phase == "moved") then
            elseif (event.phase == "ended" or event.phase == "cancelled") then
                holding = false
                event.target.isFocus = false

                if (event.x <= display.contentWidth / 2) then
                    Runtime:removeEventListener( "enterFrame", moveShipLeft )
                    ship:setLinearVelocity(0, 0)
                elseif(event.x > display.contentWidth / 2) then
                    Runtime:removeEventListener( "enterFrame", moveShipRight )
                    ship:setLinearVelocity(0, 0)
                end

                display.getCurrentStage():setFocus( nil )
            end
        end
    end
end
if ( enableAccelerometer == false) then
    starbg:addEventListener("touch", touchHandler)
end

local function onKeyEvent(event)
    if(gameRunning) then
        if(event.keyName == "left") then
            if(event.phase == "down") then
                ship:setLinearVelocity(-shipMaxSpeed, 0)
            elseif(event.phase == "up") then
                ship:setLinearVelocity(0, 0)
            end
        elseif(event.keyName == "right") then
            if(event.phase == "down") then
                ship:setLinearVelocity(shipMaxSpeed, 0)
            elseif(event.phase == "up") then
                ship:setLinearVelocity(0, 0)
            end
            boundShipToScreen(shipMaxSpeed)
        end
    end
end

if (enableKeyboard) then
    Runtime:addEventListener("key", onKeyEvent)
end

bottomOfScreen = display.newRect(0, display.contentHeight + laneWidth / 2, display.contentWidth, 50)
bottomOfScreen.anchorX = 0
bottomOfScreen.anchorY = 0
bottomOfScreen.name = "BottomOfScreen"
group:insert(bottomOfScreen)

-- PHYSICS

--physics.setDrawMode("hybrid")
physics.setPositionIterations(256)
physics.setVelocityIterations(256)
physics.start()
physics.setGravity(0, 0)

local function onCollisionWithShip(self, event)
    if (event.phase == "began") then
        if(event.other.name == "GoodShip") then
            score = score + 1
            event.other:removeSelf()
            scoreText.text = score
        elseif(event.other.name == "BadShip") then
            animateExplode(event.other.x, event.other.y)
            hp = hp - 10
            setHp(hp)
            ship:setFillColor(1,0,0)
            timer.performWithDelay(100, function() ship:setFillColor(1) end)
            event.other:removeSelf()
        elseif(event.other.name == "BossBullet") then
            hp = hp - event.other.damage
            setHp(hp)
            ship:setFillColor(1,0,0)
            timer.performWithDelay(100, function() ship:setFillColor(1) end)
            event.other:removeSelf()
        end
    end
end

local function onBossDead(bossShip)
    bossCount = bossCount + 1
    bossHpBg:removeSelf()
    bossHpFg:removeSelf()
    animateExplode(bossShip.x, bossShip.y)
    inBossBattle = false
    boss.onDeath()
    bossShip:removeSelf()
    bossHealthText.text = ""
    if(currentPlanet > 10) then
        onAllPlanetsDone()
    end
end

local function onCollision(event)
    if(event.phase == "began") then
        obj1 = event.object1
        obj2 = event.object2

        if ((obj1.name == "PlayerBeam" and obj2.name == "BadShip") or (obj2.name == "PlayerBeam" and obj1 == "BadShip")) then
            if(obj1.name == "PlayerBeam") then
                animateExplode(obj2.x, obj2.y)
            else
                animateExplode(obj1.x, obj1.y)
            end
            obj1:removeSelf()
            obj2:removeSelf()
            score = score + 10
            scoreText.text = score
            return true
        elseif ((obj1.name == "BossShip" and obj2.name == "PlayerBeam") or (obj2.name == "BossShip" and obj1 == "PlayerBeam")) then
            bossShip = obj1
            beam = obj2
            if(obj1.name == "PlayerBeam") then
                bossShip = obj2
                beam = obj1
            end
            beam:removeSelf()
            score = score + 2
            scoreText.text = score
            bossShip.health = bossShip.health - beam.damage
            setBossHp(bossShip.health)
            bossHealthText.text = bossShip.health
            bossHealthText.x = display.contentWidth - bossHealthText.width
            if(bossShip.health <= 0) then
                onBossDead(bossShip)
            else
                bossShip:setFillColor(1,0,0)
                timer.performWithDelay(100, function() bossShip:setFillColor(1) end)
            end
            return true
        end
    end
end

Runtime:addEventListener("collision", onCollision)

local function onCollisionAtBottomOfScreen(self, event)
    if(event.phase == "began" and self.name == "BottomOfScreen") then
        if(event.other.name == "GoodShip") then
            score = score - 1
            scoreText.text = score
        end
        event.other:removeSelf()
    end
end

physics.addBody(ship, "kinematic", {radius = 30})
ship.collision = onCollisionWithShip
ship:addEventListener("collision")

physics.addBody(bottomOfScreen, "static")
bottomOfScreen.collision = onCollisionAtBottomOfScreen
bottomOfScreen:addEventListener("collision")

local function createEnemyShip()
    if(gameRunning) then
    if(not inBossBattle) then
        local shipLane = math.random(5) -1
        local shipVelocityY = 190
        local shipRadius = laneWidth / 4
        local shipY = -shipRadius
        shipX = shipLane * laneWidth + laneMiddleX
        local ship
        if (math.random(100) < 0) then
            ship = display.newImage("images/enemyship.png")
            ship.name = "GoodShip"
            group:insert(ship)
        else
            ship = display.newImage("images/enemyship2.png")
            --ship = display.newImage("images/EnemyShips/Alien-Destroyer.png")
            ship.name = "BadShip"
            enemyGroup:insert(ship)
        end
        ship.x = shipX

        physics.addBody(ship, "dynamic", {radius = shipRadius})
        ship:setLinearVelocity(0, shipVelocityY)

    end
    
    timer.performWithDelay(1500, createEnemyShip)
    end
end

local function fireBeam(ship, y1, time1, beam, beamOrigin)
    if(energy >= energyPerBullet) then
        setEnergy(energy - energyPerBullet)
        local spawnBullet = require("bullet").spawnBullet
        spawnBullet({startPosX = ship.x, 
            startPosY = ship.y, 
            shipPosX = ship.x,
            shipPosY = ship.y,
            bulletName = beamOrigin,
            angle = -90,
            speed = 1000,
            damage = 10,
            group = bullets,
            imageFile = beam
        })
    end
end

local function fireBeamInvoker()
    fireBeam(ship, -100, 500, "images/beam.png", "PlayerBeam")
end

if(enableAccelerometer == false) then
    fireButton:addEventListener("tap", fireBeamInvoker)
else
    Runtime:addEventListener("tap", fireBeamInvoker)
end

--local tm = timer.performWithDelay(1500, createEnemyShip, 0)
createEnemyShip()

local function getRandomStar(scale)
    local starnum = math.random(3)
    local star
    if (starnum == 1) then 
        star = display.newImage("images/star1.png")
        star:scale(0.1 * scale, 0.1 * scale)
    elseif (starnum == 2) then
        star = display.newImage("images/star2.png")
        star:scale(0.05 * scale, 0.05 * scale)
    elseif (starnum == 3) then
        star = display.newImage("images/star3.png")
        star:scale(0.15 * scale, 0.15 * scale)
    end
    return star
end

local function createStars(scale, group)
    if(gameRunning) then
        if(group.numChildren < 11) then
            local star = getRandomStar(scale)
            star.x = math.random(display.contentWidth)
            star.y = -star.height / 2
            group:insert(star)
        end
        local timeToNextStar = math.random(5000)
        if(inBossBattle) then
            timeToNextStar = math.random(20000)
        end
        timer.performWithDelay(timeToNextStar, function() createStars(scale, group) end)
    end
end

local function initStars(scale, group)
    for i = 1, 10 do
        local star = getRandomStar(scale)
        star.x = math.random(display.contentWidth)
        star.y = math.random(display.contentHeight)
        group:insert(star)
    end
end

initStars(1.0, background2)
initStars(0.8, background3)
initStars(0.6, background4)

createStars(1.0, background2)
createStars(0.8, background3)
createStars(0.6, background4)

local function createSpaceDust()

    if(gameRunning) then
        local spaceDust = display.newRect(math.random(display.contentWidth), -20, 1.2, display.contentHeight / 6)
        spaceDust.anchorY = 0
        spaceDust.alpha = 0.3
        spaceDusts:insert(spaceDust)
        timer.performWithDelay(math.random(150), createSpaceDust)
    end
end


createSpaceDust()

local function moveObjectsInGroup(group, speed)
    if( not (group.numChildren == 0 or group.numChildren == nil)) then
        for i=1, group.numChildren do
            group[i].y = group[i].y + speed
        end

        local j = 1
        for i=1, group.numChildren do
            if(group[j].y > display.contentHeight) then
                group[j]:removeSelf()
                j = j - 1
            end
            j = j + 1
        end
    end
end

local function countDownToPlanet(name, timeSec)
    if(gameRunning) then
        countDownText.text = name .. ": " .. timeSec
        if(timeSec == 0) then
            countDownText.text = ""
        else
            timer.performWithDelay(1000, function() countDownToPlanet(name, timeSec - 1) end)
        end
    end
end

local function initBossBattle(planetnm)
    inBossBattle = true
    boss = require("boss")
    --spawnBoss = require("boss").spawnBoss
    boss.spawnBoss({planetName = planetNames[currentPlanet], group = enemyGroup, bulletGroup = bullets})
    bossHealthText.text = boss.boss.health
    bossHealthText.x = display.contentWidth - bossHealthText.width

    bossHp = boss.boss.health

    bossHpBg = display.newRect( 10, 50, 104, 25 )
    bossHpBg.anchorX = 0
    bossHpBg:setFillColor( 1, 1, 1, 0.5 )
    hud:insert(bossHpBg)

    bossHpFg = display.newRect( bossHpBg.x + 2, bossHpBg.y, 100, 18 )
    bossHpFg.anchorX = 0
    bossHpFg:setFillColor( 0.2, 0.85, 0.4 )
    hud:insert(bossHpFg)

    maxBossHp = boss.boss.health
    setBossHp(bossHp)
end

local function spawnPlanet()
    if(gameRunning) then
        onPlanet = true
        planet = getPlanet({planetName = planetNames[currentPlanet]})
        background1:insert(planet)

        initBossBattle(planetNames[currentPlanet])
    end
end

--timer.performWithDelay(45000, spawnPlanet)
--timer.performWithDelay(2000, spawnPlanet)
--timer.performWithDelay(30000, function() countDownToPlanet(planetNames[currentPlanet], 15) end)

timer.performWithDelay(10000, spawnPlanet)
countDownToPlanet(planetNames[currentPlanet], 10)

function onAllPlanetsDone()
    timer.performWithDelay(10000, function() initBossBattle(planetNames[math.random(9) + 1]) end)
    countDownToPlanet("Next Battle", 10)
end

local function onPlanetDone()
    planet:removeSelf()
    planet = nil
    onPlanet = false
    currentPlanet = currentPlanet + 1
    if(currentPlanet < 11) then
        timer.performWithDelay(10000, spawnPlanet)
        countDownToPlanet(planetNames[currentPlanet], 10)
    else
        onAllPlanetsDone()
    end
    if(inBossBattle) then
        onBossDead(boss.boss)
    end
end

local function movePlanet(planet, speed)
    planet.y = planet.y + speed
    if(planet.y > display.contentHeight) then
        onPlanetDone(planet)
    end
end

local function destroyScene()
    bottomOfScreen:removeEventListener("collision")
    Runtime:removeEventListener("collision", onCollision)

    if(inBossBattle) then
        boss.destroyImmediate()
    end

    physics.stop()
    composer.gotoScene("game_end", { effect = "crossFade", time = 333, params = {score = score, bossCount = bossCount} })
end

local function updateFrame()
    local backgroundSpeed = 2.5 --0.8
    if(inBossBattle) then backgroundSpeed = 0.5 end
    moveObjectsInGroup(spaceDusts, 75)
    --moveObjectsInGroup(background1, backgroundSpeed * 1.0)
    if(onPlanet) then movePlanet(planet, backgroundSpeed * 1.0) end
    moveObjectsInGroup(background2, backgroundSpeed * 0.7)
    moveObjectsInGroup(background3, backgroundSpeed * 0.4)
    moveObjectsInGroup(background4, backgroundSpeed * 0.1)

    setEnergy(energy + 0.4)

    setHp(hp)

    hp = hp + 0.05
    if(hp > 100) then hp = 100 end
    if(hp <= 0) then
        gameRunning = false
        animateExplode(ship.x, ship.y)
        ship:setLinearVelocity(0, 0)
        ship:removeEventListener("collision")
        if(enableAccelerometer) then
            Runtime:removeEventListener( "accelerometer", onTilt )
        end
        hpWarningOnScreen = false
        Runtime:removeEventListener("enterFrame", updateFrame)
        if(enableAccelerometer == false) then
            fireButton:removeEventListener("tap",fireBeamInvoker)
        else
            Runtime:removeEventListener("tap", fireBeamInvoker)
        end
        timer.performWithDelay(500, function() ship:removeSelf() end)
        timer.performWithDelay(1000, destroyScene)
    end
end

Runtime:addEventListener("enterFrame", updateFrame)
end

scene:addEventListener("create", scene)

return scene