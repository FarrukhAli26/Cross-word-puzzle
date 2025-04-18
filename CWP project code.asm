
INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 1000

.DATA

	filenameL1 BYTE "level1.txt",0
	filenameL2 BYTE "level2.txt",0
	filenameL3 BYTE "level3.txt",0

	fileContentL1 BYTE "F A S T X S",0dh,0ah,
					   "Z S P O T H",0dh,0ah,
					   "C X Y U P O",0dh,0ah,
					   "A X X C A U",0dh,0ah,
					   "M Y C H L T",0dh,0ah,
					   "A P P L E F",0

    fileContentL2 BYTE "B X Y L M D B Y X",0dh,0ah, "C D X S O E C Z A",0dh,0ah, "V A L U E M M L O",0dh,0ah,
					   "Y T S C E P X P A",0dh,0ah, "C A S C V L Y Q C",0dh,0ah, "L A W E I O N S C",0dh,0ah,
                       "Z M S S R Y W Z E",0dh,0ah, "X A M S U E V R P",0dh,0ah, "M B C Y S E U T T",0


	fileContentL3 BYTE "B A X O M D L C W Y Z M", 0dh, 0ah,"D A C C Z W M X V Y X A", 0dh, 0ah,"X W O O M O N E Y Y Z N", 0dh, 0ah,
					   "B A B R E S O U R C E A", 0dh, 0ah,"L L O O N F X Y M N O G", 0dh, 0ah,"R L G F I N A N C E X E", 0dh, 0ah,
					   "X E B R E W A R D X Y M", 0dh, 0ah,"L T R A N I N G R A B E", 0dh, 0ah,"G Y U M O V V W O M L N", 0dh, 0ah,
					   "X Y R G R G M A B O L T", 0dh, 0ah,"G L M N O P Q R L D E X", 0dh, 0ah,"Y E N G I T E E R I N G", 0

	filenameInst BYTE "instruction.txt",0

	;fileContentInst BYTE "INSTRUCTIONS:", 0dh, 0ah,"=> Choose an option from the menu.", 0dh, 0ah,"=> In Quick play, you'll see a maze. Find a word, enter it, and press Enter.", 0dh, 0ah,
	;					 "=> If your answer is correct, your score increases by 1. Otherwise, your lives decrease by 1.", 0dh, 0ah,
	;					 "=> To pass each level you have to make 5 words, and save your life.", 0dh, 0ah,"=> The twist in the game is that, if you re-enter the word that is found, your live will be decremented by 1.",
	;					 "=> Enter your choice as a digit and press Enter.", 0dh, 0ah,"=> To change the console color, select Settings, then go to Change Color, choose your color, and press Enter.", 0dh, 0ah,
	;					 "=> To go to the main menu press Enter.", 0


	str1 BYTE "Enter Word: ",0
	input BYTE 10 DUP(?) ;taking input from user

	score BYTE 0
	Lives BYTE 3
	check BYTE 1
	highScore BYTE 0

	word_list_l1 BYTE "FAST",0,"APPLE",0,"SPOT",0,"TOUCH",0,"SHOUT",0
	word_list_l2 BYTE "VALUE",0,"EMPLOYEE",0,"SUCCESS",0,"LAW",0,"VIRUS",0,"DATA",0,"ACCEPT",0
	word_list_l3 BYTE "FINANCE",0,"MONEY",0,"REWARD",0,"WALLET",0,"WARE",0,"BOLT",0,"GRAB",0,"RESOURCE",0

	arr_L1 BYTE 5 DUP(1)
	arr_L2 BYTE 7 DUP(1)
	arr_L3 BYTE 8 DUP(1)

	ecxTracker DWORD 0
	i DWORD 0
	j DWORD 0

	file_L1 BYTE "level1.txt",0
	file_L2 BYTE "level2.txt",0
	file_L3 BYTE "level3.txt",0

	file_instructions BYTE "instruction.txt",0
	char BYTE 4 Dup("0")
	
	;read file
	buffer BYTE BUFFER_SIZE DUP(0)
	fileHandle HANDLE ?


.CODE
main PROC
    
;call createFiles

call Intro

WhileTrue:
	call clrscr
	call DisplayMainMenu

	cmp al,1
	je QuickPlay
	cmp al,2
	je Instruction
	cmp al,3
	je Setting
	cmp al,4
	je DisplayHighScore
	cmp al,5
	je QuitProgram
	jmp InvalidOption

