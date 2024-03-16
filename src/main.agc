#include "parseImageList.agc"
#include "wordFunctions.agc"
#include "imageFunctions.agc"
#include "parsePuzzleFiles.agc"
#include "advertising.agc"
#include "screenSetup.agc"
#include "parseSoundList.agc"
rem AGK Application
rem

rem attempt to do pseudo percentage system
global devWidth as float
global devHeight as float
global devIsLandscape as float
global devIsLandscapeUpdated as float
global devAspect as float
global devMax as float
global devMin as float
global virtMin as float
global virtMax as float
rem set the default min resolution
rem that the app was designed for
virtMin = 640.0
SetOrientationAllowed( 1, 0, 0,0)

rem init display
InitDisplay()
UpdateResolution()

rem hold whether or not this is the deluxe version
global isDeluxe as integer
    GetDeluxeVersion()

rem holds image data (being red into the app)
type typeImageData
    imageID as integer
    imagePath as string
    imageAtlas as integer
    magFilter as integer
    minFilter as integer
    keepDelete as integer
endtype

rem store data count and define array
global imageDataCount as integer
global dim imageData[] as typeImageData
rem load all images into memory
ParseImagesFromFile()

rem load sounds into memory
rem load music into memory
global dim soundList[] as integer
global soundCount as integer
soundCount = 0
ParseSoundsFromFile()

rem define data for characters
type typeCharacter
    letter as integer
    state as integer
    active as integer
endtype

global usedClue as integer
global wordAnswer as string
global wordAnswerLength as integer
global wordAnswerSpaces as integer
global dim wordAnswerArray[9] as typeCharacter
global dim wordBankArray[2, 12] as typeCharacter

rem hold image data
type typeImage
    imageID as integer
    active as integer
endtype

global dim guessImages[5] as typeImage

rem hold player data
global playerPrefSFX as integer
playerPrefSFX = 1

rem hold puzzle count
global puzzleCount as integer
global dim puzzleCompleted[] as integer

rem hold puzzle data
global dim puzzleArray[12] as string
global puzzleIndex as integer
global puzzleStep as integer
global puzzleHintWord as string
global puzzleHintType as integer
global puzzleAllSolved as integer

GetPuzzleCount()
InitCompleted()

i as integer
j as integer

rem create nav bar sprite
CreateSprite(100, 0)
LazySetSpriteImage(100, 100)
SetSpriteSize(100, virtMin, virtMin * (88 / virtMin))
rem create background sprite
CreateSprite(101, 0)
LazySetSpriteImage(101, 101)
SetSpriteDepth(101, 11)
SetSpriteSize(101, virtMin, virtMax)

rem create picture sprites
rem hide them right away since we're not doing anything with them yet
for i = 110 to 114
    CreateSprite(i, 0)
next

for i = 110 to 113
     SetSpriteSize(i, virtMin * (220 / virtMin), virtMin * (220 / virtMin))
next

        SetSpritePosition(110, virtMin * ((310 - GetSpriteWidth(111)) / virtMin), virtMin * (105 / virtMin))

        SetSpritePosition(113, virtMin * ((310 - GetSpriteWidth(111)) / virtMin), virtMin * (345 / virtMin))
        SetSpritePosition(112,  virtMin * (330 / virtMin), virtMin * (105 / virtMin))
        SetSpritePosition(111,  virtMin * (330 / virtMin), virtMin * (345 / virtMin))
        LazySetSpriteImage(110, 190)
        LazySetSpriteImage(111, 191)
        LazySetSpriteImage(112, 192)
        LazySetSpriteImage(113, 193)
        SetSpritePosition(114, GetSpriteX(110), GetSpriteY(110))
        SetSpriteSize(114, virtMin * (460 / virtMin), virtMin * (460 / virtMin))
        SetSpriteDepth(114, 9)
        //SetSpriteColor(114, 255, 255, 255, 64)
rem create puzzle letter sprites
rem make 'em a lil bit smaller than 64x64
for i = 120 to 130
    CreateSprite(i, 0)
    SetSpriteSize(i, virtMin * (56 / virtMin), virtMin * (56 / virtMin))
    LazySetSpriteImage(i, 226)
next

j = 0.0
center as float
center = virtMin * .5
puzzleWidth as float
puzzleWidth = wordAnswerSpaces * (GetSpriteWidth(120) + (virtMin * (5 / virtMin))) * .5

rem create letter pool sprites
rem make 'em a lil bit smaller than 64x64
for i = 140 to 153
    CreateSprite(i, 0)
    SetSpriteSize(i, virtMin * (80 / virtMin), virtMin * (80 / virtMin))
    LazySetSpriteImage(i, 226)
next

