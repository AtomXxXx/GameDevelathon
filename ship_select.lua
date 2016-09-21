local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
    local json = require("json")
    local settings = {musicOn = true, soundOn = true, accelerometerOn = true, ship = "images/1.png"}


-- Function to handle button events
local function handleShip1Event( event )
    settings.ship = "images/1.png"
    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
		print("ship1")

    end
end

local function handleShip2Event( event )
    settings.ship = "images/2.png"

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
		print("1")
    end
end
local function handleShip3Event( event )

    settings.ship = "images/3.png"
    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
local function handleShip4Event( event )

    settings.ship = "images/4.png"
    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
local function handleShip5Event( event )

    settings.ship = "images/5.png"
    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
function scene:create( event )
    local sceneGroup = self.view
  
    params = event.params
    
    local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
    local file, errorstring = io.open(path, "r")
    local string = file:read("*a")
    settings = json.decode(string)
    file:close()
    file = nil
    
   local background = display.newImageRect(sceneGroup, "images/bship.png", 475, 713) -- display the background image object
        background.x = display.contentCenterX
        background.y = display.contentCenterY 

	local lo = display.newImage(sceneGroup, "images/l1.png", 475, 713) -- display the background image object
        lo.x = display.contentCenterX
        lo.y = display.contentCenterY-250
    -- Create the widget
    local ship1 = widget.newButton({
       
		defaultFile = "images/1.png", -- the image to be used in the normal state
        overFile = "images/1.png", -- the image to be used in the pressed state
        onEvent = handleShip1Event
    })
    ship1.x = display.contentCenterX -100
    ship1.y = display.contentHeight -440
    sceneGroup:insert( ship1 )

	 local ship2 = widget.newButton({
       
		defaultFile = "images/2.png", -- the image to be used in the normal state
        overFile = "images/2.png", -- the image to be used in the pressed state
        onEvent = handleShip2Event
    })
    ship2.x = display.contentCenterX +100
    ship2.y = display.contentHeight -440
    sceneGroup:insert( ship2 )

	 local ship3 = widget.newButton({
       
		defaultFile = "images/3.png", -- the image to be used in the normal state
        overFile = "images/3.png", -- the image to be used in the pressed state
        onEvent = handleShip3Event
    })
    ship3.x = display.contentCenterX 
    ship3.y = display.contentHeight -320
    sceneGroup:insert( ship3 )

	 local ship4 = widget.newButton({
       
		defaultFile = "images/4.png", -- the image to be used in the normal state
        overFile = "images/4.png", -- the image to be used in the pressed state
        onEvent = handleShip4Event
    })
    ship4.x = display.contentCenterX - 100
    ship4.y = display.contentHeight -200
    sceneGroup:insert( ship4 )

	 local ship5 = widget.newButton({
       
		defaultFile = "images/5.png", -- the image to be used in the normal state
        overFile = "images/5.png", -- the image to be used in the pressed state
        onEvent = handleShip5Event
    })
    ship5.x = display.contentCenterX + 100
    ship5.y = display.contentHeight -200
    sceneGroup:insert(ship5 )
end

function scene:show( event )
  local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    
    if event.phase == "will" then
        local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
        local string = json.encode(settings)
        local file, errorstring = io.open(path, "w")
        if (file == nil) then
            print(errorstring)
        end
        file:write(string)
        file:close()
        file = nil
    end
end

function scene:destroy(event)
local sceneGroup = self.view
    
    if event.phase == "will" then
        local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
        local string = json.encode(settings)
        local file, errorstring = io.open(path, "w")
        if (file == nil) then
            print(errorstring)
        end
        file:write(string)
        file:close()
        file = nil
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene