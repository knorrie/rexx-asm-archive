;
;

Data Segment
  attributes    equ     this byte
  normal        db      07h
  reverse       db      70h
  intense       db      0Fh
  blink         db      87h
  intenseblink  db      8Fh
  reverseblink  db      0F0h
  revintblink   db      0F8h
Data Ends

WS Segment Stack
                dw      100h dup(?)
WS Ends

Code Segment
  Assume        cs:code,ds:data,ss:ws

start:          mov     ax,data         ; data segment
                mov     ds,ax
                mov     ax,0B800h        ; video memory
                mov     es,ax
                cld                     ; cls
                mov     di,0
                mov     al,' '
                mov     ah,normal
                mov     cx,2000d
                rep stosw
                mov     ah,0            ; lees chr
                int     16h
inrange:        cmp     al,31h          ; valid chr
                jc      done
                cmp     al,38h
                jnc     done
                sub     al,31h
                mov     bl,al
                mov     bh,0
                mov     ah,attributes[bx]
                mov     di,(1*160d)+(0*2)
                mov     al,0
                mov     dh,0
nextchr:        mov     es:[di]+1,ah
                mov     es:[di],al
                add     di,4
                add     dh,2
                cmp     dh,79d
                jb      nextcode
                add     di,160
                mov     dh,0
nextcode:       inc     al
                cmp     al,0h
                jz      nextattr
                jmp     nextchr
nextattr:       mov     ah,0
                int     16h
                jmp     inrange
done:           mov     di,0
                mov     al,' '
                mov     ah,normal
                mov     cx,2000d
                rep stosw
                mov     ax,4C00h
                int     21h

Code Ends
  End           start
