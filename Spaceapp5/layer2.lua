-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-------------------------------------------
-- create/position logo/title image on upper-half of the screen
local titleLogo = display.newImageRect( "cclogo.png", 112, 76 )
titleLogo.x = display.contentCenterX
titleLogo.y = 225
titleLogo.alpha = 0
-- 'onRelease' event listener for playBtn
local function fadeIn()
	transition.to( titleLogo, {time=1000, alpha=1.0, onComplete= fadeOut()})
end
local function fadeOut()
	transition.to( titleLogo, {time=1000, alpha=0, })
end



function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	-- local background = display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
	-- background.anchorX = 0
	-- background.anchorY = 0
	-- background.x = 0 + display.screenOriginX 
	-- background.y = 0 + display.screenOriginY

	local whitescreen = display.newImageRect( "white.png", display.actualContentWidth, display.actualContentHeight )
	whitescreen.anchorX = 0
	whitescreen.anchorY = 0
	whitescreen.x = 0 + display.screenOriginX 
	whitescreen.y = 0 + display.screenOriginY
	
	

	
	-- all display objects must be inserted into group
	-- sceneGroup:insert( background )
	sceneGroup:insert( whitescreen )
	sceneGroup:insert( titleLogo )
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

		timer.performWithDelay( 50, onPlayBtnRelease )
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