; CHVMODE.ASM (CHVMODE.RX)
;
;   Change Video Mode  PC DOS 7 REXX External Function
;
;   Aanroepen:
;     ChVMode(mode)
;       mode - hex video mode
;     bij geen parameters wordt active mode geretourneerd
;
;   bv. ChVMode('03'x)
;       mode=ChVMode()
;         N.B. als er niets wordt geretourneerd is de active page 00h, ivm.
;         ASCIIZ-string RXRESULT (00h wordt beschouwd als einde van string)
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ; begin data
  org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  RXRESULT      dd      ?
  ; einde data

  org           100h
start:          cmp     RXARGC,0001h    ; Controleren aantal parameters
                ja      errorexit       ; moet 1 zijn
                jne     getmode

                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di],0001h ; arg1 moet 1 byte lang zijn
                jne     errorexit
                lds     si,[di+02h]     ; arg 1
                lodsb                   ; mode in al
                mov     ah,00h          ; Change Video Mode
                int     10h             ; go!!

exit:           mov     ax,4C00h        ; bye bye
                int     21h

errorexit:      mov     ax,4C01h        ; bye bye with error
                int     21h

getmode:        mov     ah,0Fh          ; get video info
                int     10h
                les     di,RXRESULT
                stosb
                jmp     exit

code            ends
  end           start
