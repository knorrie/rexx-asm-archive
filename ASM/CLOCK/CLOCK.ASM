; Clock v2.00 - J.M. van Kranenburg - NASM

                BITS    16
                ORG     100h

                SECTION .data

  ; digits data
da              dw      d0, d1, d2, d3, d4, d5, d6, d7, d8, d9
d0              db      04h
                dw      0081h, 0889h, 0207h, 8287h
d1              db      01h
                dw      0889h
d2              db      05h
                dw      0009h, 4049h, 8089h, 1839h, 5071h
d3              db      04h
                dw      0007h, 4047h, 8087h, 0889h
d4              db      03h
                dw      0041h, 4247h, 0889h
d5              db      05h
                dw      0009h, 4049h, 8089h, 1031h, 5879h
d6              db      05h
                dw      0081h, 4889h, 0209h, 4247h, 8287h
d7              db      02h
                dw      0007h, 0889h
d8              db      05h
                dw      0081h, 0889h, 0207h, 4247h, 8287h
d9              db      05h
                dw      0041h, 0889h, 0207h, 4247h, 8087h

  ; colors
black           equ     00h
blue            equ     10h
green           equ     20h
cyan            equ     30h
red             equ     40h
magenta         equ     50h
brown           equ     60h
white           equ     70h

fgc             equ     red             ; foreground color (digits)
bgc             equ     black           ; background color

  ; time
time_h          dw      0FFFFh          ; tijdsaanduidingen op scherm
time_m          dw      0FFFFh
stipc           db      fgc             ; on/off (fgc/bgc)
  ; pos
space           equ     03h             ; space between digits (cols)
add1            equ     22+3*space
add2            equ     10+space
starty          equ     08h             ; begin vertical position
startx          equ     0Dh+add2        ; begin horizontal position (2nd digit)

stip1y          equ     starty+2       ; beginposities beide stippen
stip2y          equ     starty+6
stipx1          equ     startx-add2+2*space+20
stipx2          equ     stipx1+1

                SECTION .text

start:          mov     ax,0503h        ; naar video page 03h
                int     10h
                mov     ax,0600h        ; scherm leegmaken
                mov     bh,bgc
                mov     cx,0000h
                mov     dx,1950h
                int     10h
                mov     ah,03h          ; cursor scanlines opvragen
                int     10h
                or      ch,20h          ; onmogelijke cursorgrootte
                mov     ah,01h          ; stel cursurgrootte in
                int     10h

  ; hier begint de time-loop
time:           mov     ah,11h          ; toets wachtende ?
                int     16h
                jnz     exit            ; ja -> exit

                mov     ah,2Ch          ; tijd ophalen
                int     21h             ; ch=h cl=m dh=s dl=1/100s

                push    cx              ; hours / min

  ; stip is eerste helft seconde aan, tweede helft uit
stip:           cmp     dl,50
                ja      .jp1

             ; eerste helft seconde
                cmp     byte [stipc],fgc ; staat stip er al ?
                je      .jp2            ; ja
                mov     byte [stipc],fgc ; nee -> zet stip aan
                jmp     .jp3            ; beeld stip af

.jp1:        ; tweede helft seconde
                cmp     byte [stipc],bgc ; is stip al weg ?
                je      .jp2            ; ja
                mov     byte [stipc],bgc ; nee -> zet stip uit
                ;jmp     .jp3           ; beeld stip af

.jp3:        ; stip afbeelden
                mov     ax,0600h        ; bios clear box
                mov     bh,[stipc]      ; kleur stip
                mov     cl,stipx1       ; stip start x
                mov     dl,stipx2       ; stip end x

                mov     ch,stip1y       ; top row stip 1
                mov     dh,ch           ; bottom row stip 1
                int     10h             ; stip 1

                mov     ax,0600h        ; voor geval dat rotbios register niet
                                        ; voor me bewaart
                mov     ch,stip2y       ; top row stip 2
                mov     dh,ch           ; bottom row stip 2
                int     10h             ; stip 2

