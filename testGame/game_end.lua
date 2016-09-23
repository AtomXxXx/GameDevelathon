local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local settings = {score = 0, bossCount = 0}

-- Function to handle button events
local function handleButtonEvent( event )

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
    
    local highScore = settings.score
    local highBossCount = settings.bossCount
    local score = params.score
    local bossCount = params.bossCount

   local background = display.newImageRect(sceneGroup, "images/background.png", 475, 713) -- display the background image object
        background.x = display.contentCenterX
        background.y = display.contentCenterY 

	local lo = display.newImage(sceneGroup, "images/go.png", 475, 713) -- display the background image object
        lo.x = display.contentCenterX
        lo.y = display.contentCenterY-200
    -- Create the widget
    local doneButton = widget.newButton({
        width = 230,
        height = 50,
		defaultFile = "images/menu.png", -- the image to be used in the normal state
        overFile = "images/menu.png", -- the image to be used in the pressed state
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX 
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )

    local scoreText = display.newText({text = "Score: " .. score, font = native.systemFontBold, fontSize = 25})
    local highScoreText = display.newText({text = "High Score: ", font = native.systemFontBold, fontSize = 25})
    local bossCountText = display.newText({text = "Battles Won: " .. bossCount, font = native.systemFontBold, fontSize = 25})
    local highBossCountText = display.newText({text = "Highest Battles Won: ", font = native.systemFontBold, fontSize = 25})

    scoreText.x = display.contentCenterX
    highScoreText.x = display.contentCenterX
    bossCountText.x = display.contentCenterX
    highBossCountText.x = display.contentCenterX

    scoreText.y = display.contentCenterY - 100
    highScoreText.y = display.contentCenterY - 50
    bossCountText.y = display.contentCenterY + 50
    highBossCountText.y = display.contentCenterY + 100

    sceneGroup:insert( scoreText )
    sceneGroup:insert( highScoreText )
    sceneGroup:insert( bossCountText )
    sceneGroup:insert( highBossCountText )

    if(highScore < score) then
        highScore = score
    end
    if(highBossCount < bossCount) then
        highBossCount = bossCount
    end

    highScoreText.text = highScoreText.text .. highScore
    highBossCountText.text = highBossCountText.text .. highBossCount

    settings.score = highScore
    settings.bossCount = highBossCount
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
function scene:hide( event )
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

function scene:destroy( event )
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
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene