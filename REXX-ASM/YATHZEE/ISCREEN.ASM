; ISCREEN.ASM (ISCREEN.RX) - Initialise Screen
;
;   Hans van Kranenburg 1996  PC DOS 7 REXX External Function
;
; Videomem initialiseren voor Yathzee
; Parameters:
;  - geen
;

code            segment
  assume        cs:code
  org           100h

start:          jmp codestart

  ; data
  file          db      'ISCREEN.DAT',0
  ; data

codestart:      ;mov     ax,0003h        ; color 80x25 mode
                ;int     10h

                ;mov     ax,0500h        ; naar schermpagina 00
                ;int     10h

                mov     ax,3D00h        ; DOS functie openen als read-only
                lea     dx,file
                int     21h
                mov     bx,ax           ; file-handle in bx

                mov     ah,3Fh          ; DOS functie lezen uit file
                mov     dx,0B800h       ; beginsegment videomem
                mov     ds,dx
                mov     dx,1000h        ; schermpagina 01
                mov     cx,4000d
                int     21h

                mov     ah,3Fh          ; DOS functie lezen uit file
                mov     dx,2000h        ; schermpagina 02
                int     21h

                mov     ah,3Fh          ; DOS functie lezen uit file
                mov     dx,3000h        ; schermpagina 03
                int     21h

                mov     ah,3Eh          ; DOS functie sluit file
                int     21h

;jmp0:           xor     ax,ax          ; schermpagina's bekijken
;                int     16h
;                cmp     ax,0001h
;                je      exit
;                sub     al,30h
;                mov     ah,05
;                int     10h
;                jmp     jmp0

exit:           mov     ax,4C00h        ; exit
                int     21h

code            ends
  end           start
