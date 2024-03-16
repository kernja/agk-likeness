function SetAnswerWord(pWord as string)


    i as integer
    j as integer

    for i = 120 to 130
        SetSpriteColor(i, 255, 255, 255, 255)
    next
    count as integer
    count = len(pWord) - 1

    for i = 0 to 9
        wordAnswerArray[i].letter = -1
        wordAnswerArray[i].state = 0
        wordAnswerArray[i].active = 0

        if i <= count
            wordAnswerArray[i].active = 1
        endif
    next

    wordAnswer = pWord
    wordAnswerLength = count
    wordAnswerSpaces = count + 2

    center as float
    center = virtMin * .5
    puzzleWidth as float
    puzzleWidth = wordAnswerSpaces * (GetSpriteWidth(120) + (virtMin * (5 / virtMin))) * .5

    for i = 120 to 130
        if i < (120 + wordAnswerSpaces)
            BlankSpriteLetter(i)
            SetSpriteVisible(i, 1)

            if i = (120 + wordAnswerSpaces - 1)
                if usedClue = 1
                    SetSpriteColor(i, 255, 0, 0, 255)
                endif
           endif


            SetSpritePosition(i, center - puzzleWidth + (j * GetSpriteWidth(i)) + (virtMin * (5.0 / virtMin) * j), (virtMin * (590 / virtMin)))
            j = j + 1
        else
            SetSpriteVisible(i, 0)
        endif

    next

    LazySetSpriteImage(120 + wordAnswerLength + 1, 227)
endfunction

function AssignSpriteLetter(pSpriteID as integer, pLetter as integer)
    LazySetSpriteImage(pSpriteID, 200 + pLetter)
endfunction

function BlankSpriteLetter(pSpriteID)
    LazySetSpriteImage(pSpriteID, 226)
endfunction

function GetWordBankInput()
    i as integer

    for i = 140 to 151
        if CheckSpritePointerCollision(i) = 1
           // PlaySoundPref(100)
            VerifyPoolInput(i)
        endif
    next

    if CheckSpritePointerCollision(152) = 1
       PlaySoundPref(100)

        for i = 120 to (120 + wordAnswerSpaces - 2)
            SetSpriteColor(i, 255, 255, 255, 255)
        next

        ClearAnswer()
    endif

    if CheckSpritePointerCollision(153) = 1
                PlaySoundPref(100)
        ShufflePool()
    endif

    for i = 120 to (120 + wordAnswerSpaces - 1)
        if CheckSpritePointerCollision(i) = 1
            //PlaySoundPref(100)
            VerifyAnswerInput(i)

        endif
    next
endfunction

function VerifyAnswerInput(pIndex as integer)
    index as integer
    index = pIndex - 120

        for i = 120 to (120 + wordAnswerSpaces - 2)
            SetSpriteColor(i, 255, 255, 255, 255)
        next

    //rem delete letter from answer
        if index <= wordAnswerLength
            if wordAnswerArray[index].state = 1
                BlankSpriteLetter(pIndex)
                AddToPool(wordAnswerArray[index].letter)
                wordAnswerArray[index].state = 0
                PlaySoundPref(100)



            endif
        else

            if usedClue = 0
                if isDeluxe = 0
                    usedClue = 1
                    SetSpriteColor(120 + wordAnswerSpaces - 1, 255, 0, 0, 255)
                endif


                PlaySoundPref(100)
                //helper function here
                RenderHelp()
            else

                 PlaySoundPref(103)
            endif
        endif


endfunction

function VerifyPoolInput(pIndex as integer)
    index as integer
    index = pIndex - 140

    //rem make sure there is enough space in the answer to accept input
    if WordBankArray[0, index].state = 1
        if AddToAnswer(WordBankArray[0, index].letter) = 1
            WordBankArray[0, index].state = 0
            BlankSpriteLetter(pIndex)
            PlaySoundPref(100)

                if CanCheckAnswer() = 1
                    CheckAnswer()
                endif
        endif
    endif
endfunction

function CreateTestBank()
    i as integer

    for i = 0 to 11
        WordBankArray[0, i].letter = random(0, 25)
        WordBankArray[0, i].state = 1
        AssignSpriteLetter(140 + i, WordBankArray[0, i].letter)
    next

endfunction

function RefreshBankImages()
    i as integer

    for i = 0 to 11
        AssignSpriteLetter(140 + i, WordBankArray[0, i].letter)
    next

endfunction

function ClearAnswer()
    j as integer

    for j = 0 to wordAnswerLength
        BlankSpriteLetter(j + 120)

        //rem make sure there is enough space in the answer to accept input
        if wordAnswerArray[j].state = 1
            AddToPool(wordAnswerArray[j].letter)
            wordAnswerArray[j].state = 0
        endif
    next
endfunction


function DeleteAnswer()
    j as integer

    for j = 0 to wordAnswerLength
        BlankSpriteLetter(j + 120)

        //rem make sure there is enough space in the answer to accept input
        if wordAnswerArray[j].state = 1
            wordAnswerArray[j].state = 0
        endif
    next
endfunction

function AddToPool(pLetter as integer)
    i as integer
    myReturn as integer

    for i = 0 to 11
        if WordBankArray[0, i].state = 0
            WordBankArray[0, i].state = 1
            WordBankArray[0, i].letter = pLetter

            AssignSpriteLetter(140 + i, pLetter)

            exitfunction 1
        endif
    next
endfunction 0

function AddToAnswer(pLetter as integer)
    i as integer
    myReturn as integer

    for i = 0 to wordAnswerLength
        if wordAnswerArray[i].active = 1
            if wordAnswerArray[i].state = 0
                wordAnswerArray[i].state = 1
                wordAnswerArray[i].letter = pLetter

                AssignSpriteLetter(120 + i, pLetter)

                exitfunction 1
            endif
        endif
    next
endfunction 0

function CanCheckAnswer()
    i as integer
    myReturn as integer

        for i = 0 to wordAnswerLength
            if wordAnswerArray[i].active = 1
                if wordAnswerArray[i].state = 0

                    exitfunction 0
                endif
            endif
        next

endfunction 1

function CheckAnswer()
    i as integer
    tempWord as string
    tempWord = ""
    for i = 0 to wordAnswerLength
        tempWord = tempWord + IntToLetter(wordAnswerArray[i].letter)
    next

    if tempWord = wordAnswer
        if puzzleStep = 2
            RenderSuccess()
            CheckAllCompleted(puzzleIndex)
            SkipPuzzle(1)
            SaveCompleted()
            ParsePuzzleFile()
        else
            RenderSuccess()
            UpdatePuzzleStep()
        endif
    else

        PlaySoundPref(103)

            for i = 120 to (120 + wordAnswerSpaces - 2)
                SetSpriteColor(i, 255, 0, 0, 255)
            next
    endif

endfunction

function ShufflePool()
    i as integer
    j as integer
    rand as integer
    assigned as integer

    for i = 0 to 11
        WordBankArray[1, i].active = 0
        WordBankArray[1, i].state = 0
        WordBankArray[1, i].letter = -1
    next

    for i = 0 to 11
        assigned = 0

        while assigned = 0
            rand = random(0, 11)
                if WordBankArray[1, rand].letter = -1
                    WordBankArray[1, rand].letter = WordBankArray[0, i].letter
                    WordBankArray[1, rand].active = WordBankArray[0, i].active
                    WordBankArray[1, rand].state = WordBankArray[0, i].state

                    assigned = 1
                endif
        endwhile
    next

     for i = 0 to 11
            WordBankArray[0, i].letter = WordBankArray[1, i].letter
            WordBankArray[0, i].active = WordBankArray[1, i].active
            WordBankArray[0, i].state = WordBankArray[1, i].state

            if WordBankArray[0, i].state = 1
                 AssignSpriteLetter(140 + i,  WordBankArray[0, i].letter)
            else
                BlankSpriteLetter(i + 140)
            endif
    next
endfunction

function LetterToInt(pLetter as string)
    myReturn as integer

    if lower(pLetter) = "a"
        myReturn = 0
    elseif lower(pLetter) = "b"
        myReturn = 1
    elseif lower(pLetter) = "c"
        myReturn = 2
    elseif lower(pLetter) = "d"
        myReturn = 3
    elseif lower(pLetter) = "e"
        myReturn = 4
    elseif lower(pLetter) = "f"
        myReturn = 5
    elseif lower(pLetter) = "g"
        myReturn = 6
    elseif lower(pLetter) = "h"
        myReturn = 7
    elseif lower(pLetter) = "i"
        myReturn = 8
    elseif lower(pLetter) = "j"
        myReturn = 9
    elseif lower(pLetter) = "k"
        myReturn = 10
    elseif lower(pLetter) = "l"
        myReturn = 11
    elseif lower(pLetter) = "m"
        myReturn = 12
    elseif lower(pLetter) = "n"
        myReturn = 13
    elseif lower(pLetter) = "o"
        myReturn = 14
    elseif lower(pLetter) = "p"
        myReturn = 15
    elseif lower(pLetter) = "q"
        myReturn = 16
    elseif lower(pLetter) = "r"
        myReturn = 17
    elseif lower(pLetter) = "s"
        myReturn = 18
    elseif lower(pLetter) = "t"
        myReturn = 19
    elseif lower(pLetter) = "u"
        myReturn = 20
    elseif lower(pLetter) = "v"
        myReturn = 21
    elseif lower(pLetter) = "w"
        myReturn = 22
    elseif lower(pLetter) = "x"
        myReturn = 23
    elseif lower(pLetter) = "y"
        myReturn = 24
    else
        myReturn = 25
    endif

endfunction myReturn

function IntToLetter(pIndex as integer)
    myReturn as string

    if pIndex = 0
        myReturn = "a"
    elseif pIndex = 1
        myReturn = "b"
    elseif pIndex = 2
        myReturn = "c"
    elseif pIndex = 3
        myReturn = "d"
    elseif pIndex = 4
        myReturn = "e"
    elseif pIndex = 5
        myReturn = "f"
    elseif pIndex = 6
        myReturn = "g"
    elseif pIndex = 7
        myReturn = "h"
    elseif pIndex = 8
        myReturn = "i"
    elseif pIndex = 9
        myReturn = "j"
    elseif pIndex = 10
        myReturn = "k"
    elseif pIndex = 11
        myReturn = "l"
    elseif pIndex = 12
        myReturn = "m"
    elseif pIndex = 13
        myReturn = "n"
    elseif pIndex = 14
        myReturn = "o"
    elseif pIndex = 15
        myReturn = "p"
    elseif pIndex = 16
        myReturn = "q"
    elseif pIndex = 17
        myReturn = "r"
    elseif pIndex = 18
        myReturn = "s"
    elseif pIndex = 19
        myReturn = "t"
    elseif pIndex = 20
        myReturn = "u"
    elseif pIndex = 21
        myReturn = "v"
    elseif pIndex = 22
        myReturn = "w"
    elseif pIndex = 23
        myReturn = "x"
    elseif pIndex = 24
        myReturn = "y"
    else
        myReturn = "z"
    endif

endfunction myReturn

