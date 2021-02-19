local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Нужные переменные
W = display.contentWidth
H = display.contentHeight
WCenter = display.contentCenterX
HCenter = display.contentCenterY

-- Go to the menu screen
composer.gotoScene( "menu" )
