; ETA-3400 Tiny BASIC ROM.
;
; Generated by disassembling ROM image using the f9dasm program.
; Adapted to the crasm assembler. Note that I do not own an ETA-3400
; and have no way of testing it but I have confirmed that it produces
; the same binary output as the Heathkit ROMs.
;
; Tiny BASIC was implemented as a (target dependent) virtual machine
; running a (portable) interpreted language. The disassembled source
; code here does not reflect this and is not particularly meaningful
; (e.g. many of the instructions are actually data). Apparently the
; original source for for the 6800 version of Tiny BASIC has been
; lost.
;
; See:
;   http://www.ittybittycomputers.com/IttyBitty/TinyBasic
;   https://github.com/Arakula/f9dasm
;   https://github.com/colinbourassa/crasm
;
; Jeff Tranter <tranter@pobox.com>

; LOCATION   SIGNIFICANCE
; 0000-000F  Not used by Tiny BASIC.
; 0010-001F  Temporaries.
; 0020-0021  Lowest address of user program space.
; 0022-0023  Highest address of user program space.
; 0024-0025  Program end + stack reserve.
; 0026-0027  Top of GOSUB stack.
; 0028-002F  Interpreter parameters.
; 0030-007F  Input line buffer and Computation stack.
; 0080-0081  Random Number generator workspace.
; 0082-00B5  Variables A,B,...Z.
; 00B6-00C7  Interpreter temporaries.
; 0100-0FFF  Tiny BASIC user program space.

; 1C00       Cold start entry point.
; 1C03       Warm start entry point.
; 1C06       Character input routine.
; 1C09       Character output routine.
; 1C0C       Break test.
; 1C0F       Backspace code.
; 1C10       Line cancel code.
; 1C11       Pad character.
; 1C12       Tape mode enable flag. (HEX 80 = enabled)
; 1C13       Spare stack size.
; 1C14       Subroutine (PEEK) to read ony byte from RAM to B and A.
;            (address in X)
; 1C18       Subroutine (POKE) to store A and B into RAM at addess X.

        CPU     6800

;****************************************************
;* Used Labels                                      *
;****************************************************

M0000   EQU     $0000
M001C   EQU     $001C
M001D   EQU     $001D
M0020   EQU     $0020
M0021   EQU     $0021
M0022   EQU     $0022
M0024   EQU     $0024
M0025   EQU     $0025
M0026   EQU     $0026
M0027   EQU     $0027
M0028   EQU     $0028
M0029   EQU     $0029
M002A   EQU     $002A
M002B   EQU     $002B
M002C   EQU     $002C
M002D   EQU     $002D
M002E   EQU     $002E
M002F   EQU     $002F
M0030   EQU     $0030
M0047   EQU     $0047
M0049   EQU     $0049
M0050   EQU     $0050
M0080   EQU     $0080
M0083   EQU     $0083
M0099   EQU     $0099
M00A0   EQU     $00A0
M00B6   EQU     $00B6
M00B7   EQU     $00B7
M00B8   EQU     $00B8
M00B9   EQU     $00B9
M00BA   EQU     $00BA
M00BC   EQU     $00BC
M00BD   EQU     $00BD
M00BE   EQU     $00BE
M00BF   EQU     $00BF
M00C0   EQU     $00C0
M00C1   EQU     $00C1
M00C2   EQU     $00C2
M00C3   EQU     $00C3
M00C4   EQU     $00C4
M00E5   EQU     $00E5
M00EC   EQU     $00EC
M0100   EQU     $0100
M0905   EQU     $0905
M0B02   EQU     $0B02
M0B2F   EQU     $0B2F
M1311   EQU     $1311
M1C13   EQU     $1C13
M1C1D   EQU     $1C1D
M1CFF   EQU     $1CFF
M2048   EQU     $2048
M2493   EQU     $2493
M312A   EQU     $312A
M3134   EQU     $3134
M380A   EQU     $380A
M80A9   EQU     $80A9
M8454   EQU     $8454
M84BD   EQU     $84BD
ME010   EQU     $E010
ME013   EQU     $E013
ME014   EQU     $E014
ME015   EQU     $E015
ME150   EQU     $E150
MFFFF   EQU     $FFFF
Z0902   EQU     $0902
Z1618   EQU     $1618
SNDCHR  EQU     $1865
RCCHR   EQU     $18E1
Z1A80   EQU     $1A80
BREAK   EQU     $1B1F
Z1C15   EQU     $1C15
Z1C1F   EQU     $1C1F
Z1C71   EQU     $1C71
Z1D18   EQU     $1D18
Z1DD6   EQU     $1DD6
Z2203   EQU     $2203
Z2269   EQU     $2269
Z2299   EQU     $2299
Z2305   EQU     $2305
Z2346   EQU     $2346
Z23B9   EQU     $23B9
Z3814   EQU     $3814

;****************************************************
;* Program Code / Data Areas                        *
;****************************************************

        * =     $1C00

CV      JMP     COLD_S          ; Cold start vector
WV      JMP     WARM_S          ; Warm start vector
Z1C06   JMP     RCCHR           ; Input routine address
Z1C09   JMP     SNDCHR          ; Output routine address
Z1C0C   JMP     BREAK           ; Begin break routine

;
; Some codes
;
BSC     DB      $08             ; Backspace code
LSC     DB      $15             ; Line cancel code
PCC     DB      $83             ; Pad character
TMC     DB      $80             ; Tape mode control
        DB      $20             ; Spare Stack size.
;
; Code fragment for 'PEEK' and 'POKE'
;
PEEK    LDAA    0,X
        CLRB
M1C17   RTS

POKE    STAA    0,X
        RTS
;
; The following table contains the addresses for the ML handlers for the IL opcodes.
;
;SRVT     .word  IL_BBR               ; ($40-$5F) Backward Branch Relative
        DW      $1D98
;         .word  IL_FBR               ; ($60-$7F) Forward Branch Relative
        DW      $1D9B
;         .word  IL__BC               ; ($80-$9F) String Match Branch
;        DW      $1DEE
;         .word  IL__BV               ; ($A0-$BF) Branch if not Variable
;        DW      $1E12
;         .word  IL__BN               ; ($C0-$DF) Branch if not a Number
;        DW      $1E3B
;         .word  IL__BE               ; ($E0-$FF) Branch if not End of line
;        DW      $1E0B
;         .word  IL__NO               ; ($08) No Operation
;        DW      $1CFC
;         .word  IL__LB               ; ($09) Push Literal Byte onto Stack
;        DW      $1CD7
;         .word  IL__LN               ; ($0A) Push Literal Number
;        DW      $1CDB
;         .word  IL__DS               ; ($0B) Duplicate Top two bytes on Stack
;        DW      $1C89
;         .word  IL__SP               ; ($0C) Stack Pop
;        DW      $1CA6
;         .word  IL__NO               ; ($0D) (Reserved)
;        DW      $1CA9
;         .word  IL__NO               ; ($0E) (Reserved)
;        DW      $1C77
;         .word  IL__NO               ; ($0F) (Reserved)
;        DW      $1C80
;         .word  IL__SB               ; ($10) Save Basic Pointer
;        DW      $1FAB
;         .word  IL__RB               ; ($11) Restore Basic Pointer
;        DW      $1FB0
;         .word  IL__FV               ; ($12) Fetch Variable
;        DW      $1F00
;         .word  IL__SV               ; ($13) Store Variable
;        DW      $1F10    
;         .word  IL__GS               ; ($14) Save GOSUB line
;        DW      $1FCE
;         .word  IL__RS               ; ($15) Restore saved line
;        DW      $1F99
;         .word  IL__GO               ; ($16) GOTO
;        DW      $1F8E
;         .word  IL__NE               ; ($17) Negate
;        DW      $1EC2
;         .word  IL__AD               ; ($18) Add
;        DW      $1ECF    
;         .word  IL__SU               ; ($19) Subtract
;        DW      $1ECD    
;         .word  IL__MP               ; ($1A) Multiply
;        DW      $1EE5
;         .word  IL__DV               ; ($1B) Divide
;        DW      $1E6B    
;         .word  IL__CP               ; ($1C) Compare
;        DW      $1F23
;         .word  IL__NX               ; ($1D) Next BASIC statement
;        DW      $1F49    
;         .word  IL__NO               ; ($1E) (Reserved)
;        DW      $1CFC    
;         .word  IL__LS               ; ($1F) List the program
;        DW      $20D7  
;         .word  IL__PN               ; ($20) Print Number
;        DW      $2045  
;         .word  IL__PQ               ; ($21) Print BASIC string
;        DW      $20BA  
;         .word  IL__PT               ; ($22) Print Tab
;        DW      $20C2  
;         .word  IL__NL               ; ($23) New Line
;        DW      $2128
;         .word  IL__PC               ; ($24) Print Literal String
;        DW      $20AD
;         .word  IL__NO               ; ($25) (Reserved)

;         .word  IL__NO               ; ($26) (Reserved)

;         .word  IL__GL               ; ($27) Get input Line

