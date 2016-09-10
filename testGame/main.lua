-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local numLanes = 5
local laneWidth = display.contentWidth / numLanes
local laneMiddleX = laneWidth / 2
local currentLane = 0
local lanes = {}

-- CREATING ALL THE OBJECTS ON SCREEN

-- Object to which the left tap listener is attached. The player character will change lanes to left when they tap on this object
local leftTapObject = display.newRect(0,0, display.contentWidth / 2, display.contentHeight)
leftTapObject.anchorX = 0
leftTapObject.anchorY = 0
leftTapObject:setFillColor(1, 0, 0)
leftTapObject.alpha = 0.1
-- When tapped, the player character will change lanes to the right
local rightTapObject = display.newRect(display.contentWidth / 2,0, display.contentWidth / 2, display.contentHeight)
rightTapObject.anchorX = 0
rightTapObject.anchorY = 0
rightTapObject:setFillColor(0, 1, 0)
rightTapObject.alpha = 0.1

local background = display.newRect(0,0,display.contentWidth,display.contentHeight)
background.anchorX = 0
background.anchorY = 0
background:setFillColor(1,1,0)

-- Creating the lane rectangles depending on the number of lanes
for i=0, numLanes-2 do
    lanes[i] = display.newRect(laneWidth * (i+1) ,0, 5, display.contentHeight)
    --lanes[i].anchorX = 0
    lanes[i].anchorY = 0
    lanes[i]:setFillColor(0,0,1)
end

local ship = display.newImage("Ship.png")
ship.anchorY = 0 
ship:translate(0,display.contentHeight - 100)

ship.x = laneWidth * currentLane + laneMiddleX

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

-- PHYSICS

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

ballLane = 2
ballY = 30
ballVelocityY = 175
ballRadius = laneWidth / 4
ball = display.newCircle(ballLane * laneWidth + laneMiddleX, 30, ballRadius)
ball:setFillColor(0,0.8, 0.2)

physics.addBody(ball, "dynamic", {radius = ballRadius})
ball:setLinearVelocity(0, ballVelocityY)