.jp2:        ; einde stip

                pop     cx              ; hours / min
                push    cx
  ; minuten controleren en evt afbeelden
                mov     al,cl           ; minuten actuele tijd
                mov     bl,01h          ; bl=01h -> evt. voorloopnul wel afb.
                mov     dl,startx+add1  ; start x pos
                mov     dh,starty       ; start y pos
                mov     bp,dx           ; start pos op scherm
                mov     dx,[time_m]     ; tijd die nu op scherm staat
                call    chk             ; controleren met actuele tijd
                mov     [time_m],ax     ;  en evt. schermupdate

                pop     cx
  ; uren controleren en evt afbeelden
                mov     al,ch           ; uren actuele tijd
                xor     bl,bl           ; bl=00h -> evt. voorloopnul niet afb.
                mov     dl,startx       ; start x pos
                mov     dh,starty       ; start y pos
                mov     bp,dx           ; start pos op scherm
                mov     dx,[time_h]     ; tijd die nu op scherm staat
                call    chk             ; controleren met actuele tijd
                mov     [time_h],ax     ;  en evt. schermupdate

                jmp     time            ; einde time-loop

        ; exit
exit:           mov     ah,10h          ; ja -> toets ophalen
                int     16h

                mov     ah,03h          ; cursor scanlines opvragen
                int     10h
                and     ch,0DFh         ; oorspronkelijke cursorgrootte
                mov     ah,01h          ; zet cursor aan
                int     10h

                mov     ax,0500h        ; weer terug naar video page 0
                int     10h

                mov     ax,4C00h        ; bye
                int     21h

chk:            xor     ah,ah           ; 1-byte hex -> 2-byte BCD
                mov     cl,0Ah
                div     cl
                push    ax

                cmp     ah,dh           ; tweede digit
                je      .jp1
                call    chngscrdig      ; doe digit2 schermupdate
.jp1:           pop     ax
                push    ax
                sub     bp,add2         ; startpos 1 digit terug
                mov     ah,al           ; eerste digit
                mov     dh,dl
                cmp     ah,dh           ; scherm klopt nog ?
                je      .jp2            ; ja -> klaar
                cmp     ah,00           ; digit1 is nul ?
                jne     .jp3            ; nee -> zowiezoo afbeelden
                cmp     bl,00h          ; ja -> afbeelden ?
                je      .jp2            ; nee -> klaar
.jp3:           call    chngscrdig      ; doe digit1 schermupdate

.jp2:           pop     ax
                ret

chngscrdig:     xchg    ah,al
                push    ax

                mov     ax,0600h        ; digithok leegmaken
                mov     bh,bgc
                mov     cx,bp
                mov     dx,bp
                add     dl,09h
                add     dh,08h
                int     10h

                pop     ax
                cld
                xor     ah,ah           ; digit-data opzoeken
                mov     si,ax
                shl     si,01h
                mov     si,[da+si]
                lodsb                   ; aantal blokken waaruit digit is
                mov     cx,ax           ;   opgebouwd
.loop1:          push    cx              ; alle blokken afbeelden
                 mov     cx,bp
                 mov     dx,bp
                 lodsw                   ; blokdata
                 push    ax
                 and     ax,0F0Fh        ; filter begin-x / eind-x
                 add     cl,ah           ; left col
                 add     dl,al           ; right col
                 pop     ax
                 and     ax,0F0F0h       ; filter begin-y / eind-y
                 push    cx
                 mov     cl,04h
                 shr     ax,cl
                 pop     cx
                 add     ch,ah           ; top row
                 add     dh,al           ; bottom row
                 mov     ax,0600h        ; BIOS clear box
                 mov     bh,fgc          ; digit color
                 int     10h
                 pop     cx
                loop    .loop1           ; volgende blok
                ret
