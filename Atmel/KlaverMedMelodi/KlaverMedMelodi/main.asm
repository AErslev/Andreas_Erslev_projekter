;**********************************
;********   MSYS, LAB3_1   ********
;******** Henning Hargaard ********
;********   4.april 2017   ********
;**********************************

;*********** INITIERING ***********
;***** Klargoer SP og PORTB *******
  LDI  R16,HIGH(RAMEND) ;Klargoer Stack Pointer
  OUT  SPH,R16
  LDI  R16,LOW(RAMEND)
  OUT  SPL,R16 
  SER  R16              ;PORT B er udgang
  OUT  DDRB,R16
  CLR  R16              ;Sluk alle lysdioder
  OUT  PORTB,R16
 
;*********** PROGRAM LOOP *********

HERE:

  SBIS PINA, 7   ;C      Spil C dur skalaen
  CALL TONE_CL

  SBIS PINA, 6   ;D
  CALL TONE_D

  SBIS PINA, 5   ;E
  CALL TONE_E

  SBIS PINA, 4   ;F
  CALL TONE_F

  SBIS PINA, 3   ;G
  CALL TONE_G

  SBIS PINA, 2   ;A 
  CALL TONE_A

  SBIS PINA, 1   ;H
  CALL TONE_H

  SBIS PINA, 0   ;CH
  CALL TONE_CH

  JMP  HERE      ;Bliv her "altid"
   	
;**********************************
;******** SPILLER EN TONE  ********
;******** 250 HALVPERIODER ********
;******** T/2 = (R20)*4 us ********
;********************************** 
TONE_CL:
  LDI  R20,239
  CALL KLAVER
  SBIS PINA, 6
  CALL LPE
  RET

TONE_D:
  LDI  R20,213
  CALL KLAVER
  RET

TONE_E:
  LDI  R20,190
  CALL KLAVER
  RET

TONE_F:
  LDI  R20,179
  CALL KLAVER
  RET

TONE_G:
  LDI  R20,160
  CALL KLAVER
  RET

TONE_A:
  LDI  R20,142
  CALL KLAVER
  RET

TONE_H:
  LDI  R20,127
  CALL KLAVER
  RET

TONE_CH:
  LDI  R20,120
  CALL KLAVER
  RET
  
KLAVER: 
  LDI R22,250            ;<--- HER MANGLER KODE (del 2)

KLAVER2: 
  COM R23
  OUT PORTB,R23
  MOV R18,R20
  CALL DELAY      ;Delay = (R18) * 4 mikrosekunder
  DEC R22               ;<--- HER MANGLER KODE (del 2)
  BRNE KLAVER2
  RET             ;Retur til program loop


MELODI:
  LDI R22,250 

MELODI2:
  COM R23
  OUT PORTB,R23
  MOV R18,R20
  CALL DELAY      ;Delay = (R18) * 4 mikrosekunder
  DEC R22               ;<--- HER MANGLER KODE (del 2)
  BRNE MELODI2

  LDI R18,200
  CALL DELAYMELODI

  RET  
  

  ;**********************************
;*  DELAY (R18*4us)               *
;*  Laver en tidsforsinkelse paa  *
;* "Det der er i R18" gange 4 us  *
;**********************************
DELAY:
  LDI  R17,21   ;<--- OPGAVE (del 1): Find xxx og skriv det her
  NOP
AGAIN:
  DEC  R17
  BRNE AGAIN
  DEC  R18
  BRNE DELAY
  RET

DELAYMELODI:
  LDI  R17,255   ;<--- OPGAVE (del 1): Find xxx og skriv det her
  MOV R28,R30
  NOP
AGAIN2:
  DEC  R17
  BRNE AGAIN2
  DEC  R28
  BRNE AGAIN2
  DEC  R18
  BRNE DELAYMELODI
  RET

LPE:
//Linje 1
  LDI  R30,5 //KORT

  LDI  R20,213   ;D
  CALL MELODI

  LDI  R20,213   ;D
  CALL MELODI

  LDI  R20,213   ;D
  CALL MELODI

  LDI  R20,190   ;E
  CALL MELODI

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R30,25 //LANG

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R30,5 //KORT

  LDI  R20,190   ;E
  CALL MELODI

  LDI  R20,190   ;E
  CALL MELODI

  LDI  R20,190   ;E
  CALL MELODI

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R30,25 //LANG

  LDI  R20,213   ;D
  CALL MELODI

  LDI  R20,213   ;D
  CALL MELODI

//Linje 2
  
   LDI  R20,179   ;F
  CALL MELODI

 LDI  R30,5 //KORT

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R20,160   ;G
  CALL MELODI 

  LDI  R30,25 //LANG

  LDI  R20,142   ;A 
  CALL MELODI 

  LDI  R20,142   ;A 
  CALL MELODI 

 LDI  R30,5 //KORT

  LDI  R20,160   ;G
  CALL MELODI 

  LDI  R20,160   ;G
  CALL MELODI 

  LDI  R20,160   ;G
  CALL MELODI 

  LDI  R20,142   ;A 
  CALL MELODI 

  LDI  R30,35 //RIGTIG LANG

  LDI  R20,179   ;F
  CALL MELODI

  LDI  R30,25 //LANG

  LDI  R20,213   ;D
  CALL MELODI

  LDI  R20,213   ;D
  CALL MELODI




  RET