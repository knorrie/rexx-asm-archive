; Demonstratie van Muisfunctie 12

Stack Segment Stack
  dw    100     dup (?)
Stack Ends

Code Segment
        Assume  cs:Code,ss:Stack

msub proc far
                test    ax,0010h        ; rechterknop losgelaten
                jne     jmp_1
                mov     ax,0004h        ; muiscursor positioneren
                mov     cx,0000h        ; linkerbovenhoek
                mov     dx,0000h        ; van het scherm
                int     33h
                jmp     return
jmp_1:          mov     ax,0004h        ; muiscursor positioneren
                mov     cx,00FFh
                mov     dx,00FFh
                int     33h
return:         ret
msub endp

start:          mov     ax,0000h        ; muis-reset en status
                int     33h

                mov     ax,0001h        ; cursor tonen
                int     33h

                mov     dx,offset msub  ; plaats van msub in es:dx
                mov     ax,seg msub
                mov     es,ax
                mov     ax,000Ch        ; muisfunctie 12
                mov     cx,0012h        ; interrupt als rechtermuisknop
                                        ; wordt losgelaten of linker knop
                                        ; wordt ingedrukt.
                int     33h

                mov     ah,0008h        ; wacht op toets zodat muis kan
                int     21h             ; worden getest

                mov     ax,0000h        ; muis-reset om interrupt uit te
                int     33h             ; schakelen

                mov     ax,4C00h        ; Exit
                int     21h

Code Ends
  End   start
