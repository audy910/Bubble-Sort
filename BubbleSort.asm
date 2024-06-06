
.ORIG X3000
NUM_ARRAY   .BLKW 8           ; Array to store 8 numbers
NUM_LIMIT   .FILL 8
SAVE_NUM    .BLKW 1

START 
	LEA R6, NUM_ARRAY      ; Initialize pointer to the beginning of the array
	AND R7, R7, X0
	LEA R7, NUM_LIMIT      ; Load the count limit (8)

MAIN_LOOP
	JSR GET_NUMBER         ; Call subroutine to get a number
STORE 
	LD R2, SAVE_NUM   
	STR R2, R6, X0        ; Store the number in the array
	ADD R6, R6, #1        ; Increment the array pointer
	LD R7, NUM_LIMIT
	ADD R7, R7, #-1       ; Decrement the count
	ST R7, NUM_LIMIT 
	BRp MAIN_LOOP         ; Repeat until 8 numbers are collected

	LEA R0, DONE_MSG      ; Load the done message string to R0
	PUTS                  ; Display the done message
SORT
	LEA R0, NUM_ARRAY     ; Load address of the array into R0
        LDR R1, R0, #0   ; Load the number of elements (n) into R1
        ADD R1, R1, #-1  ; R1 = n - 1

OUTER_LOOP
        ADD R2, R1, #0   ; Initialize R2 with the value of R1 (outer loop counter)
	    ADD R3, R0, #1   ; Initialize R3 with address of the first element

INNER_LOOP
        ADD R4, R3, #1   ; Initialize R4 with the current next element

COMPARE
        LDR R5, R3, #0   ; Load element at R4 into R5
        LDR R6, R4, #0   ; Load next element into R6
	NOT R5, R5
	ADD R5, R5, x0
	ADD R6, R6, R5
        BRzp NO_SWAP     ; If R5 <= R6, no swap needed

        ; Swap elements
        STR R6, R4, #0   ; Store R6 (next element) at current position
        STR R5, R4, #1   ; Store R5 (current element) at next position

NO_SWAP
        ADD R3, R3, #1   ; Move to the next element
        ADD R2, R2, #-1  ; Decrease inner loop counter
        BRp INNER_LOOP   ; Repeat inner loop if counter > 0

        ADD R1, R1, #-1  ; Decrease outer loop counter
        BRp OUTER_LOOP   ; Repeat outer loop if counter > 0
    ; Print sorted numbers

PRINT_LOOP
    
	LEA R6, NUM_ARRAY      ; Initialize pointer to the beginning of the array
    
	AND R7, R7, X0         ; Clear R7
    
	ADD R7, R7, #8         ; R7 = 8 (number of elements)

PRINT_NEXT
    
	LDR R0, R6, #0         ; Load the number from the array
    
	JSR PRINT_NUMBER       ; Print the number
    
	ADD R6, R6, #1         ; Increment the array pointer
    
	ADD R7, R7, #-1        ; Decrement the counter
    
	BRp PRINT_NEXT         ; Repeat until all numbers are printed

    
	HALT                   ; Stop execution

; Subroutine to print a number (R0) as a decimal

PRINT_NUMBER
    
	AND R1, R1, #0         ; Clear R1
    
	ADD R1, R0, #0         ; Copy the number to R1
    
	ADD R1, R1, #15        ; Convert to ASCII (adding 48)
  
  	ADD R1, R1, #15 
	ADD R1, R1, #15 
	ADD R1, R1, #3
	OUT                    ; Output the character
    
	RET                    ; Return from subroutine



GET_NUMBER	
	LEA R0, PROMPT  ;LOAD PROMPT TO R0	
	PUTS            ;DISPLAY PROMPT
	;first input validation
	GETC            ;GET VALUE OF ASCII VALUE INPUT IN R0
	ADD R4, R0, X0	
	AND R5, R5, X0  ;CLEAR R5

	ADD R5, R5, #15 ;LOAD #-57 INTO R5 W/ 2'S COM
	ADD R5, R5, #15	
	ADD R5, R5, #15
	ADD R5, R5, #12
	NOT R5, R5
	ADD R5, R5, X1
	ADD R5, R5, R4  ;R5 = INPUT -R5
	BRp ERROR       ;input > ascii "9"
	AND R5, R5, X0  ;CLEAR R5
	ADD R5, R5, #15 ;load #-48 to r5 w/ 2's comp
	ADD R5, R5, #15	
	ADD R5, R5, #15
	ADD R5, R5, #3
	NOT R5, R5
	ADD R5, R5, X1
	ADD R5, R5, R4  ;R5 = INPUT - R5
	BRn ERROR       ;INPUT < 0	
	ADD R1, R5, X0  ;COPY R5 TO R1: R1 = NUMERIC VAL ENTERED
	LEA R0, NUM     ;LOAD NUM CHARACTERS TO R0
	ADD R3, R5, X0
	ADD R3, R3, X0  ;R3 = 0 SET UP ZERO BRANCHING
