; ACTIVE.ASM - Hans van Kranenburg 1996 : Maakt PSP dump en zoekt uit of
; REXX interpreter actief is

  cr            equ     0DH
  lf            equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; Start Data
  rexxstr       db      'REXX'
  notactive     db      'REXX interpreter is not active',cr,lf,'$'
  active        db      'REXX interpreter is active',cr,lf,'$'
  file          db      'REXXPSP .HEX',0        ; ASCIIZ string voor filename
  ; Einde Data

  ; PSP + nog een stukje geheugen in een dump-file wegschrijven
codestart:      lea     dx,file         ; deze file moet gemaakt worden
                xor     cx,cx           ; 'normaal bestand' attribuut voor file
                mov     ah,3Ch          ; DOS functie maak file aan
                int     21h

                mov     bx,ax           ; handle in bx
                mov     cx,0100h        ; 100h bytes schrijven = hele PSP
                mov     dx,0000h        ; begin bij begin segment
                mov     ah,40h          ; DOS functie schrijven
                int     21h

                                        ; handle nog in bx
                mov     ah,3Eh          ; DOS functie sluiten
                int     21h

  ; uitzoeken of REXX interpreter actief is
                mov     di,0054h        ; PSP: op plek 54h moet 'REXX' staan
                lea     si,rexxstr      ; vergelijken met rexxstr
                mov     cx,0004h        ; 4 bytes te vergelijken
                cld                     ; in voorwaartse richting
                repz cmpsb              ; GO!!
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