;         .word  ILRES1               ; ($28) (Seems to be reserved - No IL opcode calls this)

;         .word  ILRES2               ; ($29) (Seems to be reserved - No IL opcode calls this)

;         .word  IL__IL               ; ($2A) Insert BASIC Line

;         .word  IL__MT               ; ($2B) Mark the BASIC program space Empty

;         .word  IL__XQ               ; ($2C) Execute

;         .word  WARM_S               ; ($2D) Stop (Warm Start)

;         .word  IL__US               ; ($2E) Machine Language Subroutine Call

;         .word  IL__RT               ; ($2F) IL subroutine return

;ERRSTR   .byte " AT "                ; " AT " string used in error reporting.  Tom was right about this.
;         .byte $80                   ; String terminator
         
;LBL002   .word  ILTBL                ; Address of IL program table



;
; Begin Cold Start
;
; Load start of free ram ($0200) into locations $20 and $21
; and initialize the address for end of free ram ($22 & $23)
;


SRVT    DB      $1D
        DB      $EE
        DB      $1E
        DB      $12
        DB      $1E
        RTI
        DB      $1E
        SEV
        DB      $1C
        DB      $FC
        DB      $1C
        STAB    M001C
        ADDB    M001C
Z1C2E   ADCA    #$1C
        LDAA    $1C,X
        ADCA    $1C,X
        ASR     Z1C80
        DB      $1F
        ADDA    $1F,X
        SUBA    M1F00
        DB      $1F
        SBA
        DB      $1F
        LDX     #M1F99
        DB      $1F
        LDS     #Z1EC2
        DB      $1E
        DB      $CF
        DB      $1E
        DB      $CD
        DB      $1E
        BITB    $1E,X
        DB      $6B
        DB      $1F
        BLS     Z1C71
        ROLA
        DB      $1C
        DB      $FC
        BRA     Z1C2E
        BRA     Z1C9E
        BRA     Z1C15
        BRA     Z1C1F
        DB      $21
        BVC     Z1C80
        JSR     $20,X
        ADDB    #$14
        DB      $00
        DB      $21
        ROLB
        ABA
        BLT     Z1C85
        DB      $38
        DB      $21
        CMPA    M1D12
        DB      $1F
        JMP     WARM_S
        DB      $1C
        ADCA    M1FA6
        BSR     Z1CA6
        STAA    M00BC
        STAB    M00BD
        JMP     Z1FD7
Z1C80   JSR     Z1FFC
        LDAA    M00BC
Z1C85   LDAB    M00BD
        BRA     Z1C8D
        BSR     Z1CA6
        BSR     Z1C8D
Z1C8D   LDX     M00C2
        DEX
        STAB    ,X
        BRA     Z1C96
Z1C94   LDX     M00C2
Z1C96   DEX
        STAA    ,X
        STX     M00C2
        PSHA
        LDAA    M00C1
Z1C9E   CMPA    M00C3
        PULA
        BCS     Z1CFC
Z1CA3   JMP     Z1D5C
Z1CA6   BSR     Z1CA9
        TBA
Z1CA9   LDAB    #$01
Z1CAB   ADDB    M00C3
        CMPB    #$80
        BHI     Z1CA3
        LDX     M00C2
        INC     M00C3
        LDAB    ,X
        RTS
        BSR     Z1CC0
        BSR     Z1C94
        TBA
        BRA     Z1C94
Z1CC0   LDAA    #$06
        TAB
        ADDA    M00C3
        CMPA    #$80
        BHI     Z1CA3
        LDX     M00C2
        STAA    M00C3
Z1CCD   LDAA    $05,X
        PSHA
        DEX
        DECB
        BNE     Z1CCD
        TPA
        PSHA
        RTI
        BSR     Z1CF5
        BRA     Z1C94
        BSR     Z1CF5
        PSHA
        BSR     Z1CF5
        TAB
        PULA
        BRA     Z1C8D
Z1CE4   ADDA    M00C3
        STAA    M00BD
        CLR     M00BC
        BSR     Z1CA9
        LDX     M00BC
        LDAA    ,X
        STAB    ,X
        BRA     Z1C94
Z1CF5   LDX     M002A
        LDAA    ,X
        INX
        STX     M002A
Z1CFC   TSTA
        RTS
M1CFE   BHI     Z1D6A
COLD_S  LDX     #M0100
        STX     M0020
        JSR     Z1A80
        STX     M0022
        JSR     Z1618
        ASLA
        LSRB
        DB      $42
        INS
        DB      $00
