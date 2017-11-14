local func = {}

local planets = {}
function func.getPlanet(params)
    local planetName = params.planetName
    print(planetName)
    if(planetName == "Sun") then
        local planet = display.newImage("images/Sun1.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = -planet.width / 1.2
        planet.y = -planet.height * 1.4
        planet.alpha = 0.9
        planet:scale(1.4, 1.4)
        return planet
    elseif(planetName == "Mercury") then
        local planet = display.newImage("images/Mercury.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = -planet.width / 6
        planet.y = -planet.height * 0.4
        planet.alpha = 0.95
        planet:scale(0.4, 0.4)
        return planet
    elseif(planetName == "Venus") then
        local planet = display.newImage("images/Venus.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth - 200
        planet.y = -planet.height * 0.3
        planet.alpha = 0.95
        planet:scale(0.3, 0.3)
        return planet
    elseif(planetName == "Earth") then
        local planet = display.newImage("images/Earth.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = -20
        planet.y = -planet.height * 0.8
        planet.alpha = 0.95
        planet:scale(0.8, 0.8)
        return planet
    elseif(planetName == "Mars") then
        local planet = display.newImage("images/Mars.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth - 200
        planet.y = -planet.height * 1.3
        planet.alpha = 0.95
        planet:scale(1.3, 1.3)
        return planet
    elseif(planetName == "Jupiter") then
        local planet = display.newImage("images/Jupiter.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth / 2
        planet.y = -planet.height * 0.5
        planet.alpha = 1
        planet:scale(0.5, 0.5)
        return planet
    elseif(planetName == "Saturn") then
        local planet = display.newImage("images/Saturn.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = -320
        planet.y = -planet.height * 0.7
        planet.alpha = 0.95
        planet:scale(0.7, 0.7)
        return planet
    elseif(planetName == "Uranus") then
        local planet = display.newImage("images/Uranus.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth / 2 - planet.width / 5
        planet.y = -planet.height * 1.3
        planet.alpha = 0.95
        planet:scale(1.3, 1.3)
        return planet
    elseif(planetName == "Neptune") then
        local planet = display.newImage("images/Neptune.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth / 2 - planet.width / 5
        planet.y = -planet.height * 0.7
        planet.alpha = 0.95
        planet:scale(0.7, 0.7)
        return planet
    elseif(planetName == "Pluto") then
        local planet = display.newImage("images/Pluto.png")
        planet.anchorX = 0
        planet.anchorY = 0
        planet.x = display.contentWidth - planet.width / 4
        planet.y = -planet.height * 0.35
        planet.alpha = 0.95
        planet:scale(0.35, 0.35)
        return planet
    end

    return -1
end

return func