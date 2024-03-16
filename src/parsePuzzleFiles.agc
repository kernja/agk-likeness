function ParsePuzzleFile()
    fileID as integer
    pValue as integer
    fileName as string
    tString as string
    count as integer
    count = 0

    pValue = puzzleIndex

    if pValue <= 9
        fileName = "/media/puzzles/000" + str(pValue) + ".txt"
    elseif pValue >=10 and pValue <=99
        fileName = "/media/puzzles/00" + str(pValue) + ".txt"
    elseif pValue >=100 and pValue <=999
        fileName = "/media/puzzles/0" + str(pValue) + ".txt"
    else
        fileName = "/media/puzzles/" + str(pValue) + ".txt"
    endif

    fileID = openToRead(fileName)

    while fileEOF(fileID) <> 1
        tString = readline(fileID)
        puzzleArray[count] = tString
        count = count + 1
    endwhile

    closefile(fileID)

    puzzleStep = -1
    CreateTestImages()
    UpdatePuzzleStep()
endfunction

Function UpdatePuzzleStep()
    i as integer
    j as integer
    count as integer
    tBase as string
    tSplit as string


    puzzleStep = puzzleStep + 1
    for i = (puzzleStep * 4) to ((puzzleStep * 4) + 3)
        tBase =   GetStringToken(puzzleArray[i], ":", 1)
        tSplit =  GetStringToken(puzzleArray[i], ":", 2)

        if lower(tBase) = "images"
            guessImages[4].active = 0
            if puzzleStep = 0
                for j = 110 to 114
                    setspriteimage(j, 0)
                next

                DeleteImage(190)
                DeleteImage(191)
                DeleteImage(192)
                DeleteImage(193)
                SetSpriteVisible(112, 0)
                SetSpriteVisible(113, 0)
                LoadImage(190, "/media/images/stock/" + GetStringToken(tSplit, ",", 1))
                LoadImage(191, "/media/images/stock/" + GetStringToken(tSplit, ",", 2))
                SetSpriteImage(110, 190)
                SetSpriteImage(111, 191)
            elseif puzzleStep = 1
                guessImages[2].active = 1

                LoadImage(192, "/media/images/stock/" + tSplit)
                 SetSpriteImage(112, 192)
            else

                guessImages[3].active = 1
                LoadImage(193, "/media/images/stock/" + tSplit)
                SetSpriteImage(113, 193)
            endif
        elseif lower(tBase) = "letter"
            if puzzleStep = 0

                CreateTestBank()
                count = len(tSplit)

                for j = 1 to count
                     WordBankArray[0, j - 1].letter = LetterToInt(mid(tSplit, j, 1))
                next
            else
                count = len(tSplit)

                for j = 1 to count
                     AddToPool(LetterToInt(mid(tSplit, j, 1)))
                next

                while AddToPool(random(0, 25)) = 1
                endwhile
            endif
            RefreshBankImages()
            ShufflePool()
        elseif lower(tBase) = "answer"
            SetTextString(221, upper(tSplit))
            SetAnswerWord(tSplit)
        elseif lower(tBase) = "helper"
            puzzleHintType = val( GetStringToken(tSplit, ",", 1))
            puzzleHintWord = GetStringToken(tSplit, ",", 2)
        endif


    next
endfunction

function SkipPuzzle(pDirection as integer)
    usedClue = 0
    puzzleIndex = puzzleIndex + (pDirection)

    if puzzleIndex < 0
        puzzleIndex = puzzleCount - 1
    endif

    if puzzleIndex > (puzzleCount - 1)
        puzzleIndex = 0
    endif

endfunction
