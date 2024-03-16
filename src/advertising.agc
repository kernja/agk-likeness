function GetDeluxeVersion()

    isDeluxe = 0

    if GetFileExists("/media/deluxe.txt")
        isDeluxe = 1
    endif
endfunction

function GetPuzzleCount()
    fileID as integer
    fileName as string
    tString as string

    fileName = "/media/count.txt"
    fileID = openToRead(fileName)

    tString = readline(fileID)
    puzzleCount = val(tString)

    InitCompleted()
endfunction

function InitCompleted()
    dim puzzleCompleted[puzzleCount]
    i as integer

    for i = 0 to puzzleCount - 1
        puzzleCompleted[i] = 0
    next

    LoadCompleted()
endfunction

function LoadCompleted()
    foundEmpty as integer
    foundEmpty = 0
    fileID as integer
    fileName as string
    tString as string
    tCount as integer
    i as integer
    puzzleAllSolved = 0
    fileName = "/media/scores.txt"

    if GetFileExists(fileName)
        fileID = opentoread(fileName)

        puzzleIndex = val(readline(fileID))
        for i = 0 to puzzleCount - 1
            tString = readline(fileID)
            puzzleCompleted[i] = val(tString)

            if isDeluxe = 0
                if puzzleCompleted[i] = 0

                    if puzzleIndex < i
                        if foundEmpty = 0
                            puzzleIndex = i
                        endif
                    endif

                    if foundEmpty = 0
                        foundEmpty = 1
                    endif

                endif
            endif
            tCount = tCount + puzzleCompleted[i]
        next

        closefile(fileID)

    endif

   // if tCount > 0
        if tCount = puzzleCount
            puzzleAllSolved = 1
        endif
    //endif

endfunction

function SaveCompleted()
    fileID as integer
    fileName as string
    tString as string

    fileName = "/media/scores.txt"
    fileID = opentowrite(fileName, 0)

    writeLine(fileID, str(puzzleIndex))
    for i = 0 to puzzleCount - 1
        writeline(fileID, str(puzzleCompleted[i]))
    next

    closefile(fileID)

endfunction

function CheckAllCompleted(puzzleID as integer)
    tCount as integer
    i as integer

    puzzleCompleted[puzzleID] = 1

    if puzzleAllSolved = 0
        for i = 0 to puzzleCount - 1
            tCount = tCount + puzzleCompleted[i]
        next

        if tCount = puzzleCount
            sync()
            sync()
            RenderCompleteMenu()
             puzzleAllSolved = 1
        endif


    endif
endfunction
