; SCROLBOX.ASM (SCROLBOX.RX)
;
;   Scroll Box  PC DOS 7 REXX External Function
;   Scroll part of active page up/down
;
;   Function Call:
;     ScrolBox('ah al bh ch cl dh dl'x)
;       ah - Direction         (06h = up, 07h = down)
;       al - Number Of Lines   (00h = clear box)
;       bh - Color Attribute
;       ch - Top Row
;       cl - Left Col
;       dh - Bottom Row
;       dl - Right Col
;
;   e.g. ScrolBox('06041202040F2E'x)
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ; begin data
  org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  ; einde data

  org           100h
start:          cmp     RXARGC,0001h    ; Controleren aantal parameters
                jne     errorexit

                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di],0007h ; length arg1 moet 7 bytes zijn
                jne     errorexit
                lds     si,[di+02h]     ; arg1
                cld
                lodsw                   ; updown, nol
                xchg    ah,al
                push    ax
                lodsb                   ; attr
                mov     bh,al
                lodsw                   ; trow,lcol
                xchg    ah,al
                mov     cx,ax
                lodsw                   ; brow,rcol
                xchg    ah,al
                mov     dx,ax
                pop     ax

                int     10h

exit:           mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

code            ends
  end           start