M1D12   LDAA    M0020
        LDAB    M0021
        ADDB    M1C13
        ADCA    #$00
        STAA    M0024
        STAB    M0025
        LDX     M0020
        CLR     ,X
        CLR     $01,X
WARM_S  LDS     M0022
Z1D27   JSR     Z212C
Z1D2A   LDX     M1CFE
        STX     M002A
        LDX     #M0080
        STX     M00C2
        LDX     #M0030
        STX     M00C0
Z1D39   STS     M0026
Z1D3B   BSR     Z1CF5
        BSR     Z1D46
        BRA     Z1D3B
        CPX     #M0099
        BRA     Z1D39
Z1D46   LDX     #M1C17
        STX     M00BC
        CMPA    #$30
        BCC     Z1DA5
        CMPA    #$08
        BCS     Z1CE4
        ASLA
        STAA    M00BD
        LDX     M00BC
        LDX     $17,X
        JMP     ,X
Z1D5C   JSR     Z212C
        LDAA    #$21
        STAA    M00C1
        JSR     Z1C09
        LDAA    #$80
        STAA    M00C3
Z1D6A   LDAB    M002B
        LDAA    M002A
        SUBB    M1CFF
        SBCA    M1CFE
        JSR     Z2042
        LDAA    M00C0
        BEQ     Z1D8A
        LDX     #M1D93
        STX     M002A
        JSR     Z20AD
        LDAA    M0028
        LDAB    M0029
        JSR     Z2042
Z1D8A   LDAA    #$07
        JSR     Z1C09
        LDS     M0026
        BRA     Z1D27
M1D93   BRA     Z1DD6
        LSRB
        BRA     Z1D18
        DEC     M00BC
Z1D9B   TST     M00BC
        BEQ     Z1D5C
Z1DA0   LDX     M00BC
        STX     M002A
        RTS
Z1DA5   CMPA    #$40
        BCC     Z1DCC
        PSHA
        JSR     Z1CF5
        ADDA    M1CFF
        STAA    M00BD
        PULA
        TAB
        ANDA    #$07
        ADCA    M1CFE
        STAA    M00BC
        ANDB    #$08
        BNE     Z1DA0
        LDX     M002A
        STAA    M002A
        LDAB    M00BD
        STAB    M002B
        STX     M00BC
        JMP     Z1FD7
Z1DCC   TAB
        LSRA
        LSRA
        LSRA
        LSRA
        ANDA    #$0E
        STAA    M00BD
        LDX     M00BC
        LDX     $17,X
        CLRA
        CMPB    #$60
        ANDB    #$1F
        BCC     Z1DE2
        ORAB    #$E0
Z1DE2   BEQ     Z1DEA
        ADDB    M002B
        STAB    M00BD
        ADCA    M002A
Z1DEA   STAA    M00BC
        JMP     ,X
        LDX     M002C
        STX     M00B8
Z1DF2   BSR     Z1E2A
        BSR     Z1E20
        TAB
        JSR     Z1CF5
        BPL     Z1DFE
        ORAB    #$80
Z1DFE   CBA
        BNE     Z1E05
        TSTA
        BPL     Z1DF2
        RTS
Z1E05   LDX     M00B8
        STX     M002C
Z1E09   BRA     Z1D9B
        BSR     Z1E2A
        CMPA    #$0D
        BNE     Z1E09
        RTS
        BSR     Z1E2A
        CMPA    #$5A
        BGT     Z1E09
        CMPA    #$41
        BLT     Z1E09
        ASLA
        JSR     Z1C94
Z1E20   LDX     M002C
        LDAA    ,X
        INX
        STX     M002C
        CMPA    #$0D
        RTS
Z1E2A   BSR     Z1E20
        CMPA    #$20
        BEQ     Z1E2A
        DEX
        STX     M002C
        CMPA    #$30
        CLC
        BLT     Z1E3A
        CMPA    #$3A
Z1E3A   RTS
        BSR     Z1E2A
        BCC     Z1E09
        LDX     #M0000
        STX     M00BC
Z1E44   BSR     Z1E20
        PSHA
        LDAA    M00BC
        LDAB    M00BD
        ASLB
        ROLA
        ASLB
        ROLA
        ADDB    M00BD
        ADCA    M00BC
        ASLB
        ROLA
        STAB    M00BD
        PULB
        ANDB    #$0F
        ADDB    M00BD
        ADCA    #$00
        STAA    M00BC
        STAB    M00BD
        BSR     Z1E2A
        BCS     Z1E44
        LDAA    M00BC
        JMP     Z1C8D
        BSR     Z1EE0
        LDAA    $02,X
        ASRA
        ROLA
        SBCA    $02,X
        STAA    M00BC
        STAA    M00BD
        TAB
        ADDB    $03,X
        STAB    $03,X
        TAB
        ADCB    $02,X
        STAB    $02,X
        EORA    ,X
        STAA    M00BE
        BPL     Z1E89
        BSR     Z1EC4
