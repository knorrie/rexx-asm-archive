; NASM SOURCE
;
; build with:
;    nasm -f bin ?.? -o ?.?
;

                BITS 16

                SECTION .text

                call    hoi
                mov     word [gfofio],8888h

                mov     ax,4C00h
                int     21h

hoi:            mov     dx,string
                mov     ah,09h
                int     21h
                ret



                SECTION .data

  string        db      'hoi',00h

                SECTION .bss

  gfoifo        resb    8192
  gfofio        resw    1



