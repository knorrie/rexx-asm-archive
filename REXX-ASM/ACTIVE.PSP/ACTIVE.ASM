; ACTIVE.ASM - Hans van Kranenburg 1996 : Zoekt uit of REXX interpreter
;   actief is

  cr            equ     0DH
  lf            equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; Begin Data
  rexxstr       db      'REXX'
  notactive     db      'REXX interpreter is not active',cr,lf,'$'
  active        db      'REXX interpreter is active',cr,lf,'$'
  ; Einde Data

codestart:      mov     di,0054h        ; PSP: op plek 54h moet 'REXX' staan
                lea     si,rexxstr      ; vergelijken met rexxstr
                mov     cx,0004h        ; 4 bytes te vergelijken
                cld                     ; in voorwaartse richting
           repz cmpsb                   ; GO!!
                jnz     no_rexx         ; REXX interpreter niet actief
                lea     dx,active       ; string afbeelden
                mov     ah,09h
                int     21h
                jmp     exit

no_rexx:        lea     dx,notactive    ; string afbeelden
                mov     ah,09h
                int     21h

exit:           mov     ax,4C00h        ; exit
                int     21h

Code Ends
  End           start
