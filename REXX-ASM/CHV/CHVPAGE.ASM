; CHVPAGE.ASM (CHVPAGE.RX)
;
;   Change Video Page  PC DOS 7 REXX External Function
;
;   Aanroepen:
;     ChVPage(page)
;       page - hex video page (00h-03h)
;     bij geen parameters wordt active page geretourneerd
;
;   bv. ChVPage('00'h)
;       page=ChVPage()
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
                ja      errorexit       ; moet 1 of 0 zijn
                jne     getpage         ; bij 0 parameters page ophalen

                lds     di,RXARGV       ; pointer to argument array
                cmp     word ptr [di],0001h ; arg1 moet 1 byte lang zijn
                jne     errorexit
                lds     si,[di+02h]     ; arg 1
                lodsb                   ; page in al
                cmp     al,03h          ; max video page
                ja      errorexit
                mov     ah,05h          ; Change Video Page
                int     10h             ; go!!

exit:           mov     ax,4C00h        ; bye bye
                int     21h

errorexit:      mov     ax,4C01h        ; bye bye with error
                int     21h

getpage:        mov     ah,0Fh          ; get video info
                int     10h
                mov     al,bh           ; video page in al
                les     di,RXRESULT
                stosb
                jmp     exit

code            ends
  end           start