MIRROR1             ;LOOP LABEL
    BRz DISPM1      ;IF = 0 -> JUMP TO DISPM1
    ADD R0, R0, #2  ;R0 += #2, 11 CHARACTER FOR NUMBERS INCLUDING NULL TERMINATED
    ADD R3, R3, #-1 ;R3 = OFFSET (i--)
    BR MIRROR1
DISPM1
    PUTS            ; SHOW FIRST NUM ON CONSOLE
    ;SECOND INPUT VALIDATION
    GETC
    ADD R4, R0, X0  ;COPY INPUT TO R4
    AND R5, R5, X0  ;CLEAR R5

    ADD R5, R5, #15 ;LOAD #-57 INTO R5 W/ 2'S COM
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #12
    NOT R5, R5
    ADD R5, R5, X1

    ADD R5, R5, R4  ;R5 = INPUT - R5
    BRp CHKENTR     ;INPUT > 9, CHECK IF ENTER PRESSES
    AND R5, R5, X0  ;CLEAR R5

    ADD R5, R5, #15 ;load #-48 to r5 w/ 2's comp
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #3
    NOT R5, R5
    ADD R5, R5, X1

    ADD R5, R5, R4  ;R5 = INPUT - R5
    BRn CHKENTR     ; INPUT < 0, CHECK IF ENTER IS PRESSED
    ADD R2, R5, X0  ; COPY R5 TO R2, R2 NOW = NUMERICA VALUE ENTERED

    LEA R0, NUM     ;LOAD NUM CHARACTERS TO R0
    ADD R3, R5, X0
    ADD R3, R3, X0  ;BEGIN LOOP AT 0
MIRROR2 
    BRz DISPM2      ; @ 0 -> DISPM2
    ADD R0, R0, #2
    ADD R3, R3, #-1
    BR MIRROR2
DISPM2
    PUTS            ;SHOW SECOND DIGIT
    BR LOOP1

CHKENTR 
    AND R5, R5, X0
    ADD R5, R5, XA  ;LOAD XA TO R5 (ASCII NEW LINE)
    NOT R5, R5
    ADD R5, R5, X1
    ADD R5, R4, R5  ;R5 = INPUT - R5
    BRnp ERROR      ;CHARACTER NOT 0-9 PRESSED
    ADD R2, R1, X0

LOOP1 
    ADD R1, R1, X0  ;CHECK VAL OF TESNS
    BRz PREPM       ;NO LONGER 10S PLACE
    BRn ERROR       ;A NEG IN 10S
    ADD R2, R2, XA  ;ADD 10 TO R2 -- WHERE WE STORE ONES DIGIT
    NOT R1, R1
    ADD R1, R1, X2
    NOT R1, R1
    ADD R1, R1, X1  ;R2 = R2 - 1
    BR LOOP1

PREPM 
    LEA R0, LF      
    PUTS            ;SHOW NEW LINE
    ST R2, SAVE_NUM
    BR STORE        ;CONTINUE MAIN PROGRAM


ERROR 
    LEA R0, LF
    PUTS 
    HALT

PROMPT  .STRINGZ	"Enter a number and ENTER or two numbers 0-100: " 
ERRSTR  .STRINGZ	"Input was not an integer. Exiting..."
LF      .STRINGZ	"\n"
ERRNUM  .STRINGZ    "Invalid index entered. Try Again. "
DONE_MSG    .STRINGZ "All numbers collected.\n"


;define nums to handle double digit input
NUM     .STRINGZ	"0"
        .STRINGZ	"1"
        .STRINGZ	"2"
        .STRINGZ	"3"
        .STRINGZ	"4"
        .STRINGZ	"5"
        .STRINGZ	"6"
        .STRINGZ	"7"
        .STRINGZ	"8"
        .STRINGZ	"9"




.END