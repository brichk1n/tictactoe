local composer = require( "composer" ) -- Импортируем модуль composer
local widget = require( "widget" ) -- Импортируем модуль widget

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )
local buttonsGroup = display.newGroup() -- Суда кладем все кнопки
local textGroup = display.newGroup() -- Суда текст
local backGroup = display.newGroup() -- А тут будут элементы бекграунда


-- local function gotoPlay()
-- 	composer.removeScene( "play" )
-- 	composer.gotoScene( "play", { time=800, effect="crossFade" } )
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

    local function buttonPlayEvent( event ) -- Эта функция работает при нажатии на buttonPlay


        if ( "ended" == event.phase ) then
            composer.removeScene( "soloImpossible" )
            composer.gotoScene( "soloImpossible", { time=800, effect="crossFade" } )
            print( "buttonPlay was pressed and released" )
        end
    end

    -- Create the widget
    local buttonPlay = widget.newButton(
        {
            label = "PLAY",
            fontSize = 35,
            -- font = "Lucida Console",
            labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
            onEvent = buttonPlayEvent,
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
    buttonPlay.x = W/2
    buttonPlay.y = H/2+W*0.5
    buttonsGroup:insert(buttonPlay)


    local function buttonNickEvent( event ) -- Эта функция работает при нажатии на buttonPlay

        if ( "ended" == event.phase ) then
            print( "buttonNick was pressed and released" )
        end
    end

    -- Create the widget
    local buttonNick = widget.newButton(
        {
            label = "nick",
            fontSize = 18,
            font = "Lucida Console",
            labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
            onEvent = handleButtonEvent,
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
    buttonNick.x = 49
    buttonNick.y = 15
    sceneGroup:insert(buttonNick)

    local rankCircle = display.newCircle(textGroup, 15, 15, 7)
    rankCircle:setFillColor(1,1,0,1)

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
