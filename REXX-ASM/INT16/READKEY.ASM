; READKEY.ASM (READKEY.RX) - int 16h, 00h from REXX
;
;   PC DOS 7 REXX External Function
;
;   input  : geen
;   output : 4-byte ax
;     (geconverteerd omdat REXX ASCIIZ-string gebruikt bij RXRESULT)
;
;   bv. key = READKEY()
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
start:          cmp     RXARGC,0000h    ; No Args!
                jne     errorexit

                mov     ah,00h
                int     16h             ; Yes! - Return value in ax
                mov     dx,ax           ; nu in dx

                les     di,RXRESULT     ; pointer to RXRESULT string buffer
                add     di,0003h
                std                     ; achteruit

                mov     cx,0004h        ; naar 4 bytes converteren
loop_1:         mov     al,dl
                and     al,0Fh
                cmp     al,0Ah          ; letters zitten ascii 07h hoger
                jb      jp_1
                add     al,07h
jp_1:           add     al,30h
                stosb
                push    cx
                mov     cl,04h
                shr     dx,cl
                pop     cx
                loop    loop_1

exit:           mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

code            ends
  end           start
