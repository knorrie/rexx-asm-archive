; REXXPSP.ASM - Hans van Kranenburg 1996 : PSP e.d. van een d.m.v. REXX
;   aangeroepen external in een bestand dumpen

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; Start Data
  file          db      'REXXPSP .HEX',0        ; ASCIIZ string voor filename
  handle        dw      ?
  ; Einde Data

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

                mov     ax,4C00h        ; wegwezen
                int     21h

Code Ends
  End           start
