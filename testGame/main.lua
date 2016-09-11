-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

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

local numLanes = 7
local laneWidth = display.contentWidth / numLanes
local laneMiddleX = laneWidth / 2
local currentLane = 0
local lanes = {}
local score = 0

-- CREATING HEADS UP DISPLAY

local scoreText = display.newText({text = score, font = native.systemFontBold, fontSize = 34})
scoreText.anchorX = 0
scoreText.anchorY = 0
scoreText:setFillColor(0,0,0)
hud:insert(scoreText)

-- CREATING ALL THE OBJECTS ON SCREEN
local backgroundMusic = audio.loadStream( "back.mpeg" )
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

local background = display.newRect(0,0,display.contentWidth,display.contentHeight)
background.anchorX = 0
background.anchorY = 0
background:setFillColor(1,1,0)
group:insert(background)

-- Creating the lane rectangles depending on the number of lanes
for i=0, numLanes-2 do
    lanes[i] = display.newRect(laneWidth * (i+1) ,0, 5, display.contentHeight)
    --lanes[i].anchorX = 0
    lanes[i].anchorY = 0
    lanes[i]:setFillColor(0,0,1)
    group:insert(lanes[i])
end

local ship = display.newImage("Ship.png")
ship.anchorY = 0 
ship:translate(0,display.contentHeight - 100)

ship.x = laneWidth * currentLane + laneMiddleX
group:insert(ship)

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

local bottomOfScreen = display.newRect(0, display.contentHeight + 100, display.contentWidth, 50)
bottomOfScreen.anchorX = 0
bottomOfScreen.anchorY = 0
bottomOfScreen.name = "BottomOfScreen"
group:insert(bottomOfScreen)

-- PHYSICS

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local function onCollisionWithShip(self, event)
    if (event.phase == "began" and event.other.name == "GoodBall") then
        score = score + 1
        scoreText.text = score
        event.other:removeSelf()
    end
    print(score)
end

local function onCollisionAtBottomOfScreen(self, event)
    if(event.phase == "began" and self.name == "BottomOfScreen") then
        event.other:removeSelf()
    end
end

physics.addBody(ship, "static")
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
    ball.name = "GoodBall"
    ball:setFillColor(0,0.8, 0.2)
    group:insert(ball)

    physics.addBody(ball, "dynamic", {radius = ballRadius})
    ball:setLinearVelocity(0, ballVelocityY)
end

local tm = timer.performWithDelay(1500, createBall, 0)