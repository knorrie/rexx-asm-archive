; 3MACHT.ASM : zoekt alle getallen van 3 cijfers op die gelijk zijn aan de
;              som van de afzonderlijke cijfers tot de 3e macht

  cr            equ     0DH
  lf            equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; Begin Data
  n1            dw      1
  n2            dw      0
  n3            dw      0
  enter         db      cr,lf,'$'
  ; Einde Data

codestart:      xor     bx,bx           ; som van cijfers tot 3e macht in bx
                mov     ax,n1
                call    macht3
                mov     ax,n2
                call    macht3
                mov     ax,n3
                call    macht3

                mov     ax,n1           ; binaire versie van de drie cijfers
                mov     cx,10d
                mul     cx
                add     ax,n2
                mul     cx
                add     ax,n3

                cmp     ax,bx           ; als ax=bx dan weergeven
                jnz     newnum

                mov     dx,n1           ; weergeven cijfers
                call    wrtnum
                mov     dx,n2
                call    wrtnum
                mov     dx,n3
                call    wrtnum
                lea     dx,enter        ; nieuwe regel
                mov     ah,09h
                int     21h

newnum:         inc     n3              ; nieuw getal
                cmp     n3,10d
                jnz     codestart
                mov     n3,00h
                inc     n2
                cmp     n2,10d
                jnz     codestart
                mov     n2,00h
                inc     n1
                cmp     n1,10d
                jz      exit
                jmp     codestart

exit:           mov     ax,4C00h        ; exit
                int     21h

macht3:         mov     cx,ax           ; verhef cijfer tot 3e macht en voeg
                mul     cx              ; toe aan bx
                mul     cx
                add     bx,ax
                ret

wrtnum:         add     dl,30h          ; conversie hex-ascii
                mov     ah,02h          ; character schrijven
                int     21h
                ret

Code Ends
  End           start