QuickPlay:
	call Quick_play
	jmp quit

Instruction:
	call DisplayInstructions
	jmp quit

Setting:
	call ChangeSettings
	jmp quit

DisplayHighScore:
	call ReadHighScore
	jmp quit

QuitProgram:
	mov check,0
	jmp EndProgram

InvalidOption:
	mWrite <"You Enter Invalid Number",0dh,0ah>
	mov eax,500
	call delay
	jmp WhileTrue

quit:
	call readdec
	cmp check,0
	jne WhileTrue

EndProgram:
exit
main ENDP


createFiles PROC
	mov edx, OFFSET filenameL1

    ; Create a new text file
    call CreateOutputFile
    mov fileHandle, eax

    ; Check for errors
    cmp eax, INVALID_HANDLE_VALUE
    je fileCreationFailed

    ; Write the content to the file
    mov edx, offset fileContentL1
    mov ecx, lengthof fileContentL1
    call WriteToFile

    ; Close the file
    call CloseFile

    ; Display success message
    mWrite <"File 'level1.txt' created successfully.", 0dh, 0ah>
    jmp endProgram

fileCreationFailed:
    mWrite <"Failed to create file 'level1.txt'.", 0dh, 0ah>
endProgram: 
ret
createFiles ENDP


Intro PROC

	mWrite <"*",0dh,0ah>
	mWrite <"******** WELCOME TO CROSSWORD PUZZLE **********",0dh,0ah>
	mWrite <"*",0dh,0ah>
	mWrite <"*****************  MADE BY:  ******************",0dh,0ah>
	mWrite <"*",0dh,0ah>
	mWrite <"***************  ALI JAFFRY *****************",0dh,0ah>
	mWrite <"*",0dh,0ah>
	mWrite <"*************** SYED ZAIN HAIDER *****************",0dh,0ah>
	mWrite <"*",0dh,0ah>
	mWrite <"***************  SHAHAN KHALID  *****************",0dh,0ah>
	mWrite <"*",0dh,0ah>
	mov eax, 3000
	call delay
ret
Intro ENDP

GameWon PROC
	call UpdateHighScore
	mWrite <"",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"******************  YAYY!  *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"****************  YOU WON!  ******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***************** LIVES: ",0>
	movzx eax,lives
    call writeDec
	mWrite <" *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***************** SCORE: ",0>
	movzx eax,score
    call writeDec
	mWrite <" *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"************** HIGH SCORE: ",0>
	movzx eax,highScore
    call writeDec
	mWrite <" ****************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***** PRESS ENTER TO GO TO THE MAIN MENU *****",0dh,0ah>
ret
GameWon ENDP

GameLost PROC
	call UpdateHighScore
	mWrite <"",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"******************  OPPS!  *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"****************  YOU LOST  ******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***************** LIVES: 0 *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***************** SCORE: ",0>
	movzx eax,score
    call writeDec
	mWrite <" *******************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"************** HIGH SCORE: ",0>
	movzx eax,highScore
    call writeDec
	mWrite <" ****************",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"",0dh,0ah>
	mWrite <"***** PRESS ENTER TO GO TO THE MAIN MENU *****",0dh,0ah>
ret
GameLost ENDP

DisplayMainMenu PROC
	mWrite <"SELECT ANY OPTION",0dh,0dh,0ah,0ah>
	mWrite <" 1-QUICK PLAY",0dh,0ah>
	mWrite <" 2-INSTRUCTIONS",0dh,0ah>
	mWrite <" 3-SETTING",0dh,0ah>
    mWrite <" 4-HIGH SCORE",0dh,0ah>
	mWrite <" 5-QUIT",0dh,0dh,0ah,0ah>
	mWrite <"ENTER CHOICE: ",0>
	mov eax,0
	call readdec
ret
DisplayMainMenu ENDP

UpdateHighScore PROC
		mov al, score
		cmp highScore,al
		jg notUpdate
		mov highScore,al
	notUpdate:
ret
UpdateHighScore ENDP


ReadHighScore PROC
	mWrite<"High Score: ",0>
    movzx eax,highScore
	call writeDec
    call crlf
ret
ReadHighScore ENDP

Quick_play PROC
	mov lives,3
	call clrscr
	mWrite <"****** WELCOME TO LEVEL 1 ******",0dh,0ah>
	mov eax, 350
	call delay
	call clrscr
	call level1

	cmp lives, 0
	je gameFinish

	call clrscr
	mWrite <"****** WELCOME TO LEVEL 2 ******",0dh,0ah>
	mov eax, 350
	call delay
	call clrscr
	call level2

	cmp lives, 0
	je gameFinish

	call clrscr
	mWrite <"****** WELCOME TO LEVEL 3 ******",0dh,0ah>
	mov eax, 350
	call delay
	call clrscr
	call level3


	call GameWon
	jmp next
	gameFinish:
	    call GameLost

	next:
ret
Quick_play ENDP

ChangeSettings PROC
	call clrscr
	mWrite <"SETTINGS:",0dh,0dh,0ah,0ah>
	mWrite <" 1-CHANGE COLOR",0dh,0dh,0ah,0ah>
	Again:
	mWrite <"ENTER CHOICE: ",0>
	
	mov eax,0
	call readdec
	
	cmp al,1
	jne next
	call ChangeColor
	jmp next1
	next:
	mWrite <"You enter Invalid number",0dh,0ah>
	mov eax,500
	call delay
	jmp Again
	
next1:
ret
ChangeSettings ENDP

ChangeColor PROC

	call clrscr
	mWrite <"FOLLOWING ARE THE COLOR OPTIONS:",0dh,0dh,0ah,0ah>
	mWrite <" 1-Blue",0dh,0ah," 2-White",0dh,0ah," 3-Green",0dh,0ah>
	mWrite <" 4-Red",0dh,0ah," 5-Magenta",0dh,0ah," 6-Yellow",0dh,0ah>
	mWrite <" 7-Cyan",0dh,0ah," 8-Brown",0dh,0dh,0ah,0ah>
	mWrite <"SELECT COLOR: ",0>
	mov eax,0
	call readdec
	
	cmp al,1
	jne next
	mov eax,blue
	call settextcolor
	jmp quit
	
next:
	cmp al,2
	jne next1
	mov eax,white
	call settextcolor
	jmp quit
	
next1:
	cmp al,3
	jne next2
	mov eax,green
	call settextcolor
	jmp quit
	
next2:
	cmp al,4
	jne next3
	mov eax,red
	call settextcolor
	jmp quit
	
next3:
	cmp al,5
	jne next4
	mov eax,magenta
	call settextcolor
	jmp quit
	
next4:
	cmp al,6
	jne next5
	mov eax,yellow
	call settextcolor
	jmp quit
	
next5:
	cmp al,7
	jne next6
	mov eax,cyan
	call settextcolor
	jmp quit
	
next6:
	cmp al,8
	jne next7
	mov eax,brown
	call settextcolor
	jmp quit
next7:
	mWrite <"You Enter Invalid Number",0dh,0ah>
quit:

ret
ChangeColor ENDP


level1 PROC
whileloop:
    cmp lives,0		;end condition
	je quit

	mWrite <"****** LEVEL 1 *******",0dh,0ah>
	mWrite <"Lives: ",0>
    movzx eax,lives
    call writeDec
    mWrite<"     Score: ",0>
    movzx eax,score
    call writeDec
	call crlf
	call crlf

	mov edx,offset file_L1
	call read_file
	call crlf

	mov edx,offset str1     ;"Enter Word"
	call writestring

	mov edx,offset input
    mov ecx,9
    call ReadString

	mov i,0					;to track start of next word in word_list_L1
	mov edx,i
	mov j,-1				;to track arr_L1
	mov ecx, 5				;as level 1 has max 5 possible words

	l1:
		mov ecxTracker, ecx
		inc j
		mov ebx,j
	    mov al,arr_L1[ebx]
	    cmp al,1
	    je findWord
		INVOKE str_length, ADDR word_list_l1[edx]
		jmp next_l1
		findWord:
			INVOKE str_length, ADDR word_list_l1[edx]
			cld
			mov esi, offset input
			mov edi, offset word_list_l1
			add edi, edx
			mov ecx, eax			;length of word to compare
			repe cmpsb
			jz found
			jmp next_l1
		found:
			mWrite <"Your entered word found",0dh,0ah>
			inc score
			mov arr_L1[ebx],0	
			jmp find_next_word
		next_l1:		;FOR NOT FOUND
			inc i
			add i,eax
			mov edx,i
			mov ecx, ecxTracker
	loop l1

	mWrite<"Your entered word not found!",0dh,0ah>
    dec lives

	find_next_word:
		mov eax,500
		call delay
		call clrscr
		mov al,score
		cmp al,5
		jl whileloop

