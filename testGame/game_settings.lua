local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local myData = require( "mydata" )

-- Function to handle button events
local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local background = display.newRect( 0, 0, 600, 400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
   widget.setTheme( "widget_theme_android_holo_dark" ) 
   local soundLabel = display.newText("Sound Effects", 100, 32, native.systemFont, 18 )
    soundLabel.x = display.contentCenterX - 75
    soundLabel.y = 130
    soundLabel:setFillColor( 0 )
    sceneGroup:insert( soundLabel )
	
    local soundOnOffSwitch = widget.newSwitch({
        width = 210,
        height = 90,
		defaultFile = "images/on.png", -- the image to be used in the normal state
        overFile = "images/off.png", -- the image to be used in the pressed state
		initialSwitchState = myData.settings.soundOn,
        onPress = onSoundSwitchPress
    })
    soundOnOffSwitch.x = display.contentCenterX + 100
    soundOnOffSwitch.y = soundLabel.y
    sceneGroup:insert( soundOnOffSwitch )

    local musicLabel = display.newText("Music", 100, 32, native.systemFont, 18 )
    musicLabel.x = display.contentCenterX - 75
    musicLabel.y = 180
    musicLabel:setFillColor( 0 )
    sceneGroup:insert( musicLabel )

    local musicOnOffSwitch = widget.newSwitch({
        width = 210,
        height = 90,
		defaultFile = "images/on.png", -- the image to be used in the normal state
        overFile = "images/off.png", -- the image to be used in the pressed state
		initialSwitchState = myData.settings.musicOn,
        onPress = onMusicSwitchPress
    })
    musicOnOffSwitch.x = display.contentCenterX + 100
    musicOnOffSwitch.y = musicLabel.y
    sceneGroup:insert( musicOnOffSwitch )


	local accelLabel = display.newText("Accelerometer?", 100, 32, native.systemFont, 18 )
    accelLabel.x = display.contentCenterX - 75
    accelLabel.y = 230
    accelLabel:setFillColor( 0 )
    sceneGroup:insert( accelLabel )

	local accelOnOffSwitch = widget.newSwitch({
        width = 210,
        height = 90,
		defaultFile = "images/on.png", -- the image to be used in the normal state
        overFile = "images/off.png", -- the image to be used in the pressed state
		initialSwitchState = myData.settings.accelerometerOn,
        onPress = onAccelSwitchPress
    })
    accelOnOffSwitch.x = display.contentCenterX + 100
    accelOnOffSwitch.y = accelLabel.y
    sceneGroup:insert( accelOnOffSwitch )

    -- Create the widget
    local doneButton = widget.newButton({
        width = 100,
        height = 32,
		defaultFile = "images/done.png", -- the image to be used in the normal state
        overFile = "images/done.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX 
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene