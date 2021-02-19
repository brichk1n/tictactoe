print("Project: Tic-tac-toe"); -- Пишем в консоле название проекта

display.setStatusBar( display.HiddenStatusBar ) -- Прячем статусбар(который ешо наверху такой)

local background = display.newImageRect("background.jpg", display.contentWidth, display.contentHeight); -- Добавляем круток бекграунд ;)
background.x = display.contentCenterX -- Центруем по иксу
background.y = display.contentCenterY -- Центруеи по игреку

---------------------------------------------------------------------------------------------------------------------------------------------
-- Добавляем музыкальные кнопки
---------------------------------------------------------------------------------------------------------------------------------------------
local musicPlayButton = display.newImageRect("playButton.png", 112.5, 62.5 ); -- Добавляем кнопку play!
musicPlayButton.x = display.contentCenterX/1.5-12.5 -- Координаты по иксу
musicPlayButton.y = 40 -- Координаты по игреку
musicPlayButton.enabled = true; -- делаем её изначально доступной

local musicStopButton = display.newImageRect("stopButton.png", 112.5, 62.5 ); -- Добавляем кнопку stop!
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

function musicStopButton:touch(e) -- Функция, отвечающаа за остановку музыки
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

local emblems = {"krestMenu.png", "nolMenu.png", "redKrestikButton.png", "greenNolikButton.png"}
local WhoNow = 1

local count = 3;
local countToWin = 3;
      posX = 0;
      posY = 0;
local curRect = nil;
local W = display.contentWidth; -- Создаём переменную W что бы не писать каждый раз Width
local H = display.contentHeight; -- Создаём переменную H что бы не писать каждый раз Height
local size = display.contentWidth/count;
local startX = W/2 + size/2 - size*count/2;
local startY = H/2 + size/2 - size*count/2;
local array = {};
local arrayText = {};

local mainGroup = display.newGroup(); -- Тут создаём главную "группу" на которой будет находиться всё что у нас есть(Но это не точно ;)
mainGroup.parent:insert(mainGroup);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Функция, которая считает свободные квадратки
function getCountFreeRect()
    local countFree = count^2;
    for i = 1, #array do
        local item_mc = array[i];
        if (item_mc.enabled == false) then
            countFree = countFree - 1;
        end
    end
    return countFree;
end

function turnAI() -- Тут у нас ИИ ставит нолики(Пункция хрень, патамушта он ставит их рандомно, а нам надо, что бы он играл осознанно(Идея в процессе разработки))
    for i=1, count^2 do
        if ( countToWin == 3 and arrayText[i] == 1 ) then -- Для игры "3 в ряд" смотрим на крестики
            if ( arrayText[i] == arrayText[i+1] and array[i].y == array[i+1].y and array[i+2].enable == true ) then -- Если у игрока стоит уже 2 крестика в ряд
                print( "AI" )
                local _x, _y = array[i+2]:localToContent( 0, 0 ); -- Вычисляем координаты центра квадратика
                Kartina = display.newImageRect(emblems[WhoNow], size/1.5, size/1.5) -- Ставим нолик
                Kartina.x = _x
                Kartina.y = _y
            elseif( arrayText[i] == arrayText[i+1] and array[i-1].enable == true ) then
                local _x, _y = array[i-1]:localToContent( 0, 0 ); -- Вычисляем координаты центра квадратика
                Kartina = display.newImageRect(emblems[WhoNow], size/1.5, size/1.5) -- Ставим нолик
                Kartina.x = _x
                Kartina.y = _y

                for i=1, #array do
                    item_mc = array[i];
                    item_mc.enabled = false;
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function checkWinX() -- Проверяем выигрыш для Крестиков(Х)
        local function checkWinHorizontal() -- Горизонтальная проверка выигрыша
            for i= 1, count^2 do -- Пробегаемся по всем квадратикам
                if ( countToWin == 3 and arrayText[i] == 1 ) then   -- Проверка, если игра 3х3
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] ) then -- Если 3 в ряд
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y ) then -- Если у всех одинаковые координаты по Y
                            print("X Won")
                            local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 ) -- Да будет белый цвет!
                            for i=1, #array do -- Делаем все квадраты недоступными, что бы было меньше проблем
                                item_mc = array[i];
                                item_mc.enabled = false;
                            end
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] ) then
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y and array[i+2].y == array[i+3].y ) then
                            print("X Won")
                            local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 )
                            for i=1, #array do
                                item_mc = array[i];
                                item_mc.enabled = false;
                            end
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] and arrayText[i+3] == arrayText[i+4] ) then
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y and array[i+2].y == array[i+3].y and array[i+3].y == array[i+4].y ) then
                            print("X Won")
                            local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 )
                            for i=1, #array do
                                item_mc = array[i];
                                item_mc.enabled = false;
                            end
                        end
                    end
                end
            end
        end
        local function checkWinVertical()
            for i=1, count^2 do
                if ( countToWin == 3 and arrayText[i] == 1 ) then
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] and arrayText[i+count*3] == arrayText[i+count*4] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        local function checkWinDiagonal()
            for i=1, count^2 do
                if ( countToWin == 3 and arrayText[i] == 1 ) then
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] and arrayText[i+count*2+2] == arrayText[i+count*3+3] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] and arrayText[i+count*2+2] == arrayText[i+count*3+3] and arrayText[i+count*3+3] == arrayText[i+count*4+4] ) then
                        print("X Won")

                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 3 and arrayText[i] == 1 ) then
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] and arrayText[i+count*2-2] == arrayText[i+count*3-3] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == 1 ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] and arrayText[i+count*2-2] == arrayText[i+count*3-3] and arrayText[i+count*3-3] == arrayText[i+count*4-4] ) then
                        print("X Won")

                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        checkWinDiagonal()
        checkWinVertical()
        checkWinHorizontal()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function checkWin0()
        local function checkWinHorizontal0()
            print( "чеквин0 :D" )
            for i = 1, count^2 do
                if ( countToWin == 3 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] ) then
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y  ) then
                            print("0 Won")
                            local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 )
                        end
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] ) then
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y and array[i+2].y == array[i+3].y ) then
                            print("0 Won")
                            local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 )
                        end
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] and arrayText[i+3] == arrayText[i+4] ) then
                        if ( array[i].y == array[i+1].y and array[i+1].y == array[i+2].y and array[i+2].y == array[i+3].y and array[i+3].y == array[i+4].y ) then
                            print("0 Won")
                            local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                            myText:setFillColor( 1, 1, 1 )
                        end
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        local function checkWinVertical0()
            for i=1, count^2 do
                if ( countToWin == 3 and arrayText[i] == -1 ) then
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] and arrayText[i+count*3] == arrayText[i+count*4] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        local function checkWinDiagonal0()
            for i=1, count^2 do
                if ( countToWin == 3 and arrayText[i] == -1 ) then
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] and arrayText[i+count*2+2] == arrayText[i+count*3+3] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count+1] and arrayText[i+count+1] == arrayText[i+count*2+2] and arrayText[i+count*2+2] == arrayText[i+count*3+3] and arrayText[i+count*3+3] == arrayText[i+count*4+4] ) then
                        print("0 Won")

                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i]
                            item_mc.enabled = false
                        end
                    end
                end
                if ( countToWin == 3 and arrayText[i] == -1 ) then
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] and arrayText[i+count*2-2] == arrayText[i+count*3-3] ) then
                        print("0 Won")
                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == -1 ) then
                    print("0:" .. i )
                    if ( arrayText[i] == arrayText[i+count-1] and arrayText[i+count-1] == arrayText[i+count*2-2] and arrayText[i+count*2-2] == arrayText[i+count*3-3] and arrayText[i+count*3-3] == arrayText[i+count*4-4] ) then
                        print("0 Won")

                        local myText = display.newText( "0 Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end

            checkWinDiagonal0()
            checkWinVertical0()
            checkWinHorizontal0()
end

-- Дохрена сложная функция :D
local function checkButtons(event)
    for i = 1, #array do -- пробегаемся по массиву, который мы привязали к квадратикам
        local item_mc = array[i]; -- Обозначаем переменную item_mc
        local _x, _y = item_mc:localToContent( 0, 0 ); -- Тут узнаём координаты центров всех квадратов
        local dx = event.x - _x; --считаем разницу нажатия и координат квадратика от центра по x
        local dy = event.y - _y; --считаем разницу нажатия и координат квадратика от центра по y
        local wh  = item_mc.width; -- записываем длину квадрата в переменную
        local ht  = item_mc.height; -- записываем ширину квадрата в переменную

        if (math.abs(dx)<wh/2 and math.abs(dy)<ht/2) then --Если расстояние от центра одного квадрата меньше, чем половина его длины/ширины, то мы понимаем, что нему было произведено нажатие
            if( item_mc.selected == false ) then -- Если по квадратику было произведено нажатие, но до этого он не был выбран - выбираем его
                item_mc.selected = true;
                print('S')
            end
        else
            if ( item_mc.selected == true ) then -- если уже выбран какой то ещё объект, то делаем ему сатаус "Не выбран"
                item_mc.selected = false;
                print( 'unS' )

            end
        end
    end
end

-- Функция отвечает за то что ты ставишь крестики
local function touchTurn(event)
    local phase = event.phase;

    if ( phase == 'began' ) then
        print( "touchTurn" )
        for i = 1, #array do
            local item_mc = array[i];
            if (item_mc.enabled == true) then
                checkButtons(event);
            end
        end
    elseif( phase == 'moved' ) then
        for i = 1, #array do
            local item_mc = array[i];
            if (item_mc.enabled == true) then
                checkButtons(event);
            end
        end
    else
        if(getCountFreeRect() > 0) then
            for i = 1, #array do
                local item_mc = array[i];
                if (item_mc.selected and item_mc.enabled) then -- Если квадратик выбран и доступен, ставим там крестик
                  local _x, _y = item_mc:localToContent( 0, 0 ); -- Тут узнаём координаты центров всех квадратов
                  if WhoNow > 2 then
                    WhoNow = 1
                  end
                  Kartina = display.newImageRect(emblems[WhoNow], size/1.5, size/1.5)
                  Kartina.x = _x
                  Kartina.y = _y
                  item_mc.enabled = false;
                  WhoNow = WhoNow + 1

                  if ( WhoNow % 2 == 0 ) then
                      arrayText[i] = 1
                      print( arrayText[i] )
                  else
                      arrayText[i] = -1
                      print( arrayText[i] )
                  end
                  checkWinX();
                  checkWin0();
                  --turnAI();


                end
            end
        end
    end
end

-- Тута у нас функция рисующая прямоугольники
local function createRect(_id, _x, _y)
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
    rectangle:setStrokeColor( rnd1, rnd2, rnd3 ) -- Делаем рандомный цвет квадратику
    rectangle.selected = false;
    rectangle.enabled = true;
    mainGroup.parent:insert(rectangle)-- Добавляем наш прямоугольник на сцену
    table.insert( array, rectangle ) -- привязываем массив к нашему квадратику
    local myText = display.newText( "" , _x, _y, native.systemFont, size/1.5 ) -- Добавляем текст. Да это хреново, но пока он будет за место эконки
    myText:setFillColor( 1, 1, 1 )
    mainGroup.parent:insert(myText)
    table.insert( arrayText, myText )
    rectangle:addEventListener( "touch", touchTurn )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Делаем циклы, необходимые для прорисовки поля и обозначния клеток в массиве
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for i = 1, count^2 do
    createRect( i,  startX + posX*size, startY + posY*size ); -- тут чистая математика, просто надо разобраться и всё
    arrayText[i] = 0
    posX = posX + 1 -- прибавляем к иксу + 1, после рисовки каждого квадрата
    if ( posX % count == 0 ) then -- Пишем условный оператор, который делает из строчки квадратов поле для игры
          posX = 0;
          posY = posY + 1
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
