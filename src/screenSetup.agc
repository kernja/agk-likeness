function CreateHelpScreenItems()
    CreateSprite(200, 0)
    SetSpriteSize(200, virtMin, virtMax)
    SetSpriteDepth(200, 8)
    SetSpriteColor(200, 0, 0, 0, 192)
    SetSpriteVisible(200, 0)
    i as integer
    for i = 200 to 202
        CreateText(i, "1")
        SetTextAlignment(i, 1)
        SetTextVisible(i, 0)
        SetTextDepth(i, 7)
        SetTextFontImage(i, 102)
    next

    SetTextSize(200, virtMin * (80 / virtMin))
    SetTextPosition(200, virtMin * .5, virtMax * .5 - GetTextTotalHeight(200) * 2)
    SetTextSize(201, virtMin * (64 / virtMin))
    SetTextPosition(201, virtMin * .5, virtMax * .5)
    SetTextSize(202, virtMin * (80 / virtMin))
    SetTextPosition(202, virtMin * .5, virtMax * .5 + GetTextTotalHeight(201) * 2)

endfunction

function RenderHelp()
    currentTime as float
    if isDeluxe = 0
        currentTime = 4.0
    else
        currentTime = 0
         SetTextString(202, "/")
    endif


    i as integer

    if puzzleHintType = 0
        SetTextString(200, "HYPERNYM")
    elseif puzzleHintType = 1
        SetTextString(200, "ANTONYM")
    elseif puzzleHintType = 2
        SetTextString(200, "SYNONYM")
    else
        SetTextString(200, "HYPONYM")
    endif

    SetTextString(201, upper(puzzleHintWord))
    SetSpriteVisible(200, 1)
    for i = 200 to 202
        SetTextVisible(i, 1)
    next

    while currentTime > 0.0
        currentTime = currentTime - GetFrameTime()

        if currentTime < 0
            currentTime = 0
            playsoundpref(104)
        endif

        SetTextString(202,str(round(currentTime)))
        sync()
    endwhile

    SetTextString(202, "/")

    while CheckTextPointerCollision(202) = 0
        sync()
    endwhile
                PlaySoundPref(100)
    SetSpriteVisible(200, 0)
     for i = 200 to 202
        SetTextVisible(i, 0)
    next
endfunction

function CreateGameGUI()

    i as integer
    for i = 210 to 214
        CreateText(i, "dd")
        //SetTextAlignment(i, 1)
        SetTextVisible(i, 1)
        SetTextDepth(i, 9)
        SetTextFontImage(i, 103)
    next

    SetTextString(210, "I")
    SetTextSize(210, VirtMinSize(64))
    SetTextPosition(210, VirtMinSize(12), VirtMinSize(12))

    SetTextString(211, "1")
    SetTextSize(211, VirtMinSize(64))
    SetTextPosition(211, VirtMinSize(virtMin * .5), VirtMinSize(44 - (GetTextTotalHeight(211) * .5)))
    SetTextAlignment(211, 1)

    SetTextString(212, "E")
    SetTextSize(212, VirtMinSize(64))
    SetTextPosition(212, VirtMinSize(virtMin - 12 - 64), VirtMinSize(12))

    SetTextString(213, "D")
    SetTextSize(213, VirtMinSize(64))
    SetTextPosition(213, VirtMinSize(virtMin - 12 - 128), VirtMinSize(12))

    SetTextString(214, "C")
    SetTextSize(214, VirtMinSize(64))
    SetTextPosition(214, VirtMinSize(64 + 12 + 32), VirtMinSize(12))
    SetTextAlignment(214, 1)

    //SetTextPosition(210, virtMin * .5, virtMax * .5 - GetTextTotalHeight(200) * 2)

   // SetTextPosition(212, virtMin * .5, virtMax * .5 + GetTextTotalHeight(201) * 2)

endfunction

function UpdateLevelChangeGUI()
    //change text based on puzzle
      if CheckTextPointerCollision(214) = 1
        if playerPrefSFX = 1
            playerPrefSFX = 0
        else
            playerPrefSFX = 1
        endif

        PlaySoundPref(104)
      endif

    if playerPrefSFX = 1
        SetTextString(214, "C")
    else
        SetTextString(214, "S")
    endif
    if CheckTextPointerCollision(210) = 1
         PlaySoundPref(100)

        RenderAboutMenu()
      endif

   if puzzleCompleted[puzzleIndex] = 0
        SetTextColor(211, 255, 255, 255, 255)
    else
        SetTextColor(211, 0, 255, 0, 255)
    endif

    SetTextString(211, str(puzzleIndex + 1))

    if isDeluxe = 1
    //if puzzleIndex = 0
    //   SetTextString(212, "U")
   // else
        SetTextString(212, "E")

        if CheckTextPointerCollision(212)
                   SkipPuzzle(-1)
                        CreateTestImages()
                        PlaySoundPref(100)
                        ParsePuzzleFile()
                endif
           // endif

    //if puzzleIndex < 0
    //   SetTextString(213, "T")
    //else
        SetTextString(213, "D")

        if CheckTextPointerCollision(213)
            SkipPuzzle(1)
                CreateTestImages()
                PlaySoundPref(100)
                ParsePuzzleFile()
        endif
    //endif
    else
         SetTextVisible(213, 0)
        SetTextvisible(212, 0)
    endif



endfunction

