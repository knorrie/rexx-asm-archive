; PUSHKEY.ASM (PUSHKEY.RX) - int 16h, 05h from REXX
;
;   PC DOS 7 REXX External Function
;
;   input  : 2-byte cx
;   output : 0 = added, 1 = Keyboard buffer full, not added
;
;   bv. Do Until \ PUSHKEY('324D'x); End
;       -> Try until succesful
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
start:          cmp     RXARGC,0001h    ; REXX Argument Count
                jne     errorexit

                push    ds
                lds     si,RXARGV       ; REXX Argument Array
                cmp     word ptr [si],0002h ; 2 bytes
                jne     errorexit

                lds     si,[si+02h]     ; arg 1 : toetscode
                lodsw
                xchg    ah,al
                mov     cx,ax

                mov     ah,05h
                int     16h             ; Yes! - Return value in ax

                pop     ds
                les     di,RXRESULT     ; pointer to RXRESULT string buffer
                add     al,30h          ; hex2ascii
                stosb

exit:           mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

code            ends
  end           start
