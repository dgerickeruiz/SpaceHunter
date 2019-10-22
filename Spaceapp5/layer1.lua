-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local startlock = 0


-------------------------------------------
-- create/position logo/title image on upper-half of the screen
local titleLogo = display.newImageRect( "cclogo.png", 112, 76 )
titleLogo.x = display.contentCenterX
titleLogo.y = 225
titleLogo.alpha = 0

local sponsors = display.newImageRect( "sponsors.png", 141.1, 39.56 )
sponsors.x = display.contentCenterX +10
sponsors.y = 500
sponsors.alpha = 0

local frontlogo = display.newImageRect( "frontlogo.png", 172, 237.44 )
frontlogo.x = display.contentCenterX
frontlogo.y = 150
frontlogo.alpha = 0

local touchthescreen = display.newImageRect( "touchthescreen.png", 128.26, 16.85 )
touchthescreen.x = display.contentCenterX
touchthescreen.y = 500
touchthescreen.alpha = 0

local spacegroup = display.newGroup()
spacegroup:translate(display.contentCenterX, display.contentCenterY)

local space = display.newImageRect(spacegroup, "space.png", 340, 720 )
space.alpha = 1

local mascara = graphics.newMask( "roketmask.png" ) -- 320.0, 1300.0
spacegroup:setMask(mascara)
spacegroup.maskX = contentCenterX
spacegroup.maskScaleX = 0.23	
spacegroup.maskScaleY = 0.3		
spacegroup.maskY = 710

local nave = display.newImageRect( "nave.png", 145.6, 216.7 )
nave.x = display.contentCenterX
nave.y = 800
nave.alpha = 1

local ontouchbtn
local ontouchl3

local function changedisplay()
	-- load menu screen
	
	transition.to( ontouchl3, {time=1000, alpha = 0})
	display.remove(spacegroup)
	composer.gotoScene( "layer4")
	
	
	--display.remove(layer3)
end

	local function createlayer3() 
		display.remove(ontouchbtn)
		display.remove(touchthescreen)
		ontouchl3 = widget.newButton(
			{
				width = 280,
				height = 600,
				defaultFile = "layer3.png",
				onRelease = changedisplay
			}
		)
		ontouchl3.alpha = 0
		ontouchl3.x = display.contentCenterX
		ontouchl3.y = display.contentCenterY
		
		transition.to( ontouchl3, {time=1000, alpha = 1})
	end

local ontouchbuttondo = function(event)
	if ( event.numTaps == 1 ) then
		if (startlock) == 1 then
        ontouchbtn:setEnabled( false )
		transition.to( nave, {time=3000, y=nave.y-1280})
		transition.to( spacegroup, { time=3000, y=spacegroup.y-1280 } )
		transition.to( space, { time=3000, y=space.x+1280, onComplete = createlayer3} )
		end
    else
        return false
    end
end

ontouchbtn = widget.newButton(
    {
        width = 340,
		height = 720,
        defaultFile = "blank.png",
    }
)
ontouchbtn:addEventListener( "tap", ontouchbuttondo )







local fadeOutTouchTheScreen
local fadeInTouchTheScreen = function() 
	transition.to( touchthescreen, {time=1000, alpha=1, onComplete = timer.performWithDelay( 1000, fadeOutTouchTheScreen )}) 
	startlock = 1
end
 fadeOutTouchTheScreen = function() transition.to( touchthescreen, {time=1000, alpha=0.0, onComplete = timer.performWithDelay( 1000, fadeInTouchTheScreen )}) end

local function fadeInSecondSplash()
	transition.to( frontlogo, {time=1000, alpha=1.0})
	transition.to( touchthescreen, {time=1000, alpha=1.0, onComplete = timer.performWithDelay( 2000, fadeOutTouchTheScreen )})

end

local function fadeOutFirstSplash()
	transition.to( titleLogo, {time=1000, alpha=0.0, onComplete = timer.performWithDelay( 2000, fadeInSecondSplash )})
	transition.to( sponsors, {time=1000, alpha=0.0, onComplete = timer.performWithDelay( 2000, fadeInSecondSplash )})
end

local function fadeInFirstSplash()
	transition.to( titleLogo, {time=1000, alpha=1.0, onComplete = timer.performWithDelay( 2000, fadeOutFirstSplash )})
	transition.to( sponsors, {time=1000, alpha=1.0, onComplete = timer.performWithDelay( 2000, fadeOutFirstSplash )})
end




function scene:create( event )
	local sceneGroup = self.view

	local whitescreen = display.newImageRect( "white.png", display.actualContentWidth, display.actualContentHeight )
	whitescreen.anchorX = 0
	whitescreen.anchorY = 0
	whitescreen.x = 0 + display.screenOriginX 
	whitescreen.y = 0 + display.screenOriginY
	
	

	
	-- all display objects must be inserted into group
	-- sceneGroup:insert( background )
	sceneGroup:insert( whitescreen )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( sponsors )
	sceneGroup:insert( frontlogo )
	sceneGroup:insert( ontouchbtn )
	sceneGroup:insert( nave )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

		timer.performWithDelay( 50, fadeInFirstSplash )
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene