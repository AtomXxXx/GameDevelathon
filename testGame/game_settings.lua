local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

-- Handle press events for the switches
local function onSoundSwitchPress( event )
    local switch = event.target

    if switch.isOn then
        myData.settings.soundOn = true
    else
        myData.settings.soundOn = false
    end
    --utility.saveTable(myData.settings, "settings.json")
end

local function onMusicSwitchPress( event )
    local switch = event.target

    if switch.isOn then
        myData.settings.musicOn = true
    else
        myData.settings.musicOn = false
    end
    --utility.saveTable(myData.settings, "settings.json")
end
-- Function to handle button events
local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scene_menu", { effect = "crossFade", time = 333 })
    end
end
function scene:create( event )
    local sceneGroup = self.view

  --  params = event.params
        