quit:
ret
level1 ENDP



level2 PROC
whileloop:
    cmp lives,0
	je quit

	mWrite <"****** LEVEL 2 *******",0dh,0ah>
	mWrite <"Lives: ",0>
    movzx eax,lives
    call writeDec
    mWrite<"     Score: ",0>
    movzx eax,score
    call writeDec
	call crlf
	call crlf

	mov edx,offset file_L2
	call read_file
	call crlf

	mov edx,offset str1
	call writestring

	mov edx,offset input
    mov ecx,9
    call ReadString

	mov i,0
	mov edx,i
	mov j,-1
	mov ecx, 7

	l1:
		mov ecxTracker, ecx
		inc j
		mov ebx,j
	    mov al,arr_L2[ebx]
	    cmp al,1
	    je findWord
		INVOKE str_length, ADDR word_list_l2[edx]
		jmp next_l1
		findWord:
			INVOKE str_length, ADDR word_list_l2[edx]
			cld
			mov esi, offset input
			mov edi, offset word_list_l2
			add edi, edx
			mov ecx,eax
			repe cmpsb
			jz found
			jmp next_l1
		found:
			mWrite <"Your entered word found",0dh,0ah>
			inc score
			mov arr_L2[ebx],0	
			jmp find_next_word
		next_l1:
			inc i
			add i,eax
			mov edx,i

			mov ecx, ecxTracker
	loop l1

	mWrite<"Your entered word not found!",0dh,0ah>
    dec lives

	find_next_word:
		mov eax,500
		call delay
		call clrscr
		mov al,score
		cmp al,10
		jl whileloop

quit:
ret
level2 ENDP



level3 PROC
whileloop:
    cmp lives,0
	je quit

	mWrite <"****** LEVEL 3 *******",0dh,0ah>
	mWrite <"Lives: ",0>
    movzx eax,lives
    call writeDec
    mWrite<"     Score: ",0>
    movzx eax,score
    call writeDec
	call crlf
	call crlf

	mov edx,offset file_L3
	call read_file
	call crlf

	mov edx,offset str1
	call writestring

	mov edx,offset input
    mov ecx,9
    call ReadString

	mov i,0
	mov edx,i
	mov j,-1
	mov ecx, 8

	l1:
		mov ecxTracker, ecx
		inc j
		mov ebx,j
	    mov al,arr_L3[ebx]
	    cmp al,1
	    je findWord
		INVOKE str_length, ADDR word_list_l3[edx]
		jmp next_l1
		findWord:
			INVOKE str_length, ADDR word_list_l3[edx]
			cld
			mov esi, offset input
			mov edi, offset word_list_l3
			add edi, edx
			mov ecx,eax
			repe cmpsb
			jz found
			jmp next_l1
		found:
			mWrite <"Your entered word found",0dh,0ah>
			inc score
			mov arr_L3[ebx],0	
			jmp find_next_word
		next_l1:
			inc i
			add i,eax
			mov edx,i

			mov ecx, ecxTracker
	loop l1

	mWrite<"Your entered word not found!",0dh,0ah>
    dec lives

	find_next_word:
		mov eax,500
		call delay
		call clrscr
		mov al,score
		cmp al,15
		jl whileloop

quit:
ret
level3 ENDP


read_file PROC

	call OpenInputFile
	mov fileHandle,eax
	; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE	; error opening file?
	jne file_ok						; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit ; and quit
file_ok:
	; Read the file into a buffer.
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size			; error reading?
	mWrite "Error reading file. "	; yes: show error message
	call WriteWindowsMsg
	jmp close_file
check_buffer_size:
	cmp eax,BUFFER_SIZE				; buffer large enough?
	jb buf_size_ok					; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp quit						; and quit
buf_size_ok:
	mov buffer[eax],0				; insert null terminator
	mov edx,OFFSET buffer			; display the buffer
	call WriteString
	call Crlf
close_file:
	mov eax,fileHandle
	call CloseFile
quit:
ret
read_file ENDP

DisplayInstructions PROC
	call clrscr
	mov edx,offset file_instructions
	call read_file
	call crlf
ret
DisplayInstructions ENDP

END main
