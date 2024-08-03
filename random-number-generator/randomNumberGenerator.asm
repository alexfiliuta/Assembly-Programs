.ORIG x3000

MAIN
        AND R0, R0, #0
        AND R1, R1, #0
        AND R2, R2, #0
        AND R3, R3, #0
        AND R4, R4, #0
        AND R5, R5, #0
        AND R6, R6, #0

GET_A   LD R1, READ_NUMBERS_PTR
        JSRR R1             ; R3 contains a
        ADD R3, R2, #0

GET_B   LD R1, READ_NUMBERS_PTR
        JSRR R1             ; R4 contains b
        ADD R4, R2, #0

GET_M   LD R1, READ_NUMBERS_PTR
        JSRR R1             ; R5 contains m
        ADD R5, R2, #0

GET_X   LD R1, READ_X_PTR
        JSRR R1             ; R6 contains X0

GET_N   LD R1, READ_NUMBERS_PTR
        JSRR R1             ; R2 contains n
        ADD R2, R2, #0
        BRz END_PRG

CALC_X  LD R1, MULTI_PTR
        JSRR R1             ; X*a
        ADD R6, R6, R4      ; +b
        LD R1, MODULO_PTR
        JSRR R1             ; 'mod' m
        
        LD R1 PRINT_X_PTR
        JSRR R1
        ADD R2, R2, #-1
        BRp CALC_X 
        
END_PRG HALT

ASCII_LINE_FEED  .FILL #10      
READ_NUMBERS_PTR .FILL x3100
MULTI_PTR        .FILL x3200
MODULO_PTR       .FILL x3300
READ_X_PTR       .FILL x3400
PRINT_X_PTR      .FILL x3500
    
        .END
END_MAIN


;=====================================================
; Description: reads a, b or m
; - parameters: R0: contains the input
;               R1: operates on the input
; - post condition: R2: contains the number
;=====================================================
READ_NUMBERS
            .ORIG x3100
            ST R6 NUMBERS_BACKUP_R6
            AND R0, R0, #0
            AND R1, R1, #0
            AND R2, R2, #0
            
READ_INP    GETC                ; read digit
            OUT
            LD R1, NEWLINE_OFFSET 
            ADD R1, R1, R0      ; check for newline
            BRz READ_INP        ; if newline, end input
            LD R1, SPACE_OFFSET
            ADD R1, R1, R0      ; check for space
            BRz READ_INP        ; if space, end input
    
ADD_DIG     LD R1, FROM_ASCII_TO_DEC
            ADD R1, R1, R0      ; convert from ASCII and store
            ADD R2, R2, R1
            
            GETC
            OUT
            LD R1, NEWLINE_OFFSET 
            ADD R1, R1, R0      ; check for newline
            BRz END_INPUT       ; if newline, end input
            LD R1, SPACE_OFFSET
            ADD R1, R1, R0      ; check for space
            BRz END_INPUT       ; if space, end input
            
            AND R1, R1, #0  
            ADD R1, R1, #9
            AND R6, R6, #0
            ADD R6, R6, R2
SHIFT       ADD R2, R2, R6      ; shift the number to the left
            ADD R1, R1, #-1
            BRp SHIFT
            BRnzp ADD_DIG 
  
END_INPUT   LD R6 NUMBERS_BACKUP_R6
            RET                 ; returns to the main program

NUMBERS_BACKUP_R6 .BLKW #1

NEWLINE_OFFSET      .FILL #-10
SPACE_OFFSET        .FILL #-32
FROM_ASCII_TO_DEC   .FILL #-48
            .END
END_READ_NUMBERS

;=====================================================
; Description: calculates the multiplication between R3 and R6
; - parameters: R6: Xn
;               R3: a
;               R1: counter
; - post condition: R6: the result
;=====================================================
.ORIG x3200
MULTI
        AND R1, R1, #0      
        ADD R1, R3, #0
        AND R0, R0, #0
        
LOOP    ADD R0, R0, R6
        ADD R1, R1, #-1
        BRp LOOP
        
        ADD R6, R0, #0
RET
.END 
END_MULTI

;=====================================================
; Description: calculates X0*a+b 'mod' m
; - parameters: R6: X0*a+b
;               R5: m
; - post condition: R6: the result
;=====================================================
.ORIG x3300
MODULO
        NOT R0, R5      ; gets the negative of m
        ADD R0, R0, #1

LOOP_MD ADD R6, R6, R0 
        BRzp LOOP_MD
        ADD R6, R6, R5
RET
.END 
END_MODULO

;=====================================================
; Description: reads X
; - parameters: R0: contains the input
;               R1: operates on the input
; - post condition: R6: contains the X
;=====================================================
READ_X
            .ORIG x3400
            
            AND R1, R1, #0
            AND R6, R6, #0
            
