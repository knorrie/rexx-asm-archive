; IVERSION.ASM (IVERSION.RX) - Put Yathzee-Top-11 Version on screen
;
;   Hans van Kranenburg 1996  PC DOS 7 REXX External Function
;
; Vult de versie en het jaartal in op het de verschillende schermpagina's
; Parameters:
;  - versie  in 4-byte formaat (bv: 3.00)
;  - jaartal in 4-byte formaat (bv: 1997)
;

version1        equ     1F2Ch           ; offset voor versienummer op scherm
version2        equ     205Ah
version3        equ     31AAh
year1           equ     1F60h           ; offset voor jaartal op scherm

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  Org           82h
  ; adressen van REXX parameters
  RXARGC        dw      ?
  RXARGV        dd      ?

  Org           100h
start:          cmp     RXARGC,0002h    ; 2 parameters
                jne     errorexit

                mov     ax,0B800h       ; videomem segment
                mov     es,ax

                push    ds
  ; versienummers
                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di],0004h ; arg1 moet 4 byte lang zijn
                jne     errorexit
                lds     si,[di+02h]     ; first argument : version

                mov     di,version1
                call    wr4

                mov     di,version2
                call    wr4

                mov     di,version3
                call    wr4

                pop     ds
  ; jaartal
                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di+06h],0004h ; arg2 moet 4 byte lang zijn
                jne     errorexit
                lds     si,[di+08h]     ; second argument : year

                mov     di,year1
                call    wr4

exit:           mov     ax,4C00h        ; bye bye
                int     21h

errorexit:      mov     ax,4C01h        ; bye bye with error
                int     21h

wr4:            mov     cx,0004h        ; 4 bytes kopieren
wr4_0:          movsb
                inc     di              ; attribuutbyte overslaan
                loop    wr4_0
                sub     si,04h          ; terug naar begin voor volgende
                ret

code            ends
  end           start