Z1E89   LDAB    #$11
        LDAA    ,X
        ORAA    $01,X
        BNE     Z1E94
        JMP     Z1D5C
Z1E94   LDAA    M00BD
        SUBA    $01,X
        PSHA
        LDAA    M00BC
        SBCA    ,X
        PSHA
        EORA    M00BC
        BMI     Z1EAB
        PULA
        STAA    M00BC
        PULA
        STAA    M00BD
        SEC
        BRA     Z1EAE
Z1EAB   PULA
        PULA
        CLC
Z1EAE   ROL     $03,X
        ROL     $02,X
        ROL     M00BD
        ROL     M00BC
        DECB
        BNE     Z1E94
        BSR     Z1EDD
        TST     M00BE
        BPL     Z1ECC
Z1EC2   LDX     M00C2
Z1EC4   NEG     $01,X
        BNE     Z1ECA
        DEC     ,X
Z1ECA   COM     ,X
Z1ECC   RTS
        BSR     Z1EC2
        BSR     Z1EE0
        LDAB    $03,X
        ADDB    $01,X
        LDAA    $02,X
        ADCA    ,X
Z1ED9   STAA    $02,X
        STAB    $03,X
Z1EDD   JMP     Z1CA9
Z1EE0   LDAB    #$04
Z1EE2   JMP     Z1CAB
        BSR     Z1EE0
        LDAA    #$10
        STAA    M00BC
        CLRA
        CLRB
Z1EED   ASLB
        ROLA
        ASL     $01,X
        ROL     ,X
        BCC     Z1EF9
        ADDB    $03,X
        ADCA    $02,X
Z1EF9   DEC     M00BC
        BNE     Z1EED
        BRA     Z1ED9
M1F00   BSR     Z1EDD
        STAB    M00BD
        CLR     M00BC
        LDX     M00BC
        LDAA    ,X
        LDAB    $01,X
        JMP     Z1C8D
        LDAB    #$03
        BSR     Z1EE2
        LDAB    $01,X
        CLR     $01,X
        LDAA    ,X
        LDX     $01,X
        STAA    ,X
        STAB    $01,X
Z1F20   JMP     Z1CA6
        BSR     Z1F20
        PSHB
        LDAB    #$03
        BSR     Z1EE2
        INC     M00C3
        INC     M00C3
        PULB
        SUBB    $02,X
        SBCA    $01,X
        BGT     Z1F42
        BLT     Z1F3E
        TSTB
        BEQ     Z1F40
        BRA     Z1F42
Z1F3E   ASR     ,X
Z1F40   ASR     ,X
Z1F42   ASR     ,X
        BCC     Z1F61
        JMP     Z1CF5
        LDAA    M00C0
        BEQ     Z1F6A
Z1F4D   JSR     Z1E20
        BNE     Z1F4D
        BSR     Z1F71
        BEQ     Z1F67
Z1F56   BSR     Z1F8A
        JSR     Z1C0C
        BCS     Z1F62
        LDX     M00C4
        STX     M002A
Z1F61   RTS
Z1F62   LDX     M1CFE
        STX     M002A
Z1F67   JMP     Z1D5C
Z1F6A   LDS     M0026
        STAA    M00BF
        JMP     Z1D2A
Z1F71   JSR     Z1E20
        STAA    M0028
        JSR     Z1E20
        STAA    M0029
        LDX     M0028
        RTS
        LDX     M0020
        STX     M002C
        BSR     Z1F71
        BEQ     Z1F67
        LDX     M002A
        STX     M00C4
Z1F8A   TPA
        STAA    M00C0
        RTS
        JSR     Z201A
        BEQ     Z1F56
Z1F93   LDX     M00BC
        STX     M0028
        BRA     Z1F67
M1F99   BSR     Z1FFC
        TSX
        INC     $01,X
        INC     $01,X
        JSR     Z2025
        BNE     Z1F93
        RTS
M1FA6   BSR     Z1FFC
        STX     M002A
        RTS
        LDX     #M002C
        BRA     Z1FB3
        LDX     #M002E
Z1FB3   LDAA    $01,X
        CMPA    #$80
        BCC     Z1FC1
        LDAA    ,X
        BNE     Z1FC1
        LDX     M002C
        BRA     Z1DB
Z1FC1   LDX     M002C
        LDAA    M002E
        STAA    M002C
        LDAA    M002F
        STAA    M002D
Z1DB    STX     M002E
        RTS
        TSX
        INC     $01,X
        INC     $01,X
        LDX     M0028
        STX     M00BC
Z1FD7   DES
        DES
        TSX
        LDAA    $02,X
        STAA    ,X
        LDAA    $03,X
        STAA    $01,X
        LDAA    M00BC
        STAA    $02,X
        LDAA    M00BD
        STAA    $03,X
        LDX     #M0024
        STS     M00BC
        LDAA    $01,X
        SUBA    M00BD
        LDAA    ,X
        SBCA    M00BC
        BCS     Z2019
Z1FF9   JMP     Z1D5C
Z1FFC   TSX
        INX
        INX
        INX
        CPX     M0022
        BEQ     Z1FF9
        LDX     $01,X
        STX     M00BC
        TSX
        PSHB
        LDAB    #$04
Z200C   LDAA    $03,X
        STAA    $05,X
        DEX
        DECB
        BNE     Z200C
        PULB
        INS
        INS
        LDX     M00BC
Z2019   RTS
Z201A   JSR     Z1CA6
        STAB    M00BD
        STAA    M00BC
        ORAA    M00BD
        BEQ     Z1FF9
Z2025   LDX     M0020
        STX     M002C
Z2029   JSR     Z1F71
        BEQ     Z203F
        LDAB    M0029
        LDAA    M0028
        SUBB    M00BD
        SBCA    M00BC
        BCC     Z203F
Z2038   JSR     Z1E20
        BNE     Z2038
        BRA     Z2029
Z203F   CPX     M00BC
        RTS
Z2042   JSR     Z1C8D
        LDX     M00C2
        TST     ,X
        BPL     Z2052
        JSR     Z1EC2
        LDAA    #$2D
        BSR     Z2098
Z2052   CLRA
        PSHA
        LDAB    #$0F
        LDAA    #$1A
        PSHA
        PSHB
        PSHA
        PSHB
        JSR     Z1CA6
        TSX
Z2060   INC     ,X
        SUBB    #$10
        SBCA    #$27
        BCC     Z2060
Z2068   DEC     $01,X
        ADDB    #$E8
        ADCA    #$03
        BCC     Z2068
Z2070   INC     $02,X
        SUBB    #$64
        SBCA    #$00
        BCC     Z2070
Z2078   DEC     $03,X
        ADDB    #$0A
        BCC     Z2078
        CLR     M00BE
Z2081   PULA
        TSTA
        BEQ     Z2089
        BSR     Z208A
        BRA     Z2081
Z2089   TBA
Z208A   CMPA    #$10
        BNE     Z2093
        TST     M00BE
        BEQ     Z20AA
Z2093   INC     M00BE
        ORAA    #$30
Z2098   INC     M00BF
        BMI     Z20A7
        STX     M00BA
        PSHB
        JSR     Z1C09
        PULB
        LDX     M00BA
        RTS
Z20A7   DEC     M00BF
Z20AA   RTS
Z20AB   BSR     Z2098
Z20AD   JSR     Z1CF5
        BPL     Z20AB
        BRA     Z2098
Z20B4   CMPA    #$22
        BEQ     Z20AA
        BSR     Z2098
        JSR     Z1E20
        BNE     Z20B4
        JMP     Z1D5C
        LDAB    M00BF
        BMI     Z20AA
        ORAB    #$F8
        NEGB
        BRA     Z20CE
        JSR     Z1CA6
Z20CE   DECB
        BLT     Z20AA
        LDAA    #$20
        BSR     Z2098
        BRA     Z20CE
        LDX     M002C
        STX     M00B8
        LDX     M0020
        STX     M002C
        LDX     M0024
        BSR     Z210F
        BEQ     Z20E7
        BSR     Z210F
Z20E7   LDAA    M002C
        LDAB    M002D
        SUBB    M00B7
        SBCA    M00B6
        BCC     Z2123
        JSR     Z1F71
        BEQ     Z2123
        LDAA    M0028
        LDAB    M0029
        JSR     Z2042
        LDAA    #$20
Z20FF   BSR     Z214C
        JSR     Z1C0C
        BCS     Z2123
        JSR     Z1E20
        BNE     Z20FF
        BSR     Z2128
        BRA     Z20E7
Z210F   INX
        STX     M00B6
        LDX     M00C2
        CPX     #M0080
        BEQ     Z2122
        JSR     Z201A
Z211C   LDX     M002C
        DEX
        DEX
        STX     M002C
