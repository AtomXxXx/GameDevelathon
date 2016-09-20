local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )


-- Function to handle button events
local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
function scene:create( event )
  local sceneGroup = self.view
  
  params = event.params
    
  
    
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
        onEvent = handleButtonEvent
    })
    ship1.x = display.contentCenterX -100
    ship1.y = display.contentHeight -440
    sceneGroup:insert( ship1 )

	 local ship2 = widget.newButton({
       
		defaultFile = "images/2.png", -- the image to be used in the normal state
        overFile = "images/2.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    ship2.x = display.contentCenterX +100
    ship2.y = display.contentHeight -440
    sceneGroup:insert( ship2 )

	 local ship3 = widget.newButton({
       
		defaultFile = "images/3.png", -- the image to be used in the normal state
        overFile = "images/3.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    ship3.x = display.contentCenterX 
    ship3.y = display.contentHeight -320
    sceneGroup:insert( ship3 )

	 local ship4 = widget.newButton({
       
		defaultFile = "images/4.png", -- the image to be used in the normal state
        overFile = "images/4.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    ship4.x = display.contentCenterX - 100
    ship4.y = display.contentHeight -200
    sceneGroup:insert( ship4 )

	 local ship5 = widget.newButton({
       
		defaultFile = "images/5.png", -- the image to be used in the normal state
        overFile = "images/5.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
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


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene