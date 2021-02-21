local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    print("Project: Tic-tac-toe"); -- Пишем в консоле название проекта

    display.setStatusBar( display.HiddenStatusBar ) -- Прячем статусбар(который ешо наверху такой)

    local background = display.newImageRect(sceneGroup, "background.jpg", display.contentWidth, display.contentHeight); -- Добавляем круток бекграунд ;)
    background.x = display.contentCenterX -- Центруем по иксу
    background.y = display.contentCenterY -- Центруеи по игреку

    ---------------------------------------------------------------------------------------------------------------------------------------------
    -- Добавляем музыкальные кнопки
    ---------------------------------------------------------------------------------------------------------------------------------------------
    local musicPlayButton = display.newImageRect(sceneGroup, "playButton.png", 112.5, 62.5 ); -- Добавляем кнопку play!
    musicPlayButton.x = display.contentCenterX/1.5-12.5 -- Координаты по иксу
    musicPlayButton.y = 40 -- Координаты по игреку
    musicPlayButton.enabled = true; -- делаем её изначально доступной

    local musicStopButton = display.newImageRect(sceneGroup, "stopButton.png", 112.5, 62.5 ); -- Добавляем кнопку stop!
    musicStopButton.x = display.contentCenterX*1.5-12.5 -- Координаты по иксу
    musicStopButton.y = 40 -- Координаты по игреку
    musicStopButton.enabled = false; -- делаем её изначально недоступной
    cnd = true; -- Делаем переменную condition(условие)

    -----------------------------------------------------------------------------------------------------------------------------------------------

    local bgSound = audio.loadSound( "music/bg.mp3" ); -- Загружаем на саунд из папки music

    function musicPlayButton:touch(e) -- Функция, отвечающая за включение и возобновление музыки
        if (e.phase == "ended" and musicPlayButton.enabled == true and cnd == true) then -- ended - когда отпускаешь ЛКМ
            audio.setVolume( 0.1, { channel=1 } ) -- Устанавливаем громкость
            audio.play(bgSound, { channel = 1, loops = -1, fadein = 6000 }); -- Воспроизводим музыку на канале 1 с бесконечным повторением и входом в 6 секунд
            musicPlayButton.enabled = false; -- Делаем что бы нельзя было воспроизводить одну и ту же музыку по 10000 раз
            musicStopButton.enabled = true; --Делаем так что бы можно было остановить наш музик
            cnd = false;
        elseif (e.phase == "ended" and musicPlayButton.enabled == true and cnd == false) then
            audio.resume(1); --возобновляем музыку на канале 1 после остановки, если это надо
        end
    end

    function musicStopButton:touch(e) -- Функция, отвечающая за остановку музыки
        if (e.phase == "ended" and cnd == false) then
            audio.pause(1); -- Приостанавливаем музыку на канале 1
            musicPlayButton.enabled = true; -- Делаем так чтобы её можно было возобновить кнопкой play!
            musicStopButton.enabled = false; -- На всякий случай)
            cnd = false; -- Тоже на всякий случай, если проигрывающаа функция не переведёт условие в нужный момент в false
        end
    end


    musicPlayButton:addEventListener("touch", musicPlayButton) -- Можно назвать это использованием библиотеки(на самом деле нельзя, он просто отслеживает события, а точнее прослушивает)
    musicStopButton:addEventListener("touch", musicStopButton) -- Такая хрень реагирует на нажатия



    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Создаём все необходимые переменные, массивы и группы
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local count = 3 -- Размер поля
    local countToWin = 3 -- Сколько нужно поставить в ряд для победы
    local playerFigure = 1
    local AIFigure = -playerFigure
    local W = display.contentWidth -- Создаём переменную W что бы не писать каждый раз Width
    local H = display.contentHeight -- Создаём переменную H что бы не писать каждый раз Height
    local size = display.contentWidth/count -- Размер клетки
    local startX = W/2 + size/2 - size*count/2 -- Начало отчета для клетки
    local startY = H/2 + size/2 - size*count/2 -- Начало отсчета для клетки
    local emblems
    if playerFigure == 1 then
        emblems = {"redKrestikButton.png", "greenNolikButton.png"}
    else
        emblems = {"greenNolikButton.png", "redKrestikButton.png"}
    end
    local field = {} -- Значения клеток хранятся тут
    local array = {} -- Сами клетки хранятся тут
    for i= 1, count do -- Заполняем двумерный массив
        array[i] = {}
        for j = 1, count do
            array[i][j] = nil
        end
    end

    local mainGroup = display.newGroup(); -- Тут создаём главную "группу" на которой будет находиться всё что у нас есть(Но это не точно ;)
    sceneGroup:insert(mainGroup);

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Functions
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    function Draw() -- Есть ли на поле пустые клетки?
        local FoundEmptyCells = true
        for i = 1, count do
            for j = 1, count do
                if array[i][j].enabled then
                    FoundEmptyCells = false
                end
            end
        end
        return FoundEmptyCells
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- CheckWin возвращает 1 если выиграл ИИ, -1 если выиграл Игрок и 0 если ничья(без обоссаного цикла c) если игра не окончена, возвращает false
    local function CheckWin()
        local combinations = {} -- 1: H, 2: V, 3: D1L(\), 4: D1R(\), 5: D2L(/), 6: D2R(/)
        local function AnybodyWon(dir)
            -- Поскольку фигура игрока = 1, а ИИ = -1, для минимакса их надо бы поменять местами, ведь наибольший потенциал нужен, когды ИИ побеждает
            if combinations[dir] >= countToWin then
                return true
            else return false end
        end
        for i=1, count do
            for dir=1, 6 do
                combinations[dir] = 0
            end
            for j=1, count do

                -- Horizontal:
                if field[i][j] ~= 0 and (combinations[1]/math.abs(combinations[1]) == field[i][j] or combinations[1] == 0) then
                    combinations[1] = combinations[1] + field[i][j]
                    if AnybodyWon(1) then return field[i][j]*(-1) end
                else combinations[1] = 0 end

                -- Vertical:
                if field[j][i] ~= 0 and (combinations[2]/math.abs(combinations[2]) == field[j][i] or combinations[2] == 0) then
                    combinations[2] = combinations[2] + field[j][i]
                    if AnybodyWon(2) then return field[j][i]*(-1) end
                else combinations[2] = 0 end

                -- Diagonal1(\):
                if i+j-1 <= count then
                    -- Left:
                    if field[i+j-1][j] ~= 0 and (combinations[3]/math.abs(combinations[3]) == field[i+j-1][j] or combinations[3] == 0) then
                        combinations[3] = combinations[3] + field[i+j-1][j]
                        if AnybodyWon(3) then return field[i+j-1][j]*(-1) end
                    else combinations[3] = 0 end
                    -- Right:
                    if field[j][i+j-1] ~= 0 and (combinations[4]/math.abs(combinations[4]) == field[j][i+j-1] or combinations[4] == 0) then
                        combinations[4] = combinations[4] + field[j+1][i+j]
                        if AnybodyWon(4) then return field[j+1][i+j]*(-1) end
                    else combinations[4] = 0 end
                end

                -- Diagonal2(/):
                if i-j+1 > 0 then
                    -- Left:
                    if field[i-j+1][j] ~= 0 and (combinations[5]/math.abs(combinations[5]) == field[i-j+1][j] or combinations[5] == 0) then
                        combinations[5] = combinations[5] + field[i-j+1][j]
                        if AnybodyWon(5) then return field[i-j+1][j]*(-1) end
                    else combinations[5] = 0 end
                    -- Right:
                    if field[j][i-j+1] ~= 0 and (combinations[5]/math.abs(combinations[6]) == field[j][i-j+1] or combinations[6] == 0) then
                        combinations[6] = combinations[5] + field[j][i-j+1]
                        if AnybodyWon(6) then return field[j][i-j+1]*(-1) end
                    else combinations[6] = 0 end
                end
            end
        end
        if Draw() then return 0 else return false end
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function DrawFigure(iCord, jCord, prefix) -- префикс: Player, AI
        if not CheckWin() then
            if array[iCord][jCord].enabled then

                local Kartina
                if prefix == 'AI' then
                    Kartina = display.newImageRect(emblems[2], size/1.5, size/1.5)
                    field[iCord][jCord] = AIFigure
                    print( prefix .. ": in [" .. iCord .. "][" .. jCord .. "]" )

                elseif prefix == 'Player' then
                    Kartina = display.newImageRect(emblems[1], size/1.5, size/1.5)
                    field[iCord][jCord] = playerFigure
                    print( prefix .. ": in [" .. iCord .. "][" .. jCord .. "]" )
                end

                local _x, _y = array[iCord][jCord]:localToContent( 0, 0 ) -- Тут узнаём координаты центров квадрата
                Kartina.x = _x
                Kartina.y = _y
                array[iCord][jCord].enabled = false
            end
        end
        CheckWin()
    end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function Minimax(copiedField, depth, isAITurn) -- field = field
        local bestPotential
        if CheckWin() then -- Если игра закончилась, возвращаем игрока, который её закончил, чтобы определить выигрышна-ли ветка.
            print('ololo' .. CheckWin())
            return CheckWin()
        end

        if isAITurn then
            -- Выбираем ход который выгоден для ИИ
            local bestPotential = - math.huge -- math.huge = infinity
            for i=1, count do
                for j=1, count do
                    if copiedField[j][i] == 0 then
                        copiedField[j][i] = AIFigure
                        local fieldPotential = Minimax(copiedField, depth + 1, false) -- На этом моменте с волшебной силой рекурсии мы строим целую ветку развития событий
                        copiedField[j][i] = 0
                        bestPotential = math.max(bestPotential, fieldPotential)
                    end
                end
            end
        else
            -- Выбираем ход который НЕ выгоден для ИИ
            local bestPotential = math.huge
            for i=1, count do
                for j=1, count do
                    if copiedField[j][i] == 0 then
                        copiedField[j][i] = playerFigure
                        local fieldPotential = Minimax(copiedField, depth + 1, true)
                        copiedField[j][i] = 0
                        bestPotential = math.min(bestPotential, fieldPotential)
                    end
                end
            end
        end
        return bestPotential
    end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function LogicAI()
        local attack = {0, 0}
        local bestPotential = - math.huge
        local copiedField = field
        for i=1, count do
            for j=1, count do
                if ( copiedField[j][i] == 0 ) then
                    copiedField[j][i] = AIFigure
                    local fieldPotential = Minimax(copiedField, 0, false)
                    copiedField[j][i] = 0

                    if fieldPotential > bestPotential then
                        -- print(fieldPotential)
                        bestPotential = fieldPotential
                        attack[1], attack[2] = i, j
                    end
                end
            end
        end
        DrawFigure(attack[1], attack[2], 'AI')
    end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function checkButtons(event)
        for i = 1, count do -- Пробегаемся по массиву, который мы привязали к квадратикам
            for j = 1, count do -- Опана, а он двумерный :D
                local currCell = array[i][j]; -- Обозначаем переменную currCell
                local _x, _y = currCell:localToContent( 0, 0 ); -- Тут узнаём координаты центров всех квадратов
                local dx = event.x - _x; --Считаем разницу нажатия и координат квадратика от центра по x
                local dy = event.y - _y; --Считаем разницу нажатия и координат квадратика от центра по y
                local wh  = currCell.width; -- Записываем длину квадрата в переменную
                local ht  = currCell.height; -- Записываем ширину квадрата в переменную

                if (math.abs(dx)<wh/2 and math.abs(dy)<ht/2) then --Если расстояние от центра одного квадрата меньше, чем половина его длины/ширины, то мы понимаем, что нему было произведено нажатие
                    if( currCell.selected == false ) then -- Если по квадратику было произведено нажатие, но до этого он не был выбран - выбираем его
                        currCell.selected = true;
                        -- print('Selected:' .. i .. ", " .. j)
                    end
                else
                    if ( currCell.selected == true ) then -- Если уже выбран какой то ещё объект, то делаем ему стаус "Не выбран"
                        currCell.selected = false;
                        -- print( 'unS' )
                    end
                end
            end
        end
    end

    -- Функция отвечает за то что ты ставишь крестики
    local function touchTurn(event)
        local phase = event.phase
        local function callCheckButtons()
            for i = 1, count do
                for j = 1, count do
                    if array[i][j].enabled then
                        checkButtons(event)
                    end
                end
            end
        end

        if phase == 'began' then
            callCheckButtons()
        elseif phase == 'moved' then
            callCheckButtons()
        elseif phase == 'ended' then
            -----------------------------------------------
            print( ". . .TouchTurn. . ." )
            -----------------------------------------------
            for i= 1, count do
                for j = 1, count do
                    if array[i][j].selected then
                        DrawFigure(i, j, "Player")
                        LogicAI()
                    end
                end
            end
            -----------------------------------------------
        end
    end

    -- Тута у нас функция рисующая прямоугольники
    local function createRect(_id, _x, _y, arrayX, arrayY)
        local rectangle = display.newRect( _x, _y, size, size ) -- Создаём квадрат(Хотя программа его воспринимает как прямоугольник) с шириной size и координатами _x, _y
        rectangle.strokeWidth = 3 -- Указываем ширину линий из которых он состоит
        rectangle:setFillColor( black, 0.01 ) -- Делаем квадратик прозрачным :)
        rectangle:setStrokeColor( 1, 1, 1 ) -- Делаем рандомный цвет квадратику
        rectangle.selected = false;
        rectangle.enabled = true;
        mainGroup.parent:insert(rectangle)-- Добавляем наш прямоугольник на сцену
        array[arrayX][arrayY] = rectangle -- привязываем массив к нашему квадратику
        rectangle:addEventListener( "touch", touchTurn )
    end

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Делаем циклы, необходимые для прорисовки поля и обозначния клеток в массиве
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function drawField()
        for i = 1, count do
            for j = 1, count do
                createRect( i,  startX + (i-1)*size, startY + (j-1)*size, i, j ); -- тут чистая математика, просто надо разобраться и всё
            end
        end

        for i = 1, count do
            field[i] = {};
            for j = 1, count do
                field[i][j] = 0;
            end
        end
    end
    drawField()
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