Z2122   RTS
Z2123   LDX     M00B8
        STX     M002C
        RTS
Z2128   LDAA    M00BF
        BMI     Z2122
Z212C   LDAA    #$0D
        BSR     Z2149
        LDAB    PCC
        ASLB
        BEQ     Z213E
Z2136   PSHB
        BSR     Z2142
        PULB
        DECB
        DECB
        BNE     Z2136
Z213E   LDAA    #$0A
        BSR     Z214C
Z2142   CLRA
        TST     PCC
        BPL     Z2149
        COMA
Z2149   CLR     M00BF
Z214C   JMP     Z2098
Z214F   LDAA    TMC
        BRA     Z2155
Z2154   CLRA
Z2155   STAA    M00BF
        BRA     Z2163
        LDX     #M0030
        STX     M002C
        STX     M00BC
        JSR     Z1C8D
Z2163   EORA    M0080
        STAA    M0080
        JSR     Z1C06
        ANDA    #$7F
        BEQ     Z2163
        CMPA    #$7F
        BEQ     Z2163
        CMPA    #$0A
        BEQ     Z214F
        CMPA    #$13
        BEQ     Z2154
        LDX     M00BC
        CMPA    LSC
        BEQ     Z218B
        CMPA    BSC
        BNE     Z2192
        CPX     #M0030
        BNE     Z21A0
Z218B   LDX     M002C
        LDAA    #$0D
        CLR     M00BF
Z2192   CPX     M00C2
        BNE     Z219C
        LDAA    #$07
        BSR     Z214C
        BRA     Z2163
Z219C   STAA    ,X
        INX
        INX
Z21A0   DEX
        STX     M00BC
        CMPA    #$0D
        BNE     Z2163
        JSR     Z2128
        LDAA    M00BD
        STAA    M00C1
        JMP     Z1CA6
        JSR     Z1FC1
        JSR     Z201A
        TPA
        JSR     Z211C
        STX     M00B8
        LDX     M00BC
        STX     M00B6
        CLRB
        TAP
        BNE     Z21D0
        JSR     Z1F71
        LDAB    #$FE
Z21CA   DECB
        JSR     Z1E20
        BNE     Z21CA
Z21D0   LDX     #M0000
        STX     M0028
        JSR     Z1FC1
        LDAA    #$0D
        LDX     M002C
        CMPA    ,X
        BEQ     Z21EC
        ADDB    #$03
Z21E2   INCB
        INX
        CMPA    ,X
        BNE     Z21E2
        LDX     M00B6
        STX     M0028
Z21EC   LDX     M00B8
        STX     M00BC
        TSTB
        BEQ     Z2248
        BPL     Z2218
        LDAA    M002F
        ABA
        STAA    M00B9
        LDAA    M002E
        ADCA    #$FF
        STAA    M00B8
Z2200   LDX     M002E
        LDAB    ,X
        CPX     M0024
        BEQ     Z2244
        CPX     M0026
        BEQ     Z2244
        INX
        STX     M002E
        LDX     M00B8
        STAB    ,X
        INX
        STX     M00B8
        BRA     Z2200
Z2218   ADDB    M0025
        STAB    M002F
        LDAA    #$00
        ADCA    M0024
        STAA    M002E
        SUBB    M0027
        SBCA    M0026
        BCS     Z222E
        DEC     M002B
        JMP     Z1D5C
Z222E   LDX     M002E
        STX     M00B8
Z2232   LDX     M0024
        LDAA    ,X
        DEX
        STX     M0024
        LDX     M002E
        STAA    ,X
        DEX
        STX     M002E
        CPX     M00BC
        BNE     Z2232
Z2244   LDX     M00B8
        STX     M0024
Z2248   LDX     M0028
        BEQ     Z2265
        LDX     M00BC
        LDAA    M0028
        LDAB    M0029
        STAA    ,X
        INX
        STAB    ,X
Z2257   INX
        STX     M00BC
        JSR     Z1E20
        LDX     M00BC
        STAA    ,X
        CMPA    #$0D
        BNE     Z2257
Z2265   LDS     M0026
        JMP     Z1D2A
        BCC     Z22A6
        CMPA    M0027
        SBA
        CMPB    $59,X
        BITB    #$2A
        RORB
        SBA
        CBA
        BGE     Z2203
        INCA
        DB      $45
        ANDB    M00A0
        SUBA    #$BD
        TSX
        CPX     ME013
        DB      $1D
        ANDA    M0047
        DB      $CF
        EORA    #$54
        DB      $CF
        TSX
        CPX     ME010
        CBA
        TAB
Z228F   SUBA    #$53
        DB      $55
        SBCB    #$30
        CPX     ME014
        TAB
        SUBA    M0050
        SBCB    M0083
        ROLA
        DB      $4E
        ANDB    M00E5
        DB      $71
        EORA    #$BB
        CMPB    $1D,X
        DB      $8F
Z22A6   SBCA    $21,X
        ASLB
        CLR     $83,X
        CPX     $22,X
        DB      $55
        DB      $83
        ORAA    M2493
        SUBB    $23,X
        DB      $1D
        TSX
        CPX     M2048
        CMPA    M0049
Z22BB   LDAB    #$30
        CPX     M3134
        TSX
        CPX     M8454
        ASLA
        DB      $45
        LDX     #M1C1D
        DB      $38
        SEC
        ORAA    M0049
        DB      $4E
        NEGB
        DB      $55
        ANDB    M00A0
        SBA
        STAB    $24,X
        SWI
        BRA     Z2269
        BEQ     Z22BB
        ROLB
        CMPA    #$AC
        TSX
        CPX     M1311
        SBCA    #$AC
        TSTA
Z22E4   SUBB    $1D,X
        ADCA    #$52
        DB      $45
        LSRB
        DB      $55
        DB      $52
        LDX     #ME015
        DB      $1D
        BITA    #$45
        DB      $4E
        ANDB    #$E0
        BLT     Z228F
        INCA
        ROLA
        COMB
        ANDB    M00EC
        BCC     Z22FE
Z22FE   DB      $00
        DB      $00
        DB      $00
        CLV
        SUBA    #$1F
        BCC     Z2299
        BLS     Z2325
Z2308   TSX
        CPX     ME150
        SUBA    #$AC
Z230E   ROLB
        BITA    #$52
        DB      $55
        LDX     #M380A
        LDAA    #$43
        INCA
Z2318   DB      $45
        DB      $41
        SBCB    M002B
        ANDA    #$52
        DB      $45
        DB      $CD
        DB      $1D
        RTS
        ASRB
Z2323   DB      $00
        DB      $00
Z2325   DB      $00
        BITA    #$AD
        TSX
        DB      $D3
        TBA
Z232B   LSR     $81,X
        ADDA    $30,X
Z232F   DB      $D3
        BITA    #$AB
Z2332   TSX
Z2333   DB      $D3
        DB      $18
        DECB
        BITA    #$AD
        TSX
        DB      $D3
        DAA
        LSRB
        BLE     Z236E
Z233E   SBCB    $85,X
        ORAA    $30,X
        SBCB    $1A,X
        DECB
        BITA    #$AF
        TSX
        SBCB    $1B,X
        LSRB
        BLE     Z22E4
Z234D   DB      $52
        DB      $4E
        ANDB    #$0A
        SUBA    #$80
        DB      $12
        CLV
        DEX
        BVS     Z2372
        CLV
        DB      $1A
        BITA    #$18
        DB      $13
        DEX
        SUBA    #$12
        SEV
        INS
        TSX
        DB      $61
        COM     M0B02
        DB      $04
        DB      $02
        DB      $03
        DB      $05
        DB      $03
        ABA
        DB      $1A
Z236E   DAA
        SEV
        DEX
        TAP
Z2372   CLV
        DB      $00
        DB      $00
        DB      $1C
        TBA
        BLE     Z2308
        DB      $55
        COMB
        SBCB    M0080
        EORA    $30,X
        CPX     M312A
        INS
        BPL     Z2305
        ADCA    $2E,X
        BLE     Z232B
        DB      $12
        BLE     Z234D
        BLE     Z230E
        EORA    $30,X
        CPX     M80A9
        BLE     Z2318
        CPX     $38,X
        CPX     M0B2F
        SUBA    #$A8
        DB      $52
        BLE     Z2323
        JSR     Z0902
        BLE     Z2332
        CPX     M84BD
        DEX
        DB      $03
        BLE     Z232F
        LDS     M0905
        BLE     Z23B9
        NOP
        BLE     Z2333
        LDS     M84BD
        DEX
        TAP
        BLE     Z233E
        CPX     M0905
        BLE     Z23C8
        DB      $04
        BLE     Z2346
        DB      $42
        ROLB
        BITB    #$26
        LDAA    #$4C
Z23C8   CLRA
        DB      $41
        ANDB    #$28
        DB      $1D
        LDAA    #$53
        DB      $41
        RORB
        BITB    #$29
        DB      $1D
        SUBA    $80,X
        JSR     Z3814
        DS      $2400-*,$FF
;       END
