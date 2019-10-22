
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local tablaDesechos = {}

-- capas que se incluyen en el senceGroup
local backGroup
local mainGroup
local uiGroup


-- generador de desechos
local function crearDeshechos(x, y, velocidad, img, inclinacion)
	local nuevoDeshecho = display.newImageRect(mainGroup, img, 50, 70)
	table.insert( tablaDesechos, nuevoDeshecho )
	physics.addBody( nuevoDeshecho, "dynamic", { radius=40, bounce=0.8 } ) -- bounce=rebote
	nuevoDeshecho.myName = "deshecho"

	-- Posicion inical y velocidad de desplazamiento
	nuevoDeshecho.x = x
	nuevoDeshecho.y = y
	nuevoDeshecho:setLinearVelocity( -velocidad, velocidad )
	-- rotacion
	nuevoDeshecho:applyTorque( 0.2 )

	nuevoDeshecho.alpha = 0
	transition.to( nuevoDeshecho, {time=2000, alpha = 1})
end

-- Tirar Red
local function lanzarRed()
	--local red = display.newImageRect( mainGroup, "red.png", 14, 40 )
	--physics.addBody( red, "dynamic", { isSensor=true } )
	red.isBullet = true
	red.myName = "red"

	red.x = satelite.x
	red.y = satelite.y
	red:toBack()

	--transition.to( red, { y=-40, time=500,
	--	onComplete = function() display.remove( red ) end
	--} )
end

-- Fucion de Colision con Nave y Red

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()  -- Temporarily pause the physics engine

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	-- Cargar el bakground
	local background = display.newImageRect( backGroup, "space.png", 340, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Carga Planeta Tierra
	local tierra = display.newImageRect(mainGroup, "tierra.png", 250,250)
	tierra.x = display.contentWidth--display.contentCenterX +200
	tierra.y = display.contentHeight+50
	physics.addBody( tierra, "static" )
	tierra.myName = "tierra"
	tierra.alpha = 0
	transition.to( tierra, {time=2000, alpha = 1})

	-- Cargar satelite
local satelite = display.newImageRect( mainGroup, "satelite2.png", 81, 50 )
	satelite.x = display.contentCenterX-50
	satelite.y = display.contentHeight
	physics.addBody( satelite, { radius=30, isSensor=true } )
	satelite.myName = "satelite"
	satelite.alpha = 0
	transition.to( satelite, {time=2000, alpha = 1})

	local red = display.newImageRect( mainGroup, "red.png", 81, 50 )
	red.x = display.contentCenterX
	red.y = display.contentCenterY+200
	physics.addBody( red, { radius=30, isSensor=true } )
	red.myName = "red"
	red.alpha = 0
	transition.to( red, {time=2000, alpha = 1})

	crearDeshechos(display.contentCenterX-50, 100, 5, "basura1.png")
	crearDeshechos(display.contentCenterX, 50, 5, "basura2.png")
	crearDeshechos(display.contentCenterX+50, 150, 5, "basura3.png")

	--satelite:addEventListerner("tap", lanzarRed())
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
