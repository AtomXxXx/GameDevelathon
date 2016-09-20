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
    
  
    
   local background = display.newImageRect(sceneGroup, "images/background.png", 475, 713) -- display the background image object
        background.x = display.contentCenterX
        background.y = display.contentCenterY 

	local lo = display.newImage(sceneGroup, "images/go.png", 475, 713) -- display the background image object
        lo.x = display.contentCenterX
        lo.y = display.contentCenterY-100
    -- Create the widget
    local doneButton = widget.newButton({
        width = 100,
        height = 32,
		defaultFile = "images/menu.png", -- the image to be used in the normal state
        overFile = "images/menu.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX 
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )

end

function scene:show( event )
print("in game end show")
  local sceneGroup = self.view
  composer.removeHidden()
composer.removeScene("scene_game")
    params = event.params

    if event.phase == "did" then
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene