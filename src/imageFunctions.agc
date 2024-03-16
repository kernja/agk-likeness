function CreateTestImages()
    guessImages[0].imageID = 190
    guessImages[0].active = 1

    guessImages[1].imageID = 191
    guessImages[1].active = 1

    guessImages[2].imageID = 192
    guessImages[2].active = 0

    guessImages[3].imageID = 193
    guessImages[3].active = 0

    guessImages[4].active = 0


endfunction

function UpdateImages()
    i as integer
    index as integer
    for i = 110 to 114
        index = i - 110

        If GetSpriteVisible(114) = 0
            if CheckSpritePointerCollision(i) = 1
                if i < 114
                    if guessImages[index].active = 1
                        SetSpriteImage(114, guessImages[index].imageID)
                        guessImages[4].active = 1
                    endif
                endif
            endif
        else
            if CheckSpritePointerCollision(i) = 1
                guessImages[4].active = 0
            endif
        endif

        SetSpriteVisible(i, guessImages[index].active)
    next
endfunction