function CreateSuccessMenu()
    CreateSprite(220, 0)
    SetSpriteSize(220, virtMin, virtMax)
    SetSpriteDepth(220, 8)
    SetSpriteColor(220, 0, 0, 0, 192)
    SetSpriteVisible(220, 0)
    i as integer
    for i = 220 to 222
        CreateText(i, "LIKENESS")
        SetTextAlignment(i, 1)
        SetTextVisible(i, 0)
        SetTextDepth(i, 7)
        SetTextFontImage(i, 102)
    next

    SetTextSize(220, virtMin * (80 / virtMin))
    SetTextPosition(220, virtMin * .5, virtMax * .5 - GetTextTotalHeight(220) * 2)
    SetTextSize(221, virtMin * (64 / virtMin))
    SetTextPosition(221, virtMin * .5, virtMax * .5)
    SetTextSize(222, virtMin * (80 / virtMin))
    SetTextPosition(222, virtMin * .5, virtMax * .5 + GetTextTotalHeight(221) * 2)

endfunction

function RenderSuccess()
    currentTime as float


    if isDeluxe = 0
        currentTime = 4.0
    else
        currentTime = 0
                 SetTextString(222, "/")
    endif

    i as integer
            PlaySoundPref(102)
    SetSpriteVisible(220, 1)
    for i = 220 to 222
        SetTextVisible(i, 1)
    next

    while currentTime > 0.0
        currentTime = currentTime - GetFrameTime()

        if currentTime < 0
            currentTime = 0
            playsoundpref(104)
        endif

        SetTextString(222,str(round(currentTime)))
        sync()
    endwhile

    SetTextString(222, "/")

    while CheckTextPointerCollision(222) = 0
        sync()
    endwhile

    PlaySoundPref(100)
    SetSpriteVisible(220, 0)
     for i = 220 to 222
        SetTextVisible(i, 0)
    next

    sync()
endfunction

function CreateAboutMenu()
    CreateSprite(230, 0)
    SetSpriteSize(230, virtMin, virtMax)
    SetSpriteDepth(230, 8)
    SetSpriteColor(230, 0, 0, 0, 192)
    SetSpriteVisible(230, 0)

    CreateSprite(231, 0)
    SetSpriteSize(231, VirtMinSize(virtMin), VirtMinSize(virtMin))

    if isDeluxe = 0
        SetSpriteImage(231, 105)
    else
        SetSpriteImage(231, 104)
    endif
    SetSpritePosition(231, VirtMinSize((virtMin * .5) - (.5 * GetSpriteWidth(231))), VirtMinSize((virtMax * .5) - (.5 * GetSpriteHeight(231))))
    SetSpriteDepth(231, 7)
    SetSpriteVisible(231, 0)

    i as integer
     i = 230
        CreateText(i, "LIKENESS")
        SetTextAlignment(i, 1)
        SetTextVisible(i, 0)
        SetTextDepth(i, 7)
        SetTextFontImage(i, 102)

    SetTextSize(230, virtMin * (80 / virtMin))
    SetTextPosition(230, virtMin * .5, GetSpriteY(231) + GetSpriteHeight(231) - virtMinSize(32))

endfunction

function RenderAboutMenu()
    currentTime as float
    if isDeluxe = 0
        currentTime = 4
    else
        currentTime = 0.0
                 SetTextString(230, "/")
    endif


    i as integer
    SetSpriteVisible(230, 1)
    SetSpriteVisible(231, 1)
    SetTextVisible(230, 1)


    while currentTime > 0.0
        currentTime = currentTime - GetFrameTime()

        if currentTime < 0
            currentTime = 0
            playsoundpref(104)
        endif

        SetTextString(230,str(round(currentTime)))
        sync()
    endwhile

    SetTextString(230, "/")

    while CheckTextPointerCollision(230) = 0
        sync()
    endwhile

    PlaySoundPref(100)
    SetSpriteVisible(230, 0)
    SetSpriteVisible(231, 0)
        SetTextVisible(230, 0)

    sync()
endfunction

function CreateCompleteMenu()
    CreateSprite(240, 0)
    SetSpriteSize(240, virtMin, virtMax)
    SetSpriteDepth(240, 8)
    SetSpriteColor(240, 0, 0, 0, 192)
    SetSpriteVisible(240, 0)

    CreateSprite(241, 0)
    SetSpriteSize(241, VirtMinSize(virtMin), VirtMinSize(virtMin))

    SetSpriteImage(241, 106)

    SetSpritePosition(241, VirtMinSize((virtMin * .5) - (.5 * GetSpriteWidth(241))), VirtMinSize((virtMax * .5) - (.5 * GetSpriteHeight(241))))
    SetSpriteDepth(241, 7)
    SetSpriteVisible(241, 0)

    i as integer
     i = 240
        CreateText(i, "LIKENESS")
        SetTextAlignment(i, 1)
        SetTextVisible(i, 0)
        SetTextDepth(i, 7)
        SetTextFontImage(i, 102)

    SetTextSize(240, virtMin * (80 / virtMin))
    SetTextPosition(240, virtMin * .5, GetSpriteY(241) + GetSpriteHeight(241) - virtMinSize(32))

endfunction

function RenderCompleteMenu()
    currentTime as float
    PlaySoundPref(101)

    if isDeluxe = 0
        currentTime = 4.0
    else
        currentTime = 0
         SetTextString(240, "/")
    endif


    i as integer
    SetSpriteVisible(240, 1)
    SetSpriteVisible(241, 1)
    SetTextVisible(240, 1)


    while currentTime > 0.0
        currentTime = currentTime - GetFrameTime()

        if currentTime < 0
            currentTime = 0
            playsoundpref(104)
        endif

        SetTextString(240,str(round(currentTime)))
        sync()
    endwhile

    SetTextString(240, "/")

    while CheckTextPointerCollision(240) = 0
        sync()
    endwhile

    PlaySoundPref(100)
    SetSpriteVisible(240, 0)
    SetSpriteVisible(241, 0)
        SetTextVisible(240, 0)

    sync()
endfunction
