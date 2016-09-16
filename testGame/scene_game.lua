local composer = require( "composer" )
local json = require("json")
local scene = composer.newScene()

local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
local file, errorstring = io.open(path, "r")
local string = file:read("*a")
local settings = json.decode(string)
file:close()
file = nil




--ObjectSheet set up
--[[local sheetOptions =
{
    frames =
    {
        {   -- 1) 10th beam i.e last one..
            x = 72,
            y = 120,
            width = 15,
            height = 16
        },
        {   -- 2) 9th beam.. left one of the last 2
            x = 51,
            y = 81,
            width =15,
            height =16
        },
		{   -- 3) 8th beam.. right one of the last 2
            x = 97,
            y = 78,
            width =15,
            height =16
        },
        {   -- 4) 7th beam.. left most one of the last 3
            x = 24,
            y =39,
            width =15,
            height =16
        },
        {   -- 5) 6th beam.. middle one of the last 3
            x = 70,
            y = 40,
            width =15,
            height =16
        },
		{   -- 6) 5th beam.. right one of the last 3
            x = 116,
            y = 39,
            width =15,
            height =16
        },
        {   -- 7) 4th beam.. left most one of the last 4
            x = 2,
            y =2,
            width =15,
            height =16
        },
        {   -- 8) 3rd beam.. next to right one of the last 4
            x = 43,
            y = 3,
            width =15,
            height =16
        },
        {   -- 9) 2nd beam.. 3rd one of the last 4  i.e next to rightmost one
            x = 93,
            y = 2,
            width =15,
            height =16
        },
		{   -- 10) 1st beam.. rightmost one of the last 4
            x = 135,
            y = 1,
            width =15,
            height =16
        },
    }
}
local objectSheet = graphics.newImageSheet( "images/bb.png", sheetOptions )]]

 



local enableAccelerometer = settings.accelerometerOn
local enableMusic = settings.musicOn

container = display.newContainer(display.contentWidth, display.contentHeight)
container.x = display.contentWidth / 2
container.y = display.contentHeight / 2

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

local planetNames = {"Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Neptune", "Uranus", "Pluto"}
local currentPlanet = 1
local onPlanet = true
local shipMaxSpeed = 275
local numLanes = 5
local laneWidth = display.contentWidth / numLanes
local laneMiddleX = laneWidth / 2
local currentLane = 2
local lanes = {}
local score = 0

-- CREATING HEADS UP DISPLAY

local scoreText = display.newText({text = score, font = native.systemFontBold, fontSize = 34})
scoreText.anchorX = 0
scoreText.anchorY = 0
scoreText:setFillColor(1,1,1)
hud:insert(scoreText)

local countDownText = display.newText({text = "", font = native.systemFontBold, fontSize = 30})
countDownText:setFillColor(1,1,1)
countDownText.x = display.contentWidth / 2
countDownText.y = display.contentHeight * 0.05

local fireButton = display.newImage("images/fire.png")
fireButton.alpha = 0.3
fireButton.x = display.contentWidth - fireButton.width
fireButton.y = display.contentCenterY +100
hud:insert(fireButton)

-- CREATING ALL THE OBJECTS ON SCREEN
if (enableMusic) then
    local backgroundMusic = audio.loadStream( "ingame.mp3" )
    local backgroundMusic = audio.play( backgroundMusic, { channel=1, loops=-1} )
end

local starbg = display.newImage("images/starsbackground.png")
starbg:scale(1.0, 1.2)
starbg.anchorX = 0
starbg.anchorY = 0
background5:insert(starbg)

--[[local function getPlanet()
    local planet = display.newImage("images/Mercury.png")
    planet.anchorX = 0
    planet.anchorY = 0
    planet.x = -planet.width / 6
    planet.y = -planet.height / 3
    planet.aplha = 0.8
    planet:scale(0.4, 0.4)
    return planet
end]]
local getPlanet = require("planets").getPlanet
local planet = getPlanet({planetName = "Sun"})
background1:insert(planet)

-- Object to which the left tap listener is attached. The player character will change lanes to left when they tap on this object
local leftTapObject = display.newRect(0,0, display.contentWidth / 2, display.contentHeight)
leftTapObject.anchorX = 0
leftTapObject.anchorY = 0
leftTapObject:setFillColor(0, 0, 0)
leftTapObject.alpha = 0
leftTapObject.isHitTestable = true
leftTapObject.name = "LeftTapObject"
group:insert(leftTapObject)
-- When tapped, the player character will change lanes to the right
local rightTapObject = display.newRect(display.contentWidth / 2,0, display.contentWidth / 2, display.contentHeight)
rightTapObject.anchorX = 0
rightTapObject.anchorY = 0
rightTapObject:setFillColor(0, 0, 0)
rightTapObject.alpha = 0
rightTapObject.isHitTestable = true
rightTapObject.name = "RightTapObject"
group:insert(rightTapObject)

--local background = display.newRect(0,0,display.contentWidth,display.contentHeight)
--[[local background = display.newImage("background.png")
background.anchorX = 0
background.anchorY = 0
--background:setFillColor(1,1,0)
group:insert(background)]]

-- Creating the lane rectangles depending on the number of lanes
--[[for i=0, numLanes-2 do
    lanes[i] = display.newRect(laneWidth * (i+1) ,0, 5, display.contentHeight)
    --lanes[i].anchorX = 0
    lanes[i].anchorY = 0
    lanes[i]:setFillColor(0,0,1)
    group:insert(lanes[i])
end]]

--local ship = display.newRect(0, 0, laneWidth / 2, 50)
--ship:setFillColor(0, 0.8, 0.2)
local ship = display.newImage("images/ship.png")
ship:translate(0,display.contentHeight - 100)

--ship.x = laneWidth * currentLane + laneMiddleX
ship.x = display.contentWidth / 2
group:insert(ship)

local function boundShipToScreen(speed)
    if (ship.x < ship.width / 2) then
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

--[[local function leftTap( event )
    currentLane = currentLane - 1
    if(currentLane < 0) then
        currentLane = 0
    end
    ship.x = laneWidth * currentLane + laneMiddleX
    return true
end
local function rightTap( event )
    currentLane = currentLane + 1
    if(currentLane >= numLanes) then
        currentLane = numLanes - 1
    end
    ship.x = laneWidth * currentLane + laneMiddleX
    return true
end]]
local function moveShipLeft()
    if (holding) then
        ship:setLinearVelocity( -shipMaxSpeed, 0 )
        boundShipToScreen(-shipMaxSpeed)
    end
end
local function moveShipRight()
    if(holding) then
        ship:setLinearVelocity( shipMaxSpeed, 0 )
        boundShipToScreen(shipMaxSpeed)
    end
end

local function touchHandler( event )
    if (event.phase == "began") then

        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true

        if (event.target.name == "LeftTapObject") then
            Runtime:addEventListener( "enterFrame", moveShipLeft )
        elseif(event.target.name == "RightTapObject") then
            Runtime:addEventListener( "enterFrame", moveShipRight )
        end

        holding = true

    elseif (event.target.isFocus) then
        if (event.phase == "moved") then
        elseif (event.phase == "ended" or event.phase == "cancelled") then
            holding = false
            event.target.isFocus = false

            if (event.target.name == "LeftTapObject") then
                Runtime:removeEventListener( "enterFrame", moveShipLeft )
                ship:setLinearVelocity(0, 0)
            elseif(event.target.name == "RightTapObject") then
                Runtime:removeEventListener( "enterFrame", moveShipRight )
                ship:setLinearVelocity(0, 0)
            end

            display.getCurrentStage():setFocus( nil )
        end
    end
end
if ( enableAccelerometer == false) then
    --leftTapObject:addEventListener( "tap", leftTap )
    --rightTapObject:addEventListener("tap", rightTap)
    leftTapObject:addEventListener("touch", touchHandler)
    rightTapObject:addEventListener("touch", touchHandler)
end

local bottomOfScreen = display.newRect(0, display.contentHeight + laneWidth / 2, display.contentWidth, 50)
bottomOfScreen.anchorX = 0
bottomOfScreen.anchorY = 0
bottomOfScreen.name = "BottomOfScreen"
group:insert(bottomOfScreen)

-- PHYSICS

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local function onCollisionWithShip(self, event)
    if (event.phase == "began") then
        if(event.other.name == "GoodShip") then
            score = score + 1
            event.other:removeSelf()
            scoreText.text = score
        elseif(event.other.name == "BadShip") then
            score = score - 5
            event.other:removeSelf()
            scoreText.text = score
        end
    end
end

local function onCollision(event)
    if(event.phase == "began") then
        obj1 = event.object1
        obj2 = event.object2

        if ((obj1.name == "PlayerBeam" and obj2.name == "BadShip") or (obj2.name == "PlayerBeam" and obj1 == "BadShip")) then
            obj1:removeSelf()
            obj2:removeSelf()
            score = score + 10
            scoreText.text = score
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

physics.addBody(ship, "kinematic")
ship.collision = onCollisionWithShip
ship:addEventListener("collision")

physics.addBody(bottomOfScreen, "static")
bottomOfScreen.collision = onCollisionAtBottomOfScreen
bottomOfScreen:addEventListener("collision")

local function createEnemyShip()
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
        ship.name = "BadShip"
        enemyGroup:insert(ship)
    end
    ship.x = shipX

    physics.addBody(ship, "dynamic", {radius = shipRadius})
    ship:setLinearVelocity(0, shipVelocityY)
end

local function fireBeam(ship, y1, time1, beam, beamOrigin)
    local newBeam = display.newImage(beam)
    physics.addBody(newBeam, "dynamic", {isSensor = true})
    newBeam.name = beamOrigin
    newBeam.x = ship.x
    newBeam.y = ship.y
    newBeam:toBack()
    group:insert(newBeam)

    transition.to(newBeam, {y = y1, time = time1, onComplete = function() display.remove(newBeam) end})
end

fireButton:addEventListener("tap",function() fireBeam(ship, -100, 500, "images/beam.png", "PlayerBeam") end)

local tm = timer.performWithDelay(1500, createEnemyShip, 0)

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
    local star = getRandomStar(scale)
    star.x = math.random(display.contentWidth)
    star.y = -star.height / 2
    group:insert(star)
    timer.performWithDelay(math.random(5000), function() createStars(scale, group) end)
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

    local spaceDust = display.newRect(math.random(display.contentWidth), -20, 1.2, display.contentHeight / 6)
    spaceDust.anchorY = 0
    spaceDust.alpha = 0.3
    spaceDusts:insert(spaceDust)

    timer.performWithDelay(math.random(150), createSpaceDust)
end


createSpaceDust()

local function moveObjectsInGroup(group, speed)
    if(group.numChildren ~= 0) then
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
    countDownText.text = name .. ": " .. timeSec
    if(timeSec == 0) then
        countDownText.text = ""
    else
        timer.performWithDelay(1000, function() countDownToPlanet(name, timeSec - 1) end)
    end
end

local function spawnPlanet()
    onPlanet = true
    planet = getPlanet({planetName = planetNames[currentPlanet]})
    background1:insert(planet)
end

local function onPlanetDone()
    planet:removeSelf()
    planet = nil
    onPlanet = false
    currentPlanet = currentPlanet + 1
    if(currentPlanet < 11) then
        timer.performWithDelay(10000, spawnPlanet)
        countDownToPlanet(planetNames[currentPlanet], 10)
    end
end

local function movePlanet(planet, speed)
    planet.y = planet.y + speed
    if(planet.y > display.contentHeight) then
        onPlanetDone(planet)
    end
end

local function updateFrame()
    local backgroundSpeed = 0.8
    moveObjectsInGroup(spaceDusts, 75)
    --moveObjectsInGroup(background1, backgroundSpeed * 1.0)
    if(onPlanet) then movePlanet(planet, backgroundSpeed * 1.0) end
    moveObjectsInGroup(background2, backgroundSpeed * 0.7)
    moveObjectsInGroup(background3, backgroundSpeed * 0.4)
    moveObjectsInGroup(background4, backgroundSpeed * 0.1)
end

Runtime:addEventListener("enterFrame", updateFrame)

return scene