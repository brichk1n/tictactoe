local composer = require( "composer" ) -- Импортируем модуль composer
local widget = require( "widget" ) -- Импортируем модуль widget

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonsGroup = display.newGroup() -- Суда кладем все кнопки
local textGroup = display.newGroup() -- Суда текст
local backGroup = display.newGroup() -- А тут будут элементы бекграунда



local SmallWheelsCircle1 = display.newImage("wheelscircle.png")
SmallWheelsCircle1.x = 320
SmallWheelsCircle1.y = display.contentHeight/2
SmallWheelsCircle1:scale(0.2, 0.2)
buttonsGroup:insert(SmallWheelsCircle1)


-- local function SmallWheelsCircle1moving( event )
--
--     local SmallWheelsCircle1 = event.target
--     local phase = event.phase
--
--     if ( "began" == phase ) then
--         print("moving began")
--         -- Set touch focus on the ship
--         display.currentStage:setFocus( SmallWheelsCircle1 )
--         -- Store initial offset position
--         SmallWheelsCircle1.x = event.x
--         SmallWheelsCircle1.y = event.y
--         -- SmallWheelsCircle1.touchOffsetY = event.y - SmallWheelsCircle1.y
--
--     elseif ( "moved" == phase ) then
--         print("moving moved")
--         -- Move the ship to the new touch position
--         SmallWheelsCircle1.x = event.x
--         SmallWheelsCircle1.y = event.y
--         -- SmallWheelsCircle1.touchOffsetY = event.y - SmallWheelsCircle1.y
--
--     elseif ( "ended" == phase or "cancelled" == phase ) then
--         print("moving ended")
--         -- Release touch focus on the ship
--         display.currentStage:setFocus( nil )
--     end
--     return true
-- end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    sceneGroup:insert(buttonsGroup) --  Вкладываем buttonsGroup в sceneGroup
    sceneGroup:insert(textGroup) -- Вкладываем textGroup в sceneGroup
    sceneGroup:insert(backGroup) -- Вкладываем backGroup в sceneGroup


    local function buttonBackEvent( event ) -- Эта функция работает при нажатии на buttonPlay

        if ( "ended" == event.phase ) then
            composer.removeScene( "menu" )
            composer.gotoScene( "menu", { time=800, effect="crossFade" } )
            print( "buttonBack was pressed and released" )
        end
    end


    -- Create the widget
    local buttonBack = widget.newButton(
        {
            label = "back",
            fontSize = 18,
            font = "Lucida Console",
            labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
            onEvent = buttonBackEvent,
            textOnly = true,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 200,
            height = 40,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4
        }
    )

    -- Center the button
    buttonBack.x = display.contentWidth - 49
    buttonBack.y = 15
    sceneGroup:insert(buttonBack)


    local WheelsCircle = display.newImage("wheelscircle.png")

    WheelsCircle.x = 0
    WheelsCircle.y = display.contentHeight/2

    WheelsCircle:scale(0.6, 0.6)


    sceneGroup:insert(WheelsCircle)



    -- SmallWheelsCircle1:addEventListener( "touch", SmallWheelsCircle1moving )




    local trianglePlay = display.newImage("trianglePlay.png")

    trianglePlay.x = 50
    trianglePlay.y = display.contentHeight/2

    trianglePlay:scale(0.1, 0.1)
    trianglePlay:rotate(45)


    sceneGroup:insert(trianglePlay)









end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

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