j = 0
for i = 140 to 145
    if i = 140
        SetSpritePosition(i, (virtMin * (10 / virtMin)), (virtMin * ((virtMax  - GetSpriteHeight(i) - 100) / virtMin)))
        SetSpritePosition(i + 6, (virtMin * (10 / virtMin)), (virtMin * ((virtMax - GetSpriteHeight(i + 6) - 10 ) / virtMin)))
    else
        SetSpritePosition(i, (virtMin * (10 / virtMin)) + GetSpriteX(i - 1) + GetSpriteWidth(i - 1), (virtMin * ((virtMax  - GetSpriteHeight(i) - 100) / virtMin)) )
        SetSpritePosition(i + 6, (virtMin * (10 / virtMin)) + GetSpriteX(i + 6 - 1) + GetSpriteWidth(i + 6 - 1), (virtMin * ((virtMax - GetSpriteHeight(i + 6) - 10 ) / virtMin)) )
    endif
next
        i = 152
        SetSpritePosition(i, (virtMin * (10 / virtMin)) + GetSpriteX(i - 1) + GetSpriteWidth(i - 1), (virtMin * ((virtMax  - GetSpriteHeight(i) - 100) / virtMin)) )
        LazySetSpriteImage(i, 228)
        i = 153
        SetSpritePosition(i, GetSpriteX(i - 1), (virtMin * ((virtMax - GetSpriteHeight(i ) - 10 ) / virtMin)) )
        LazySetSpriteImage(i, 229)

rem A Wizard Did It!
CreateHelpScreenItems()
CreateSuccessMenu()
CreateAboutMenu()
CreateCompleteMenu()
CreateGameGUI()
CreateTestImages()
ParsePuzzleFile()



do
    UpdateResolution()
    UpdateLevelChangeGUI()

    UpdateImages()

 GetWordBankInput()
  rem check answer if we can

 Sync()
loop

rem init screen display
function InitDisplay()
    devWidth = GetDeviceWidth()
    devHeight = GetDeviceHeight()

    devIsLandscape = ( devWidth > devHeight )
    if devIsLandscape
        devMin = devHeight
        devMax = devWidth
    else
        devMin = devWidth
        devMax = devHeight
    endif

    devAspect = devMax / devMin
    virtMax = virtMin * devAspect
endfunction

rem update screen resolution depending on device orientation
function UpdateResolution()
    tempLandscape as float
    tempLandscape = ( getDeviceWidth() > getDeviceHeight() )

    if devIsLandscape > tempLandscape or devIsLandscape < tempLandscape
        devIsLandscapeUpdated = 1
    else
        devIsLandscapeUpdated = 0
    endif

    devIsLandscape = tempLandscape

    if devIsLandscape
        virtWidth = virtMax
        virtHeight = virtMin
    else
        virtWidth = virtMin
        virtHeight = virtMax
    endif

  SetVirtualResolution( virtWidth , virtHeight )
endfunction

Function MoveSpriteRelative(pSpriteID as integer, pX as float, pY as float)
    SetSpritePosition(pSpriteID, GetSpriteX(pSpriteID) + pX, GetSpriteY(pSpriteID) + pY)
endfunction

Function GetSpritePressed(pSprite as integer, translateCoords as integer)
    myReturn as integer = 0
    coordX as integer
    coordY as integer

    coordX = GetPointerX()
    coordY = GetPointerY()

    if translateCoords = 1
        coordX = ScreenToWorldX(GetPointerX())
        coordY = ScreenToWorldY(GetPointerY())
    endif

    if GetPointerPressed() = 1
        if GetSpriteVisible(pSprite) = 1
                if coordX > GetSpriteX(pSprite) and coordX < GetSpriteX(pSprite) + GetSpriteWidth(pSprite)
                    if coordY > GetSpriteY(pSprite) and coordY < GetSpriteY(pSprite) + GetSpriteHeight(pSprite)
                       myReturn = 1
                    endif
                endif
        endif
    endif

endfunction myReturn

function CheckSpritePointerCollision(pSpriteID as integer)
    myReturn as integer
    x as integer
    y as integer
    width as integer
    height as integer

    x = GetSpriteX(pSpriteID)
    y = GetSpriteY(pSpriteID)
    width = x + getSpriteWidth(pSpriteID)
    height = y + getspriteheight(pSpriteID)

    if GetPointerPressed() = 1
        if GetPointerX() >= x and getPointerX() <= width
            if GetPointerY() >= y and GetPointerY() <= height
                myReturn = 1
            endif
        endif
    endif

endfunction myReturn

function CheckTextPointerCollision(pSpriteID as integer)
myReturn as integer
    remstart
    x as integer
    y as integer
    width as integer
    height as integer

    x = GetTextX(pSpriteID)
    y = GetTextY(pSpriteID)
    width = x + getTextTotalHeight(pSpriteID)
    height = y + getTextTotalWidth(pSpriteID)

    if GetPointerPressed() = 1
        if GetPointerX() >= x and getPointerX() <= width
            if GetPointerY() >= y and GetPointerY() <= height
                myReturn = 1
            endif
        endif
    endif
    remend

    if GetPointerPressed() = 1
        myReturn = GetTextHitTest(pSpriteID, GetPointerX(), GetPointerY())
    endif

endfunction myReturn

function VirtMinSize(pValue as float)
    myReturn as float

    myReturn = virtMin * (pValue / virtMin)

endfunction myReturn
