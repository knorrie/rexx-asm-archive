; Produceert toon

code            segment
  assume        cs:code,ss:code,ds:code,es:code
  org           0100h

start:          jmp     sound

  time_old      dw      ?,?
  s_teller      db      ?
  s_eind        db      ?

sound           proc    near

  ; timer-interrupt omleiden
                mov     ax,351Ch        ; adres timer-interrupt ophalen
                int     21h
                mov     time_old,bx     ; offset
                mov     time_old+02h,es ; segment

                lea     dx,sound_ti     ; offset nieuwe timer-routine
                mov     ax,251Ch        ; nieuwe timer-routine zetten
                int     21h

  ; afspelen toon
                mov     al,0B6h         ; opwekking toon voorbereiden
                out     43h,al          ; waarde naar timer-command-register
                mov     ax,100d     ;!!; 4e octaaf, G (1612)
                out     42h,al          ; lo-byte naar timer-counter-register
                mov     al,ah
                out     42h,al          ; hi-byte naar timer-counter-register
                in      al,61h          ; luidspreker-stuurbit inlezen
                or      al,11b          ; twee laagste bits schakelen speaker in
                mov     s_eind,01h      ; noot moet nog worden gespeeld
                mov     s_teller,40h ;!!; duur noot opslaan (in 1/18.2 sec)
                out     61h,al          ; speaker aan

play:           cmp     s_eind,00h      ; teller bij 0 ?
                jne     play            ; nee -> wachten

                in      al,61h          ; luidspreker-stuurbit inlezen
                and     al,11111100b    ; twee laagste bits wissen
                out     61h,al

  ; oude timer-interrupt weer activeren
                mov     cx,ds           ; interrupt vector zetten
                mov     ax,251Ch
                lds     dx,dword ptr time_old ; oud adres naar DS:DX
                int     21h
                mov     ds,cx           ; DS terughalen
                ret

sound           endp

  ; nieuwe timer-interrupt
sound_ti        proc    far             ; wordt 18.2x per sec opgeroepen

                dec     cs:s_teller     ; tijdteller verlagen
                jnz     st_eind         ; als nog niet 0, dan einde
                mov     cs:s_eind,00h   ; duur noot is voorbij
st_eind:        jmp     dword ptr cs:[time_old] ; naar oude interrupt-routine

sound_ti        endp

code            ends
  end           start
