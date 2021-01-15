local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



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

    local WhoNow = 1 -- Используется для емблем
    local count = 11; -- Размер поля
    local countToWin = 5; -- Сколько нужно поставить в ряд для победы
    local playerFigure = 1;
    local AIFigure = -1;
    local W = display.contentWidth; -- Создаём переменную W что бы не писать каждый раз Width
    local H = display.contentHeight; -- Создаём переменную H что бы не писать каждый раз Height
    local size = display.contentWidth/count; -- Размер клетки
    local startX = W/2 + size/2 - size*count/2; -- Начало отчета для клетки
    local startY = H/2 + size/2 - size*count/2; -- Начало отсчета для клетки
    local emblems = {"redKrestikButton.png", "greenNolikButton.png"} -- Массив с эмблемами "krestMenu.png", "nolMenu.png",
    local arrayText = {} -- Значения клеток хранятся тут
    local array = {} -- Сами клетки хранятся тут
    local arrayPotential = {} -- Тут храним потенцивалы
    local counterrrr = 0
    for i= 1, count do -- Заполняем двумерные массивы
        array[i] = {}
        arrayPotential[i] = {}
        for j = 1, count do
            array[i][j] = nil
            arrayPotential[i][j] = 0
        end
    end

    local mainGroup = display.newGroup(); -- Тут создаём главную "группу" на которой будет находиться всё что у нас есть(Но это не точно ;)
    sceneGroup:insert(mainGroup);

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Functions
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    function getCountFreeRect() --Функция, которая считает свободные квадратики
        local countFree = count^2;
        for i = 1, count do
            for j = 1, count do
                local item_mc = array[i][j];
                if (item_mc.enabled == false) then
                    countFree = countFree - 1;
                end
            end
        end
        return countFree;
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




    local function qweqweqwe() -- ооооо, тут все и начинается
        local function Victory(sum)
            -- print("---Victory---")
            -- print( "sum =" .. sum )
            if ( math.abs(sum) == countToWin ) then -- Если модуль счётчика равен нужному количеству фигур в ряд, то это значит, что кто то выиграл
                if ( sum == countToWin ) then -- Если sum больше чем 0 (3, 4, 5, 6), то это значит, что выиграли крестики
                    print( "X Won" )
                    for i = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                        for j = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                            array[i][j].enabled = false; -- Выключаем все клетки
                        end -- Этот цикл нужен нам, что бы после победы нельзя было ставить крестики и нолики
                    end
                elseif (sum == countToWin*-1 ) then -- Если sum меньше чем 0 (-3, -4, -5, -6), то это значит, что выиграли нолики
                    print( "O Won" )
                    for i = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                        for j = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                            array[i][j].enabled = false; -- Выключаем все клетки
                        end -- Снова цикл, делающий клетки недоступными после победы
                    end
                end
            end
        end
        local sumHorizontal = 0;
        local sumVertical = 0;
        local sumDiagonal1 = 0;
        local sumDiagonal2 = 0;
        for i= 1, count do
            sumHorizontal = 0;
            sumVertical = 0;
            for j= 1, count do
                if ( arrayText[j][i] ~= 0 ) then
                    ---------------------------------------------------------------------------------------------------
                    local function checkWinHorizontal() -- Проверяем горизонтали
                        sumHorizontal = sumHorizontal + arrayText[j][i];
                        ---------
                        Victory(sumHorizontal)
                        ---------
                        if ( j+1 <= count and arrayText[j][i] ~= arrayText[j+1][i] ) then
                            sumHorizontal = 0;
                        end
                    end

                    checkWinHorizontal()
                end
                if ( arrayText[i][j] ~= 0 ) then
                    -----------------------------------------------------------------------------------------------
                    local function checkWinVertical() -- Проверяем вертикали
                        sumVertical = sumVertical + arrayText[i][j]
                        ---------
                        Victory(sumVertical)
                        ---------
                        if ( j+1 <= count and arrayText[i][j] ~= arrayText[i][j+1] ) then -- Клетка нет серии
                            sumVertical = 0;
                        end
                    end
                    checkWinVertical()
                    -------------------------------------------------------------------------------------------------
                    for c = 0, countToWin-1 do

                        local function checkWinDiagonal1() -- Диагональ идущая слева-направо(от верхнего левого угла до нижнего правого)
                            if ( i+c <= count and j+c <= count and arrayText[i][j] == arrayText[i+c][j+c] ) then
                                sumDiagonal1 = sumDiagonal1 + arrayText[i+c][j+c];
                            else
                                sumDiagonal1 = 0;
                            end
                            ---------
                            Victory(sumDiagonal1)
                            ---------
                        end
                        checkWinDiagonal1()
                        ---------------------------------------------------------------------------------------------------
                        local function checkWinDiagonal2() -- Диагональ идущая справа-налево(от )
                            if ( i+c <= count and j-c <= count and arrayText[i][j] == arrayText[i+c][j-c] ) then
                                sumDiagonal2 = sumDiagonal2 + arrayText[i+c][j-c];
                            else
                                sumDiagonal2 = 0;
                            end
                            --------
                            Victory(sumDiagonal2)
                            --------
                        end
                        checkWinDiagonal2()
                    end
                end
            end
        end
    end

    local function CheckWin()
        local function Directions(mltX, mltY)
            for x = 1, count do
                for y = 1, count do
                    local sumFigures = 0
                    if arrayText[x][y] ~= 0 then
                        for c = 1, countToWin do
                            if (x+c*mltX > 0 and x+c*mltX <= count) and (y+c*mltY > 0 and y+c*mltY <= count) then
                                if arrayText[x][y] == arrayText[x+c*mltX][y+c*mltY] then
                                    sumFigures = sumFigures + arrayText[x][y]
                                else
                                    break
                                end
                            end
                        end
                        if math.abs(sumFigures) == countToWin-1 then
                            local strWinner = ""
                            if sumFigures > 0 then
                                strWinner = "X WON"
                            elseif sumFigures < 0 then
                                strWinner = "O WON"
                            end
                            print(strWinner)
                            for i = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                                for j = 1, count do -- Перебераем двумерный массив, чтоб выключить поле
                                    array[i][j].enabled = false; -- Выключаем все клетки
                                end -- Этот цикл нужен нам, что бы после победы нельзя было ставить крестики и нолики
                            end
                        end
                    end
                end
            end
        end
        -- Horizontal
        Directions(-1, 0)
        Directions(1, 0)
        -- Vertical
        Directions(0, -1)
        Directions(0, 1)
        -- Diagonal
        Directions(-1, -1)
        Directions(1, 1)
        Directions(-1, 1)
        Directions(1, -1)
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Вывод потенцЫвалов
    local function OUTPUTtable()
        -- for y = 1, count do
        --     local str = ""
        --     for x = 1, count do
        --         if arrayText[x][y] == 0 then
        --             str = str .." "..arrayPotential[x][y]
        --         elseif arrayText[x][y] == 1 then
        --             str = str .." ".."X"
        --         elseif arrayText[x][y] == -1 then
        --             str = str .." ".."U"
        --         end
        --     end
        --     print(str)
        -- end

        -- for x = 1, count do
        --     for y = 1, count do
        --         local _x, _y = array[x][y]:localToContent( 0, 0 )
        --         local numpon = display.newText("j", size/1.5, size/1.5, _x, _y)
        --
        --
        --
        --
        --     end
        -- end









        -- print("\n")
        -- for i=1, count do
        --     print(unpack(arrayText[i]))
        -- end
    end



    local function DrawFigure(iCord, jCord, prefix) -- префикс: Player, AI
        if ( array[iCord][jCord].enabled ) then
            local _x, _y = array[iCord][jCord]:localToContent( 0, 0 ) -- Тут узнаём координаты центров квадрата
            if ( WhoNow > 2 ) then
                WhoNow = 1
            end
            local Kartina = display.newImageRect(emblems[WhoNow], size/1.5, size/1.5)
            Kartina.x = _x
            Kartina.y = _y
            array[iCord][jCord].enabled = false;
            WhoNow = WhoNow + 1
            if ( WhoNow % 2 == 0 ) then
                arrayText[iCord][jCord] = 1
                print( prefix .. ": X has been printed in [" .. iCord .. "][" .. jCord .. "]" )
            else
                arrayText[iCord][jCord] = -1
                print( prefix .. ": O has been printed in [" .. iCord .. "][" .. jCord .. "]" )
            end
        end
        CheckWin()
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




    local function AIfunc()
        counterrrr = counterrrr + 1
        local function Directions(mltX, mltY)
            for x = 1, count do
                for y = 1, count do
                    if arrayText[x][y] == 0 then -- Будем запоминать потенцЫвал только для пустых клеток
                        print("Проверяем клетку:  " .. x .. " " .. y)
                        for D = 1, 2 do
                            mltX = mltX*-1
                            mltY = mltY*-1
                            for c = 1, countToWin do
                                if (x+c*mltX <= count and x+c*mltX > 0) and (y+c*mltY <= count and y+c*mltY > 0) and
                                (x+(c+1)*mltX <= count and x+(c+1)*mltX > 0) and (y+(c+1)*mltY <= count and y+(c+1)*mltY > 0) then -- Ловим нулл
                                    if arrayText[x+c*mltX][y+c*mltY] ~= 0 then
                                        arrayPotential[x][y] = arrayPotential[x][y] + 1
                                        local Cost
                                        if arrayText[x+c*mltX][y+c*mltY] == playerFigure then
                                            Cost = 2
                                        elseif arrayText[x+c*mltX][y+c*mltY] == AIFigure then
                                            Cost = 3
                                        end
                                        print("\tОна не пустая:  " .. x+c .. " " .. y)
                                        if arrayText[x+c*mltX][y+c*mltY] == arrayText[x+(c+1)*mltX][y+(c+1)*mltY] then
                                            arrayPotential[x][y] = arrayPotential[x][y] + Cost*c
                                        end
                                    else
                                        break
                                    end
                                else
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        -- Horizontal
        Directions(1, 0)
        -- Vertical
        Directions(0, 1)
        -- Diagonals
        Directions(1, 1)
        Directions(1, -1)


        -- arrayPotential sort:
        local xPos = 1
        local yPos = 1
        for x = 1, count do
            for y = 1, count do
                if arrayText[x][y] ~= 0 then
                    arrayPotential[x][y] = 0
                end


                if arrayPotential[x][y] > arrayPotential[xPos][yPos] then
                    print("ПотенцЫвал:"..x.." "..y.." - "..arrayPotential[x][y])
                    xPos = x
                    yPos = y
                elseif arrayPotential[x][y] == arrayPotential[xPos][yPos] and math.random(0, 1) == 1 then
                    print("ПотенцЫвал:"..x.." "..y.." - "..arrayPotential[x][y])
                    xPos = x
                    yPos = y
                end
            end
        end
        DrawFigure(xPos, yPos, "AI")
        OUTPUTtable()

        -- cleaning aP
        for x = 1, count do
            for y = 1, count do
                arrayPotential[x][y] = 0
            end
        end
    end



    local function AIfunc()
        local serPotential = 0
        local _x = 1--(count-(count%2))/2
        local _y = 1--(count-(count%2))/2
        -- Функция отвечат за калькулирование потенцЫвалов
        local function CalcPotentials(_code, _Figure, mltX, mltY, x, y) -- "_code = 1" - С помощью этого аргумента, функция будет работать исправно, по всем направлениям
            mltX = mltX or nil
            mltY = mltY or nil
            x = x or nil
            y = y or nil
            if _code == 1 then
                CalcPotentials(0, _Figure, 1, 0, x, y)
                CalcPotentials(0, _Figure, 0, 1, x, y)
                CalcPotentials(0, _Figure, 1, 1, x, y)
                CalcPotentials(0, _Figure, 1, -1, x, y)

                print(serPotential)
                return serPotential
            else
                local locPotential = 1
                local protectedCells = {0,0}
                for Dir = 1, 2 do
                    mltX = mltX*-1
                    mltY = mltY*-1
                    for c = 1, countToWin do
                        if (x+c*mltX <= count and x+c*mltX > 0) and (y+c*mltY <= count and y+c*mltY > 0) then
                            if _Figure == arrayText[x+c*mltX][y+c*mltY] then
                                print("СЕРИЯ!")
                                locPotential = locPotential + 1
                                print("locPotential = ".. locPotential)
                            elseif arrayText[x+(c)*mltX][y+(c)*mltY] ~= 0 then
                                protectedCells[Dir] = 0
                                print("PPPPPprotectedCells: "..protectedCells[1], protectedCells[2])
                                break

                            elseif arrayText[x+(c)*mltX][y+(c)*mltY] == 0 then
                                protectedCells[Dir] = protectedCells[Dir] + 1
                                if (x+(c+1)*mltX <= count and x+(c+1)*mltX > 0) and
                                    (y+(c+1)*mltY <= count and y+(c+1)*mltY > 0) then
                                    if (arrayText[x+(c+1)*mltX][y+(c+1)*mltY] == 0) then protectedCells[Dir] = protectedCells[Dir] + 1 end
                                end
                                print("protectedCells: "..protectedCells[1], protectedCells[2])
                                break
                            end
                        else
                            protectedCells[Dir] = 0
                            print("Обнуляем протектед целлс около: "..x, y)
                            break
                        end
                    end
                end
                print("Пишем")
                if _Figure == AIFigure then locPotential = locPotential + 0.0001 end
                if (serPotential == countToWin-2 and (protectedCells == {1,2} or protectedCells == {2,1})) or
                    (serPotential == countToWin-1 and (protectedCells[1] >=1 and protectedCells[2] >=1)) or (serPotential > countToWin-1) then
                    if locPotential > serPotential then serPotential = locPotential end
                end
            end
        end


        for x = 1, count do
            for y = 1, count do
                if arrayText[x][y] == 0 then -- Будем подставлять фигуры только в пустые клетки
                    local Figure = AIFigure
                    for q = 1, 2 do
                        Figure = Figure*-1
                        local oldserPotential = serPotential
                        local serPotential = CalcPotentials(1, Figure, nil, nil, x, y)
                        if oldserPotential < serPotential then _x = x _y = y end
                    end
                end
            end
        end
        print("ИТОГ serPotential = "..serPotential.." x: ".._x.." y: ".._y)
        DrawFigure(_x, _y, "AI")
    end




    local function buttonGoEvent( event ) -- Эта функция работает при нажатии на buttonGo


        if ( "ended" == event.phase ) then
            AIfunc()
        end
    end

    -- Create the widget
    local buttonGo = widget.newButton(
        {
            label = "GO",
            fontSize = 35,
            -- font = "Lucida Console",
            labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
            onEvent = buttonGoEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 200,
            height = 40,
            cornerRadius = 2,
            fillColor = { default={0,1,1,1}, over={0,0.8,0.8,0.4} },
            strokeColor = { default={1,1,1,1}, over={0.8,0.8,0.8,1} },
            strokeWidth = 4
        }
    )

    -- Center the button
    buttonGo.x = W/2
    buttonGo.y = H/2+W*0.6
    sceneGroup:insert(buttonGo)





    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function checkButtons(event)
        for i = 1, count do -- Пробегаемся по массиву, который мы привязали к квадратикам
            for j = 1, count do -- Опана, а он двумерный :D
                local item_mc = array[i][j]; -- Обозначаем переменную item_mc
                local _x, _y = item_mc:localToContent( 0, 0 ); -- Тут узнаём координаты центров всех квадратов
                local dx = event.x - _x; --Считаем разницу нажатия и координат квадратика от центра по x
                local dy = event.y - _y; --Считаем разницу нажатия и координат квадратика от центра по y
                local wh  = item_mc.width; -- Записываем длину квадрата в переменную
                local ht  = item_mc.height; -- Записываем ширину квадрата в переменную

                if (math.abs(dx)<wh/2 and math.abs(dy)<ht/2) then --Если расстояние от центра одного квадрата меньше, чем половина его длины/ширины, то мы понимаем, что нему было произведено нажатие
                    if( item_mc.selected == false ) then -- Если по квадратику было произведено нажатие, но до этого он не был выбран - выбираем его
                        item_mc.selected = true;
                        -- print('S')
                    end
                else
                    if ( item_mc.selected == true ) then -- Если уже выбран какой то ещё объект, то делаем ему стаус "Не выбран"
                        item_mc.selected = false;
                        -- print( 'unS' )
                    end
                end
            end
        end
    end

    -- Функция отвечает за то что ты ставишь крестики
    local function touchTurn(event)
        local phase = event.phase;

        if ( phase == 'began' ) then
            for i = 1, count do
                for j = 1, count do
                    local item_mc = array[i][j];
                    if (item_mc.enabled == true) then
                        checkButtons(event);
                    end
                end
            end
        elseif ( phase == 'moved' ) then
            for i = 1, count do
                for j = 1, count do
                    local item_mc = array[i][j];
                    if (item_mc.enabled == true) then
                        checkButtons(event);
                    end
                end
            end
        elseif ( phase == 'ended' ) then
            if( getCountFreeRect() > 0 ) then
                -- print( ". . .TouchTurn. . ." )
                for i= 1, count do
                    for j = 1, count do
                        if ( array[i][j].selected and array[i][j].enabled ) then
                            DrawFigure(i, j, "Player")
                            -- AIfunc()
                            -- for x = 1, count do
                              --     for y = 1, count do
                              --         print(x..","..y..": "..arrayText[x][y]) -- Проверка на работу функции
                              --     end
                              -- end
                        end
                    end
                end
            end
        end
    end

    -- Тута у нас функция рисующая прямоугольники
    local function createRect(_id, _x, _y, arrayX, arrayY)
        rnd1 = math.random(0.0, 1.0) --R
        rnd2 = math.random(0.0, 1.0) --G
        rnd3 = math.random(0.0, 1.0) --B
        if (rnd1 == 0.0 and rnd2 == 0.0 and rnd3 == 0.0) then -- Если цвет квадрата чёрный, то превращаем его в белый
            rnd1 = 1
            rnd2 = 1
            rnd3 = 1
        end

        local rectangle = display.newRect( _x, _y, size, size ) -- Создаём квадрат(Хотя программа его воспринимает как прямоугольник) с шириной size и координатами _x, _y
        rectangle.strokeWidth = 3 -- Указываем ширину линий из которых он состоит
        rectangle:setFillColor( black, 0.01 ) -- Делаем квадратик прозрачным :)
        -- rectangle:setStrokeColor( rnd1, rnd2, rnd3 ) -- Делаем рандомный цвет квадратику
        rectangle:setStrokeColor( 1, 1, 1 )
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
            arrayText[i] = {};
            for j = 1, count do
                arrayText[i][j] = 0;
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
