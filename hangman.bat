@echo off
::Hangman
::
::This is the Hangman game.
::PC randomly chooses one of the words but shows only underscores.
::Player is asked for a letter.
::If the letter is present in a chosen word, the letter is shown.
::If it is not, the gallows is built gradually after every wrong answer.
::The game is over when the word is guessed correctly or the gallows is built.
::Score is to be seen after each draw.
::The game can optionally be used as a language learning program.
::
::Enjoy the game!


echo This is the Hangman game.
echo You have to guess a word.

:start
set passed_letters=0
set bad_attempts=0

rem You can use as many p* variables as necessary.  There can not be spaces.
rem You have to add p* to pairs.  Condition - one pair at least.
set p1=a:indefinite_article+english:language+monday:weekday+mother:parent
set p2=apple:fruit+table:furniture+passion:emotion+flower:plant
set p3=coffee:drink+earth:planet+horse:animal+kitchen:room
set p4=force:strength
set p5=
set pairs=%p1%+%p2%+%p3%+%p4%+%p5%

call :number_of_pairs %pairs%
call :set_word %pairs% %colon_count%
call :str_len guessed_word

setlocal enabledelayedexpansion
:repeat
echo.
echo The word consists of %str_len% letters. Hint: %hint%.

choice /c abcdefghijklmnopqrstuvwxyz /n /m "Insert a letter:"
if %errorlevel% equ 1 set letter=A
if %errorlevel% equ 2 set letter=B
if %errorlevel% equ 3 set letter=C
if %errorlevel% equ 4 set letter=D
if %errorlevel% equ 5 set letter=E
if %errorlevel% equ 6 set letter=F
if %errorlevel% equ 7 set letter=G
if %errorlevel% equ 8 set letter=H
if %errorlevel% equ 9 set letter=I
if %errorlevel% equ 10 set letter=J
if %errorlevel% equ 11 set letter=K
if %errorlevel% equ 12 set letter=L
if %errorlevel% equ 13 set letter=M
if %errorlevel% equ 14 set letter=N
if %errorlevel% equ 15 set letter=O
if %errorlevel% equ 16 set letter=P
if %errorlevel% equ 17 set letter=Q
if %errorlevel% equ 18 set letter=R
if %errorlevel% equ 19 set letter=S
if %errorlevel% equ 20 set letter=T
if %errorlevel% equ 21 set letter=U
if %errorlevel% equ 22 set letter=V
if %errorlevel% equ 23 set letter=W
if %errorlevel% equ 24 set letter=X
if %errorlevel% equ 25 set letter=Y
if %errorlevel% equ 26 set letter=Z

call :already_used %letter%

rem Decision if the inserted letter is in guessed word or not and bad attempts count.
set test1=!guessed_word:%letter%=!
rem Test for words compiled from one or more same letters only.
if "%test1%"=="" (
    goto :good_answer
)
rem Incorrect letter branch
if %test1%==%guessed_word% (
    set /a bad_attempts=!bad_attempts!+1
) else (
    rem Correct letter branch
    :good_answer
    set pos_index=0
    set pos_return=
    :same_letter
    call :letter_pos %guessed_word% %letter% !pos_index! !pos_return!
    call :update_string %guessed_word% %str_len% %string% %letter% !pos_index! !pos_return!
    call :repeat_letter %guessed_word% %str_len% %letter% !pos_index! !pos_return_plus!
)

echo The word is: !string!
echo Count of bad attempts: %bad_attempts% of 10
call :hangman%bad_attempts%
call :evaluate !bad_attempts!
call :end_of_game
exit


rem Functions follow.

rem This function counts number of pairs.
:number_of_pairs
set test_pairs=%1
set colon_count=1
setlocal enabledelayedexpansion
:repeat_pairs
set test_pairs=%test_pairs:~0,-1%
if "%test_pairs:~-1%"=="+" (
    set /a colon_count=!colon_count!+1
) else (
    if "%test_pairs%"=="" (
        endlocal & set colon_count=%colon_count%
        goto :eof
    )
)
goto :repeat_pairs


rem Randomly chosen and returned a guessed word and a hint.
:set_word
set pairs=%1
set colon_count=%2
set /a set_random=(%random%*%colon_count%/32768)+1
for /f "tokens=%set_random% delims=+" %%i in ("%pairs%") do set pair=%%i
for /f "tokens=1 delims=:" %%j in ("%pair%") do set guessed_word=%%j
for /f "tokens=2 delims=:" %%k in ("%pair%") do set hint=%%k
goto :eof


