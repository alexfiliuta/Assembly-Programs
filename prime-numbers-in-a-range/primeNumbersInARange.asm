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
        JSRR R1             ; R5 contains a
        ADD R5, R2, #0

GET_B   LD R1, READ_NUMBERS_PTR
        JSRR R1             ; R6 contains b
        ADD R6, R2, #0


isPRIME ADD R0, R5, #0
        LD R1, PRINT_X_PTR  ; print the first number
        JSRR R1
        
        ADD R0, R5, #-2     ; if two prime
        BRz PRT_P
                            
        AND R0, R5, #1      ; if even not prime
        BRz PRT_EVN
        
        ADD R0, R5, #-3     ; if 3 not prime
        BRz PRT_P
        
        LD R1, SQRT_PTR     ; if odd and > 3 get the smallest sqrt bigger than a
        JSRR R1
        ADD R4, R0, #0      ; add sqrt in r4
        LD R2, DIV_3        ; store 3 (first div) in R2
        ADD R3, R5, #0      ; add a in R3
        
MOD_CCK LD R1, MODULO_PTR   ; check the mod of a with the div
        JSRR R1
        ADD R0, R0, #0
        BRz PRT_ODD
        
        ADD R2, R2, #2
        NOT R0, R2
        ADD R0, R0, #1
        ADD R0, R0, R4
        BRzp MOD_CCK
        BRnzp PRT_P
        
        
PRT_EVN LEA R0, EVEN_MESSAGE
        PUTS
        BRnzp NXT_N

PRT_P   LEA R0, P_MESSAGE
        PUTS
        BRnzp NXT_N
        
PRT_ODD LEA R0, ODD_MESSAGE
        PUTS
        LD R0, PRINT_DIV_PTR
        JSRR R0

NXT_N   ADD R3, R5, #0
        NOT R4, R6
        ADD R4, R4, #1
        ADD R3, R3, R4
        BRz END_PRG
        BRp DES_PRG
        
ASC_PRG ADD R5, R5 #1
        LD R0, ASCII_LINE_FEED 
        OUT
        BRnzp isPRIME
        
DES_PRG ADD R5, R5 #-1
        LD R0, ASCII_LINE_FEED 
        OUT
        BRnzp isPRIME
        
END_PRG LD R0, ASCII_LINE_FEED 
        OUT
        HALT

DIV_3            .FILL #3
ASCII_LINE_FEED  .FILL #10      
READ_NUMBERS_PTR .FILL x3100
PRINT_X_PTR    .FILL x3200
MODULO_PTR       .FILL x3300
SQRT_PTR         .FILL x3400
PRINT_DIV_PTR    .FILL x3500

P_MESSAGE    .STRINGZ " is a prime number"
EVEN_MESSAGE .STRINGZ " is not a prime number as it is divisible by 2"
ODD_MESSAGE  .STRINGZ " is not a prime number as it is divisible by "    
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

PRINT_X
            .ORIG x3200
            ST R2 BACKUP_R2  
            ST R3 BACKUP_R3
            ST R4 BACKUP_R4
            ST R5 BACKUP_R5
            ST R6 BACKUP_R6
            
            AND R1, R1, #0      ; Clear registers used
            AND R2, R2, #0
            AND R3, R3, #0
            
            ADD R1, R0, #0      ; the number copied into R1
            AND R6, R6, #0      ; R6 cleared, becomes counter
            LD R5, EMPTY
            LD R2 DECA          ; R2 used to subtract
            
TRANSFORM   ADD R3, R3, #1      ; R3 stores the quotient
            ADD R1, R1, R2
            BRzp TRANSFORM
            LD R2 DECA_P
            ADD R1, R1, R2
            LD R2 DECA

            LD R4, ASCII_0   ; conversed to number ASCII
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
DECA_P              .FILL #10
DECA                .FILL #-10
ASCII_0             .FILL #48
            .END
END_PRINT_X

;=====================================================
; Description: calculates a 'mod' div
; - parameters: R3: a
;               R2: div
; - post condition: R0: the result
;=====================================================
.ORIG x3300
MODULO
        ST R3 BACKUP_M_IN_R3
        
        NOT R0, R2      ; gets the negative of m
        ADD R0, R0, #1
        
LOOP_MD ADD R3, R3, R0 
        BRp LOOP_MD
        
        ADD R0, R3, #0
        LD R3 BACKUP_M_IN_R3 
        RET

BACKUP_M_IN_R3  .BLKW #1

.END 
END_MODULO

;=====================================================
; Description: calculates the smallest sqrt bigger than R5
; - parameters: R0: sqrt
;               R1: sqrt^2 
; - post condition: R0: sqrt
;=====================================================
.ORIG x3400
SQRT
    ST R2 MUL_BACKUP_R2
    
    AND R0, R0, #0
    ADD R0, R0, #1
CLC ADD R0, R0, #2
    
    AND R1, R1, #0
    ADD R2, R0, #0
LP  BRnz M_R
    ADD R1, R1, R0
    ADD R2, R2, #-1
    BRnzp LP
    
M_R NOT R1, R1
    ADD R1, R1 #1
    ADD R1, R1, R5
    BRp CLC
    
    LD R2 MUL_BACKUP_R2
    RET
    
MUL_BACKUP_R2 .BLKW #1 
    .END
END_SQRT

;=====================================================
; Description: Prints the divisor from R2
; - parameters: R2: the number to be printed
;               R3: recursively subtracts 10 
;                R4: counter of digits
;                R5: pointer of stack
;                R6: counter in stack
;=====================================================
PRINT_DIV
            .ORIG x3500
            ST R2 BACKUP_R2_N  
            ST R3 BACKUP_R3_N
            ST R4 BACKUP_R4_N
            ST R5 BACKUP_R5_N
            ST R6 BACKUP_R6_N
            
            AND R3, R3, #0
            AND R6, R6, #0      ; R6 cleared, becomes counter
            AND R4, R4 #0
            LD R5, EMPTY_ST
            LD R3, DECA_NR      ; R3 used to subtract
            
            
EDIT_DIV    ADD R4, R4, #1
            ADD R2, R2, R3
            BRzp EDIT_DIV
            
            
R2_ASCII    LD R3, R2_TRANSFORM
            ADD R2, R2, R3
            
PUTSTACK    STR R2, R5, #0
            ADD R5, R5, #-1
            ADD R6, R6 #1

            ADD R2, R4, #-1
            BRz EXIT_ST
            AND R4, R4, #0
            LD R3, DECA_NR
            BRnzp EDIT_DIV
    
EXIT_ST     ADD R5, R5, #1
            LDR R0, R5, #0
            OUT
            ADD R6, R6, #-1
            BRp EXIT_ST
            
            LD R2 BACKUP_R2_N
            LD R3 BACKUP_R3_N
            LD R4 BACKUP_R4_N
            LD R5 BACKUP_R5_N
            LD R6 BACKUP_R6_N
            RET
 
BACKUP_R2_N .BLKW #1
BACKUP_R3_N .BLKW #1
BACKUP_R4_N .BLKW #1
BACKUP_R5_N .BLKW #1
BACKUP_R6_N .BLKW #1

EMPTY_ST            .FILL x4000
DECA_NR             .FILL #-10
R2_TRANSFORM        .FILL #58
            .END
END_PRINT_DIV