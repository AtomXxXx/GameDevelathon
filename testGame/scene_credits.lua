local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )


--local settings = {musicOn = true, soundOn = true, accelerometerOn = true}

-- Function to handle button events
local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
    
    
    local background = display.newRect( 0, 0, 600, 400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
   widget.setTheme( "widget_theme_android_holo_dark" ) 
   

    local scrollView = widget.newScrollView({width = display.contentWidth, height = display.contentHeight})
    sceneGroup:insert(scrollView)
    --scrollView.anchorX = 0
    --scrollView.anchorY = 0

    local deepak = "Deepak J"
    local akshay = "Akshay M Sharma"
    local ashwin = "Ashwin Vasista"
    local text = "Deepak J\nAkshay M Sharma\nAshwin Vasista"

    local header = display.newText({text = "Code", font = native.systemFontBold, fontSize = 25})
    header.x = display.contentWidth / 2
    header.y = display.contentHeight / 2 - 250
    header:setFillColor(0.5,0.2,0.8)
    scrollView:insert(header)

    local names1 = display.newText({text =akshay .. "\n        " .. deepak, font = native.systemFontBold, fontSize = 25})
    names1.x = display.contentWidth / 2
    names1.y = header.y + 50
    names1:setFillColor(0,0,0)
    scrollView:insert(names1)

    local header2 = display.newText({text = "Art and Music", font = native.systemFontBold, fontSize = 25})
    header2.x = display.contentWidth / 2
    header2.y = names1.y + 80
    header2:setFillColor(0.5,0.2,0.8)
    scrollView:insert(header2)

    local names2 = display.newText({text = ashwin .. "", font = native.systemFontBold, fontSize = 25})
    names2.x = display.contentWidth / 2
    names2.y = header2.y + 30
    names2:setFillColor(0,0,0)
    scrollView:insert(names2)

    local header3 = display.newText({text = "Special Thanks", font = native.systemFontBold, fontSize = 25})
    header3.x = display.contentWidth / 2
    header3.y = names2.y + 75
    header3:setFillColor(0.5,0.2,0.8)
    scrollView:insert(header3)

    local names3 = display.newText({text = " Jyothy Institute\n Of Technology", font = native.systemFontBold, fontSize = 25})
    names3.x = display.contentWidth / 2
    names3.y = header3.y + 50
    names3:setFillColor(0,0,0)
    scrollView:insert(names3)

    local corona = display.newImage("images/corona.png")
    corona.x = display.contentWidth / 2
    corona.y = names3.y + corona.height / 2 - 175 
    corona:scale(0.4, 0.4)
    scrollView:insert(corona)

    local space = display.newText({text = "    ", font = native.systemFontBold, fontSize = 25})
    space.x = display.contentWidth / 2
    space.y = corona.y + 200
    space:setFillColor(0,0,0)
    scrollView:insert(space)

    -- Create the widget
    local doneButton = widget.newButton({
        width = 104,
        height = 50,
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

--[[function scene:hide( event )
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
end]]

--[[function scene:destroy( event )
    local sceneGroup = self.view
    local path = system.pathForFile("CoronaGameSettings.txt", system.DocumentsDirectory)
    local string = json.encode(settings)
    local file, errorstring = io.open(path, "w")
    if (file == nil) then
        print(errorstring)
    end
    file:write(string)
    file:close()
    file = nil
end]]

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene