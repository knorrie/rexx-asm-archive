; PRTSTR.ASM (PRTSTR.RX)
;
;   Write String v1.00 voor PC DOS 7 REXX
;
;   Aanroepen:
;     PrtStr('al bl bh dh dl'x,str)
;       al - Cursor wel(01) of niet(00) verplaatsen
;       bl - Color Attribute
;       bh - Display Page
;       dh - row
;       dl - col
;
;   bv. PrtStr('000700061A'x,'Hello World!!')
;
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ; begin data
  org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  ; einde data

  org           100h
start:          cmp     RXARGC,0002h    ; Controleren aantal parameters
                ja      errorexit       ; 0 < RXARGC <= 2
                cmp     RXARGC,0000h
                je      errorexit

                push    ds

                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di],0005h ; length arg1 moet 5 bytes zijn
                jne     errorexit
                lds     si,[di+02h]     ; arg 1
                cld
                lodsb                   ; wel/niet cursor verplaatsen
                mov     cl,al           ;  tijdelijk in cl
                lodsw
                mov     bx,ax           ; bh=display page, bl=color attribute
                lodsw
                mov     dx,ax           ; dl=col, dh=row
                xchg    dh,dl
                mov     al,cl           ; wel/niet cursor nu in al

                pop     ds

                lds     di,RXARGV       ; pointer to argument array
                mov     cx,[di+06h]     ; length arg 2
                les     bp,[di+08h]     ; arg 2

                mov     ah,13h          ; Functie 13h: Write String
                int     10h

exit:           mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

code            ends
  end           start
