; IT11VIEW.ASM (IT11VIEW.RX) - Initialise Yathzee-Top-11 Viewer
;
;   Hans van Kranenburg 1996  PC DOS 7 REXX External Function
;
; Vult het door IScreen gemaakte Yathzee-Top-11 scherm in
; Parameters:
;  - naam van Yathzee-Top-11 file als ASCIIZ string
;

vpage           equ     03h
offset11        equ     (vpage * 1000h) + (8d*160d) + (18d*2d)
move1           equ     26d             ; van naam naar score springen

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  Org           82h
  ; adressen van REXX parameters
  RXARGC        dw      ?
  RXARGV        dd      ?
  ; en stiekum nog iets
  score         dw      ?

  Org           100h
start:          cmp     RXARGC,0001h    ; 1 parameter : filename
                jne     errorexit

  ; Haal filename op, open bestand, zet read/write-pointer op positie 5h
  ; (niet op 6h omdat Rexx telt vanaf 1, hier vanaf 0)
                lds     di,RXARGV       ; pointer to argument array
                lds     dx,[di+02h]     ; first argument : filename
                mov     ax,3D00h        ; openen als read-only
                int     21h
                mov     bx,ax           ; file handle in bx
                mov     ax,4200h        ; verplaats read/write pointer
                xor     cx,cx           ; naar positie 5h vanaf begin
                mov     dx,0005h
                int     21h

  assume        ds:nothing,es:nothing

  ; Lees Top-11 in, dump namen direct op scherm, converteer getal naar ascii
                mov     dx,0B800h       ; segment videomem
                mov     ds,dx
                mov     es,dx
                mov     dx,offset11     ; offset eerste naam

                mov     cx,11d          ; 11 namen+scores lezen
loop_0:         push    cx

                mov     cx,20d          ; naam = 20 tekens
loop_1:         push    cx
                mov     ah,3Fh          ; lezen uit file
                ;mov     bx,..           ; file-handle nog in bx
                mov     cx,0001h        ; 1 teken lezen
                int     21h             ; in videomem gooien bij es:dx
                add     dx,0002h        ; twee bytes verder (attribuut oversl.)
                pop     cx
                loop    loop_1

                mov     di,dx           ; nu de bijbehorende score
                add     di,move1        ; in videomem naar offset voor score
                push    dx
                push    ds              ; videomemsegment
                push    cs              ; codesegment in ds
                pop     ds
                mov     ah,3Fh          ; lezen uit file
                ;mov     bx,..           ; file-handle nog in bx
                lea     dx,cs:score
                mov     cx,0002h        ; 2 bytes lezen
                int     21h
                std                     ; achteruit getallen van score op
                                        ;  scherm schrijven
                mov     ax,score        ; score (hex)
                pop     ds              ; videomem terug
                xchg    ah,al
                mov     cx,000Ah
jp_0:           xor     dx,dx
                div     cx
                add     dl,30h          ; rest converteren naar ascii
                push    ax
                mov     al,dl
                stosb
                dec     di
                pop     ax
                test    ax,ax
                jnz     jp_0
                pop     dx

                add     dx,120d         ; spring naar volgende regel
                pop     cx
                loop    loop_0

exit:           mov     ax,4C00h        ; bye bye
                int     21h

errorexit:      mov     ax,4C01h        ; bye bye with error
                int     21h

code            ends
  end           start
