; SHIFTCHK.ASM (SHIFTCHK.RX) - int 16h, 02h from REXX
;
;   PC DOS 7 REXX External Function
;
;   input  : geen
;   output : 1-byte al
;
;   bv. shiftstatus = SHIFTCHK()
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

                mov     ah,02h
                int     16h             ; Yes! - Return value in al

                les     di,RXRESULT     ; pointer to RXRESULT string buffer
                stosb

exit:           mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

code            ends
  end           start
