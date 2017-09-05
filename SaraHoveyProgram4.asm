TITLE Program Template     (template.asm)

; Author: Sara Hovey
; 
; 
;             Date: 05/14/17
; Description: The user is instructed to enter the number of composite numbers
;they want displayed, with limits of 1 and 400, inclusive. There is data
;validation, so if they enter an invalid number, they will be re-prompted
;The program then calculates all composite numbers until the nth number
;The results are displayed at 10 per line, 3 spaces between each number

;This lab uses global variables
INCLUDE Irvine32.inc

;Boundaries for range-checking
LOWER = 1
UPPER = 400

.data

;Values from the user
input	DWORD	?

;Other
temp		DWORD	?
inner		DWORD	?
outer		DWORD	?
innerCmp	DWORD	?
outerCmp	DWORD	?
numsWritten	DWORD	0
currentNum	DWORD	?
spaceCount	DWORD	?
divNum		DWORD	2

;Calculated values


;Text output
intro_1		BYTE	"Name: Sara Hovey, CS271 Program 4", 0
ask			BYTE	"Please enter the number of composites you would like" , 0

bye			BYTE	"Goodbye, ", 0
error_1		BYTE	"Please enter a number between 1 and 400" , 0
quit		BYTE	"Press any key to quit. See you next time!", 0
space		BYTE	"   ", 0

.code
main PROC
	call	intro
	call	calc
	call	goodbye

main ENDP

intro PROC
;Display title and name
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;Ask for data
	mov		edx, OFFSET ask
	call	WriteString
	call	CrLf
prompt:
	

;get data
	call	ReadInt
	mov		input, eax

;Compare to upper limit
	cmp		eax, UPPER
	jg		invalid
;Compare to lower limit
	cmp		eax, LOWER
	jl		invalid

;If neither of the above conditions are met, jump to valid
	jmp valid

;validation
invalid:
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		prompt

valid:
	
	
ret
intro ENDP

calc PROC

	;Start at 3, so that when currentNum is incremented in the loop, it begins at 4, the first composite
	mov		eax, 3
	mov		currentNum, eax
	
	;loop counter
	mov		ecx, input

loop1:
	inc		currentNum	;Increment the current, 1st iteration will start with 
	mov		divNum, 2

;"inner" loop
loop2:
	mov		edx, 0			;Prep for div
	mov		ebx, divNum		;divNum is incremented over each loop, so currentNum is divided by everything between 2 and itself
	mov		eax, currentNum
	div		ebx	
	cmp		edx, 0			;Compare remainder to 0, composite check
	je		printPrep
	inc		divNum			;divNum++

	;Loop until divNum >= input, then go back to the outer loop
	mov		eax, currentNum
	cmp		eax, divNum
	jle		loop1
	jmp		loop2

;Prints composite numbers, 10 per line
printPrep:
	mov		eax, spaceCount
	cmp		spaceCount, 10
	jge		spaceTime

print:
	mov		eax, currentNum
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	inc		spaceCount	;for counting spaces
	inc		numsWritten
	loop	loop1

	jmp		goodbye

spaceTime:
	;make a space, reset SpaceCount
	call	CrLf
	mov		spaceCount, 0
	jmp		print

ret
calc ENDP

goodbye PROC
	call	CrLf
	mov		edx, OFFSET bye
	call	WriteString
	call	CrLf
	mov		edx, OFFSET quit
	call	WriteString
	call	ReadInt
	exit
goodbye ENDP

END main
