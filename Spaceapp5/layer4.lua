
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

local function orbita(x1, y1)
	-- http://calculo.cc/temas/temas_geometria_analitica/curvas_superf/teoria/para_conicas.html
	Xcentro = display.contentCenterX -- x de la tierra
	Ycentro = display.contentCenterY -- y de la tierra
	a = 100.0 	-- Eje Mayor
	b = 50.0 	-- Eje Menor
	deg = 40 	-- Grados respecto al eje x de la tierra
	rads = deg * (math.pi/180)	-- transformacion radianes
	x2 = Xcentro + a * math.cos(rads)
	y2 = Ycentro + b * math.sin(rads)
	return x2, y2
end

-- generador de desechos
local function crearDeshechos(x, y, velocidad, img, inclinacion)
	local nuevoDeshecho = display.newImageRect(mainGroup, img, 50, 70)
	table.insert( tablaDesechos, nuevoDeshecho )
	physics.addBody( nuevoDeshecho, "dynamic", { radius=60, bounce=0.8 } ) -- bounce=rebote
	nuevoDeshecho.myName = "deshecho"

	-- Posicion inical y velocidad de desplazamiento
	nuevoDeshecho.x = x
	nuevoDeshecho.y = y

	-- Generar trayectoria eliptica
	--x2, y2 = orbita(nuevoDeshecho.x, nuevoDeshecho.y)
	--nuevoDeshecho.x = nuevoDeshecho.x+x2
	--nuevoDeshecho.y = nuevoDeshecho.y+y2
	--

	nuevoDeshecho:setLinearVelocity( -velocidad, velocidad )
	-- rotacion
	nuevoDeshecho:applyTorque( 0.2 )
end

-- Movimiento de Satelite
local function moverSatelite(event)
	local satelite = event.target
	local fase = event.phase
	if ( "began" == fase ) then
		display.currentStage:setFocus(satelite)
		satelite.touchOffsetX = event.x - satelite.x
	elseif("moved" == fase) then
		satelite.x = event.x - satelite.touchOffsetX
	elseif ( "ended" == fase or "cancelled" == fase ) then
		-- Release touch focus on the ship
		display.currentStage:setFocus( nil )
	end
	return true
end

-- Tirar Red
local function lanzarRed()
	local red = display.newImageRect( mainGroup, "red.png", 81, 50 )
	physics.addBody( red, "dynamic", { radius=80, isSensor=true } )
	red.isBullet = true
	red.myName = "red"

	--red.x = display.contentCenterX -- display.contentCenterX
	--red.y = display.contentCenterY+200 -- display.contentCenterY-- 
	red.x = satelite.x
	red.y = satelite.y
	--red:toBack()

	transition.to( red, { y=-40, time=700,
		xScale=1.8, yScale=1.8,
		onComplete = function() display.remove( red ) end
	} )
end

local function endGame()

	--composer.setVariable( "finalScore", score )
	composer.gotoScene( "layer3", { time=800, effect="crossFade" } )
end
-- Fucion de Colision con Red y Desechos

local function onCollision( event )

	if ( event.phase == "began" ) then
		local obj1 = event.object1
		local obj2 = event.object2
		
		if ( ( obj1.myName == "red" and obj2.myName == "deshecho" ) or
			 ( obj1.myName == "deshecho" and obj2.myName == "red" ) )
		then
			display.remove( obj1 )
			display.remove( obj2 )
			for i = #tablaDesechos, 1, -1 do
				if ( tablaDesechos[i] == obj1 or tablaDesechos[i] == obj2 ) then
					table.remove( tablaDesechos, i )
					break
				end
			end
			if(#tablaDesechos <= 0)then
				timer.performWithDelay( 1000, endGame )			end
		end
	end
end


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
	local background = display.newImageRect( backGroup, "background.png", 340, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Carga Planeta tierra
	local tierra = display.newImageRect(mainGroup, "tierra.png", 250,250)
	tierra.x = display.contentWidth--display.contentCenterX +200
	tierra.y = display.contentHeight+50
	physics.addBody( tierra, "static" )
	tierra.myName = "tierra"

	-- Cargar satelite
	satelite = display.newImageRect( mainGroup, "satelite2.png", 81, 50 )
	satelite.x = display.contentCenterX-50
	satelite.y = display.contentHeight
	physics.addBody( satelite, { radius=30, isSensor=true } )
	satelite.myName = "satelite"

	vel = 5
	incli = 40
	crearDeshechos(display.contentWidth-200, 20, 5.1, "basura1.png", incli)
	crearDeshechos(display.contentWidth-100, 40 , 5.5, "basura2.png", incli)
	crearDeshechos(display.contentWidth    , 60, 4.5, "basura3.png", incli)

	satelite:addEventListener("tap", lanzarRed)
	satelite:addEventListener("touch", moverSatelite)

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
		Runtime:addEventListener( "collision", onCollision )
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
