; FIXBEEP 1.00                                         Hans van Kranenburg 1997

; Vervangt lompe beep van DOS door Linux-like-beep
; Deze is korter, dus je zit niet zo lang te wachten als de toetsenbordbuffer
; toevallig vol zit met beep-codes

; Int 21h, functie 02h wordt voorkomen als er 07h (beep) in dl opgegeven is
; Via int 1Ch wordt de lengte van het afspelen geregeld, tijdens het beepen
; zit er een stukje fixbeep aan de int 1Ch-routine geplakt

; Dit is de allereerste versie van fixbeep
; Er zit geen uninstaller in, ook geen mogelijkheid om te kijken of fixbeep
; al geinstallerd is

code            segment
  assume        cs:code,ss:code,ds:code,es:code
  org           0100h

main            proc    far

;stacktop:                               ; allow the stack to overwrite the
                                        ; command line in the PSP
progstart:      jmp     init

  int21_old     dw      ?,?
  ;oldss         dw      ?
  ;oldsp         dw      ?
  ;codeseg       dw      ?

  int1c_old     dw      ?,?
  count         db      ?               ; aantal 1/18.2 sec dat beep duurt
  playok        db      ?               ; als count is 0 dan playok wordt 0

beep            proc    near

  ; set up stack frame
  ;              mov     cs:oldss,ss
  ;              mov     cs:oldsp,sp
  ;              cli
  ;              mov     ss,cs:codeseg
  ;              mov     sp,offset stacktop
  ;              sti

  ; timer-interrupt omleiden
                push    ax
                push    bx
                push    dx

                push    es              ; interrupt vector int1c veranderen
                xor     ax,ax
                mov     es,ax
                mov     ax,es:[1Ch*4]
                mov     dx,es:[1Ch*4+2]



                mov     cs:int1c_old,bx ; offset
                mov     cs:int1c_old+02h,es ; segment

                lea     dx,cs:newint1c  ; offset nieuwe timer-routine
                mov     ax,251Ch        ; nieuwe timer-routine zetten
                int     21h

  ; afspelen toon
                mov     al,0B6h         ; opwekking toon voorbereiden
                out     43h,al          ; waarde naar timer-command-register
                mov     ax,1612d     ;!!; 4e octaaf, G
                out     42h,al          ; lo-byte naar timer-counter-register
                mov     al,ah
                out     42h,al          ; hi-byte naar timer-counter-register
                in      al,61h          ; luidspreker-stuurbit inlezen
                or      al,11b          ; twee laagste bits schakelen speaker in
                mov     cs:playok,01h   ; noot moet nog worden gespeeld
                mov     cs:count,02h ;!!; duur noot opslaan (in 1/18.2 sec)
                out     61h,al          ; speaker aan

play:           cmp     cs:playok,00h   ; teller bij 0 ?
                jne     play            ; nee -> wachten

                in      al,61h          ; luidspreker-stuurbit inlezen
                and     al,11111100b    ; twee laagste bits wissen
                out     61h,al

  ; restore int1Ch vector
                mov     cx,ds           ; interrupt vector zetten
                mov     ax,251Ch
                lds     dx,dword ptr cs:[int1c_old] ; oud adres naar DS:DX
                int     21h
                mov     ds,cx           ; DS terughalen
                ret

  ; restore original stack frame
  ;              cli
  ;              mov     ss,cs:oldss
  ;              mov     sp,cs:oldsp
  ;              sti

                ret

beep            endp

  ; nieuwe timer-interrupt
newint1c        proc    far             ; wordt 18.2x per sec opgeroepen

                dec     cs:count        ; tijdteller verlagen
                jnz     st_end          ; als nog niet 0, dan einde
                mov     cs:playok,00h   ; duur noot is voorbij

st_end:         jmp     dword ptr cs:[int1c_old] ; naar oude interrupt-routine

newint1c        endp

  ; controleert of functie 02h, teken 07h wordt aangeroepen, en geeft in dat
  ; geval zelf een beep ipv DOS
newint21        proc    far             ; interrupt 21h

                cmp     ah,02h
                jne     go21
                cmp     dl,07h
                jne     go21
                call    beep
                iret

go21:           jmp     dword ptr cs:[int21_old] ; naar echte int21

newint21        endp

  ; beep old beep
  ; install int21h trap
  ; beep to test new routine
  ; tsr main program
init            proc    near

                ;mov     cs:codeseg,cs   ; ivm stack

                mov     ah,02h          ; doe oude beep
                mov     dl,07h
                int     21h

                mov     ax,3521h        ; adres int21h ophalen
                int     21h
                mov     int21_old,bx    ; offset
                mov     int21_old+02h,es ; segment

                lea     dx,newint21     ; offset newint21
                mov     ax,2521h        ; newint21 zetten
                int     21h

                mov     ah,02h          ; test de hele zooi
                mov     dl,07h
                int     21h

                mov     ax,3100h        ; tsr
                lea     dx,init         ; calculate program size and leave
                mov     cl,04h
                shr     dx,cl
                inc     dx
                int     21h

init            endp

main            endp

code            ends
  end           progstart