rem Passed the guessed word and returned the length of the word
rem and the underscored string.
:str_len
set string=
setlocal enabledelayedexpansion
:str_len_loop
if not "!%1:~%len%!"=="" (
set /a len+=1
set string=%string%_
goto :str_len_loop
) else (
endlocal & set str_len=%len%& set string=%string%
)
goto :eof


rem Tested if passed letter already used.
:already_used
set letter=%1
set test2=!passed_letters:%letter%=!
if %test2%==%passed_letters% (
    set passed_letters=!passed_letters!%letter%
    goto :eof
) else (
    echo Letter already used. Try again.
    goto :repeat
)


rem The function returns the position of the letter in the guessed word.
:letter_pos
set guessed_word=%1
set letter=%2
set pos_index=%3
set pos_return=%4
:letter_pos_loop
set pos_current=!guessed_word:~%pos_index%,1!
if /i %pos_current%==%letter% (
    set pos_return=%pos_index%
    goto :eof
) else (
    set /a pos_index+=1
    goto :letter_pos_loop
)


rem The function updates the string in a given position.
:update_string
set guessed_word=%1
set str_len=%2
set string=%3
set letter=%4
set pos_index=%5
set pos_return=%6
set /a pos_return_plus=%pos_return%+1
set /a pos_return_end=%str_len%-1
rem Tested if the guessed word is one letter word.
if /i %str_len% equ 1 (
    set string=%letter%
    goto :eof
)
if /i "%guessed_word:~0,1%"=="%letter%" (
    set string=%letter%!string:~1!
)
if /i "%guessed_word:~-1%"=="%letter%" (
    set string=!string:~0,-1!%letter%
)
if %pos_return% gtr 0 (
    if %pos_return% lss %pos_return_end% (
        if /i "!guessed_word:~%pos_return%,1!"=="%letter%" (
            set string=!string:~0,%pos_return%!%letter%!string:~%pos_return_plus%!
        )
    )
)
goto :eof


rem The function decides if there are more same letters in a guessed word.
:repeat_letter
set guessed_word=%1
set str_len=%2
set letter=%3
set pos_index=%4
set pos_return_plus=%5
rem Repetiotion will stop at the last position of the guessed word.
if %str_len% equ %pos_return_plus% (
    goto :eof
)
set rest_of_word=!guessed_word:~%pos_return_plus%!
set test3=!rest_of_word:%letter%=!
rem Tested if there is only the inserted letter in the rest of the guessed word.
rem There can be more than one occurrence.
if "%test3%"=="" (
    goto :eof
)
rem Tested if the letter is present in the rest of the guessed word.
if %test3%==%rest_of_word% (
    goto :eof
) else (
    set /a pos_index+=1
    goto :same_letter
)


rem The function evaluates number of bad attempts and if the word is guessed.
:evaluate
set bad_attempts=%1
if !bad_attempts! equ 10 (
    echo You lost the game.
    goto :eof
)
rem Tested if underscore is still in the string.
set test4=!string:_=!
if "%test4%"=="" (
    goto :repeat
)
if %test4%==!string! (
    echo You are a winner.
    goto :eof
) else (
    goto :repeat
)


rem The end of the game with the possibility to play again.
:end_of_game
choice /m "Do you want to play again?"
if %errorlevel% equ 1 (
echo.
goto :start
)
if %errorlevel% equ 2 (
goto :eof
)


rem Hangman picture functions follow.

:hangman0
goto :eof


:hangman1
echo.
echo.
echo.
echo.
echo.
echo.
echo ~~~~~~~
echo ------------------
goto :eof


:hangman2
echo ^+
echo ^|
echo ^|
echo ^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman3
echo ^+---.
echo ^|
echo ^|
echo ^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman4
echo ^+---.
echo ^|   ^|
echo ^|
echo ^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman5
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman6
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^|   ^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman7
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^| --^|
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman8
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^| --^|--
echo ^|
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman9
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^| --^|--
echo ^|  /
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof


:hangman10
echo ^+---.
echo ^|   ^|
echo ^|   O
echo ^| --^|--
echo ^|  / \
echo ^|
echo ~~~~~~~
echo ------------------
goto :eof
