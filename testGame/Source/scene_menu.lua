local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local menuMusic
local settings

function scene:create( event )

    local sceneGroup = self.view
    settings = {musicOn = true, soundOn = true, accelerometerOn = true, ship = "images/1.png", score = 0, bossCount = 0}

    local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
    local file, errorstring = io.open(path, "r")
    if (not file) then
        settings = {musicOn = true, soundOn = true, accelerometerOn = true, ship = "images/1.png", score = 0, bossCount = 0}
        local string = json.encode(settings)
        local file, errorstring = io.open(path, "w")
        if (file == nil) then
            print(errorstring)
        end
        file:write(string)
        file:close()
        file = nil
    else
        local string = file:read("*a")
        settings = json.decode(string)
        file:close()
        file = nil
    end
    if(settings.musicOn == false) then
        audio.stop(1)
    end
    local background = display.newImageRect(sceneGroup, "images/background.png", 475, 713) -- display the background image object
        background.x = display.contentCenterX
        background.y = display.contentCenterY  
    
    --[[if(settings.musicOn) then
        local backgroundMusic = audio.loadStream( "menumusic.mp3" )
        menuMusic = audio.play( backgroundMusic, { channel=1, loops=-1} )
    end]]

    local logo = display.newImage("images/logo.png") -- create the logo image object
        logo.x = display.contentCenterX
        logo.y = 75
        logo:scale(0.5, 0.5)
    sceneGroup:insert(logo)

	
    
    
    local function handleSettingsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("game_settings", { effect = "crossFade", time = 333 })
    end
end

local function handlecreditsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_credits", { effect = "crossFade", time = 333 })
    end
end    
    

local function handleChooseShipButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("ship_select", { effect = "crossFade", time = 333 })
    end
end
   
    local function handleButtonEvent( event ) -- create a function that responds to the button press of start playing
        if ( "ended" == event.phase ) then -- when the player lifts his or her finger from the button, that is known as the ended phase
            composer.gotoScene("scene_game", "slideLeft") -- move the player to the game scene
        end
    end
	local settingsButton = widget.newButton({
        width = 210,
        height = 90,
		defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
		label = "Settings", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 25, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } }, -- the color of the label and the color when pressed
        onEvent = handleSettingsButtonEvent
    })
    settingsButton.x = display.contentCenterX
    settingsButton.y = display.contentCenterY +50
    sceneGroup:insert( settingsButton )


	local creditsButton = widget.newButton({
        width = 210,
        height = 90,
		defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
		label = "Credits", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 25, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } }, -- the color of the label and the color when pressed
        onEvent = handlecreditsButtonEvent
    })
    creditsButton.x = display.contentCenterX
    creditsButton.y = display.contentCenterY +250
    sceneGroup:insert( creditsButton )



    local btn_startPlaying = widget.newButton {
        width = 220, -- this defines the width of the button
        height = 100, -- this defines the height of the button 
        defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
        label = "Play", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 25, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } }, -- the color of the label and the color when pressed
        onEvent = handleButtonEvent -- the name of the function to be called when the button is pressed
    }
    btn_startPlaying.x = display.contentCenterX -- position the button on the center of x axis
    btn_startPlaying.y = display.contentCenterY-50 -- position the button on the center of y axis
    sceneGroup:insert(btn_startPlaying) -- insert button into sceneGroup for scene management

	local chooseShipButton = widget.newButton({
        width = 210,
        height = 90,
		defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
		label = "Select Player Ship", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 24, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } }, -- the color of the label and the color when pressed
        onEvent = handleChooseShipButtonEvent
    })
    chooseShipButton.x = display.contentCenterX
    chooseShipButton.y = display.contentCenterY +150
    sceneGroup:insert( chooseShipButton )

end



-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    if(settings.musicOn == false) then
        audio.stop(1)
    end
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        local prevScene = composer.getSceneName( "previous" ) -- get the previous scene name, i.e. scene_game
        if(prevScene) then -- if the prevScene exists, then do something. This is only true when the player has went to the game scene
            composer.removeScene(prevScene) -- remove the previous scene so the player can play again
        end
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene