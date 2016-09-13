local composer = require( "composer" )
local scene = composer.newScene()

container = display.newContainer(display.contentWidth, display.contentHeight)
container.x = display.contentWidth / 2
container.y = display.contentHeight / 2

group = display.newGroup()
group.x = -display.contentWidth / 2
group.y = -display.contentHeight / 2
container:insert(group)

hud = display.newGroup()
hud.x = -display.contentWidth / 2
hud.y = -display.contentHeight / 2
container:insert(hud)

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

-- CREATING ALL THE OBJECTS ON SCREEN
local backgroundMusic = audio.loadStream( "ingame.mp3" )
local backgroundMusic = audio.play( backgroundMusic, { channel=1, loops=-1} )

-- Object to which the left tap listener is attached. The player character will change lanes to left when they tap on this object
local leftTapObject = display.newRect(0,0, display.contentWidth / 2, display.contentHeight)
leftTapObject.anchorX = 0
leftTapObject.anchorY = 0
leftTapObject:setFillColor(1, 0, 0)
leftTapObject.alpha = 0.1
group:insert(leftTapObject)
-- When tapped, the player character will change lanes to the right
local rightTapObject = display.newRect(display.contentWidth / 2,0, display.contentWidth / 2, display.contentHeight)
rightTapObject.anchorX = 0
rightTapObject.anchorY = 0
rightTapObject:setFillColor(0, 1, 0)
rightTapObject.alpha = 0.1
group:insert(rightTapObject)

--local background = display.newRect(0,0,display.contentWidth,display.contentHeight)
local background = display.newImage("background.png")
background.anchorX = 0
background.anchorY = 0
--background:setFillColor(1,1,0)
group:insert(background)

-- Creating the lane rectangles depending on the number of lanes
for i=0, numLanes-2 do
    lanes[i] = display.newRect(laneWidth * (i+1) ,0, 5, display.contentHeight)
    --lanes[i].anchorX = 0
    lanes[i].anchorY = 0
    lanes[i]:setFillColor(0,0,1)
    group:insert(lanes[i])
end

--local ship = display.newRect(0, 0, laneWidth / 2, 50)
--ship:setFillColor(0, 0.8, 0.2)
local ship = display.newImage("images/ship.png")
ship:translate(0,display.contentHeight - 100)

--ship.x = laneWidth * currentLane + laneMiddleX
ship.x = display.contentWidth / 2
group:insert(ship)

local function onTilt(event)
    local speed = event.xRaw / 0.3

    if(speed > 1) then
        speed = 1
    elseif(speed < -1) then
        speed = -1
    end

    ship:setLinearVelocity( speed * 275, 0 )
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
Runtime:addEventListener( "accelerometer", onTilt )

local function leftTap( event )
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
end
leftTapObject:addEventListener( "tap", leftTap )
rightTapObject:addEventListener("tap", rightTap)

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
        if(event.other.name == "GoodBall") then
            score = score + 1
            event.other:removeSelf()
        elseif(event.other.name == "BadBall") then
            score = score - 5
            event.other:removeSelf()
        end
        scoreText.text = score
    end
end

local function onCollisionAtBottomOfScreen(self, event)
    if(event.phase == "began" and self.name == "BottomOfScreen") then
        if(event.other.name == "GoodBall") then
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

local function createBall()
    local ballLane = math.random(5) -1
    local ballVelocityY = 190
    local ballRadius = laneWidth / 4
    local ballY = -ballRadius
    local ball = display.newCircle(ballLane * laneWidth + laneMiddleX, ballY, ballRadius)
    if (math.random(100) < 75) then
        ball.name = "GoodBall"
        ball:setFillColor(0,0.8, 0.2)
    else
        ball.name = "BadBall"
        ball:setFillColor(0.8,0.2, 0.2)
    end
    group:insert(ball)

    physics.addBody(ball, "dynamic", {radius = ballRadius})
    ball:setLinearVelocity(0, ballVelocityY)
end

local tm = timer.performWithDelay(900, createBall, 0)

return scene