STARTL      GETC                ; read digit
            OUT
            LD R1, NEWLINE
            ADD R1, R1, R0      ; check for newline
            BRz END_INPUT_Z     ; if newline, end input
            
            LD R1, ASCII_0
            ADD R1, R1, R0      ; lower bound digits
            BRn CHECK_UPPER 
            LD R1, ASCII_9
            ADD R1, R1, R0      ; upper bound digits
            BRp CHECK_UPPER   
            
            LD R1, ASCII_0
            ADD R1, R1, R0      ; convert digit from ASCII and store
            ADD R6, R6, R1      ; in R6
            BRnzp STARTL
            
CHECK_UPPER LD R1, ASCII_UPPERa
            ADD R1, R1, R0      ; lower bound digits
            BRn CHECK_LOWER 
            LD R1, ASCII_UPPERz
            ADD R1, R1, R0      ; upper bound digits
            BRp CHECK_LOWER 
            
            LD R1, ASCII_UPPERa
            ADD R1, R1, R0      ; convert uppercase from ASCII and store
            ADD R6, R6, R1      ; in R6
            BRnzp STARTL
            
CHECK_LOWER LD R1, ASCII_a
            ADD R1, R1, R0      ; lower bound letter
            BRn STARTL
            LD R1, ASCII_z
            ADD R1, R1, R0      ; upper bound letter
            BRp STARTL
            
            LD R1, ASCII_a
            ADD R1, R1, R0      ; convert letter from ASCII and store
            ADD R6, R6, R1      ; in R6
            BRnzp STARTL
  
END_INPUT_Z RET                 ; returns to the main program

NEWLINE             .FILL #-10
ASCII_0             .FILL #-48
ASCII_9             .FILL #-57
ASCII_UPPERa        .FILL #-65
ASCII_UPPERz        .FILL #-90
ASCII_a             .FILL #-97
ASCII_z             .FILL #-122
            .END
END_READ_X

;=====================================================
; Description: prints the hexadecimal representation of R6
; - parameters: R0: prints the number 
;               R1: to save and load after
;               R2: to save and load after TO STORE CAT
;               R3: save and load after TO STORE REST
;               R4:save and load
;               R5:
;               R6: contains the number
;=====================================================
PRINT_X
            .ORIG x3500
            ST R2 BACKUP_R2  
            ST R3 BACKUP_R3
            ST R4 BACKUP_R4
            ST R5 BACKUP_R5
            ST R6 BACKUP_R6
            
            AND R0, R0, #0      ; Clear registers used
            AND R1, R1, #0
            AND R2, R2, #0
            AND R3, R3, #0
            
            LD R0, ASCII_x      ; ASCII value for 'x'
            OUT                 ; Output 'x' to console

            ADD R1, R6, #0      ; the number copied into R1
            AND R6, R6, #0      ; R6 cleared, becomes counter
            LD R5, EMPTY
            LD R2 DEC_2_HEX     ; R2 used to subtract
            
TRANSFORM   ADD R3, R3, #1      ; R3 stores the quotient
            ADD R1, R1, R2
            BRzp TRANSFORM
            LD R2 DEC_2_POS_HEX
            ADD R1, R1, R2
            LD R2 DEC_2_HEX
            
            ADD R1, R1, #-10
            BRn IS_NUMBER
            LD R4 ASCII_A_10    ; conversed to letter ASCII
            ADD R1, R1, R4
            BRnzp ADDSTACK

IS_NUMBER   LD R4, ASCII_0_10   ; conversed to number ASCII
            ADD R1, R1, R4               

ADDSTACK    STR R1, R5, #0
            ADD R5, R5, #-1
            ADD R6, R6 #1

            ADD R3, R3, #-1
            ADD R1, R3, #0
            BRz EXIT
            AND R3, R3, #0
            BRnzp TRANSFORM
    
    
EXIT        ADD R5, R5, #1
            LDR R0, R5, #0
            OUT
            ADD R6, R6, #-1
            BRp EXIT
            
            LD R0, ASCII_NEWLINE_FEED
            OUT
            
            LD R2 BACKUP_R2
            LD R3 BACKUP_R3
            LD R4 BACKUP_R4
            LD R5 BACKUP_R5
            LD R6 BACKUP_R6
            RET
 
BACKUP_R2 .BLKW #1
BACKUP_R3 .BLKW #1
BACKUP_R4 .BLKW #1
BACKUP_R5 .BLKW #1
BACKUP_R6 .BLKW #1

ASCII_NEWLINE_FEED  .FILL #10
EMPTY               .FILL x4000
DEC_2_POS_HEX       .FILL #16
DEC_2_HEX           .FILL #-16
ASCII_A_10          .FILL #65
ASCII_0_10          .FILL #58
ASCII_x             .FILL #120
            .END
END_PRINT_X