; PCDIAL.ASM ;(PCDIAL.RX)
;
;  ; PC-Dial v1.00  PC DOS 7 REXX External Function
;  ; Hoort bij PC-Dial v1.00 REXX (PCDIAL.BAT)
;  ;
;  ; Function Call:
;  ;   PCDIAL(numbers)
;  ;
;  ; e.g. PCDIAL('*04346695#')
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ;org           0082h
  ;RXARGC        dw      ?
  ;RXARGV        dd      ?

  org           0100h
start:          jmp     pcdial

  time_old      dw      ?,?
  s_teller      db      ?
  s_eind        db      ?

  ;                     Nummer            Toets   Hz
  freq          dw      020Ch           ; 0       2277
                dw      0272h           ; 1       1906
                dw      024Ah           ; 2       2033
                dw      0224h           ; 3       2174
                dw      025Ah           ; 4       1979
                dw      0236h           ; 5       2106
                dw      0213h           ; 6       2247
                dw      0242h           ; 7       2061
                dw      0221h           ; 8       2188
                dw      0200h           ; 9       2329
                dw      01EDh           ; #       2418
                dw      022Ah           ; *       2150
phone_number    db      '0123456789#*'


pcdial:         ;cmp     RXARGC,0001h    ; Controleren aantal parameters
                ;jne     exit

                call    int_set         ; interruptvector int 1Ch omleggen

                ;lds     di,RXARGV       ; pointer to argument array
                ;mov     cx,[di]         ; length arg1
                ;lds     si,[di+02h]     ; arg 1
        lea     si,phone_number
        mov     cx,0Bh
                cld

pcd_loop1:      push    cx
                lodsb                   ; nummer ophalen
                cmp     al,23h          ; '#'
                jne     pcd_jp1
                sub     al,19h          ; maak er 0Ah van -> opzoeken in tabel
                jmp     pcd_jp3

pcd_jp1:        cmp     al,2Ah          ; '*'
                jne     pcd_jp2
                sub     al,1Fh          ; maak er 0Bh van -> opzoeken in tabel
                jmp     pcd_jp3

pcd_jp2:        sub     al,30h          ; naar hex
                cmp     al,09h          ; is het een getal
                ja      errorexit       ; nee -> fout

pcd_jp3:        call    sound           ; laat nummer horen en pauze

                pop     cx
                loop    pcd_loop1

exit:           call    int_back        ; oude interruptvector 1Ch weer terug
                mov     ax,4C00h        ; afsluiten
                int     21h

errorexit:      call    int_back        ; oude interruptvector 1Ch weer terug
                mov     ax,4C01h        ; afsluiten met errorcode
                int     21h

  ; interruptvector int 1Ch omleggen
int_set:        mov     ax,351Ch        ; adres timer-interrupt ophalen
                int     21h
                mov     time_old,bx     ; offset
                mov     time_old+02h,es ; segment
                lea     dx,sound_ti     ; offset nieuwe timer-routine
                mov     ax,251Ch        ; nieuwe timer-routine zetten
                int     21h
                ret

  ; oude interruptvector 1Ch weer terug
int_back:       mov     cx,ds           ; interrupt vector zetten
                mov     ax,251Ch
                lds     dx,dword ptr time_old ; oud adres naar DS:DX
                int     21h
                mov     ds,cx           ; DS terughalen
                ret

sound           proc    near
                xor     ah,ah           ; nummer toets in bx
                mov     bx,ax
                shl     bx,01h
                mov     al,0B6h         ; opwekking toon voorbereiden
                out     43h,al          ; waarde naar timer-command-register
                mov     ax,freq[bx]     ; nummer toon opzoeken
                out     42h,al          ; lo-byte naar timer-counter-register
                mov     al,ah
                out     42h,al          ; hi-byte naar timer-counter-register
                in      al,61h          ; luidspreker-stuurbit inlezen
                or      al,11b          ; twee laagste bits schakelen speaker in
                mov     s_eind,01h      ; noot moet nog worden gespeeld
                mov     s_teller,02h    ; duur noot opslaan (in 1/18.2 sec)
                out     61h,al          ; speaker aan

play:           cmp     s_eind,00h      ; teller bij 0 ?
                jne     play            ; nee -> wachten

                in      al,61h          ; luidspreker-stuurbit inlezen
                and     al,11111100b    ; twee laagste bits wissen
                out     61h,al          ; speaker uit

                mov     s_eind,01h
                mov     s_teller,01h    ; pauze
pauze:          cmp     s_eind,00h      ; teller bij 0 ?
                jne     pauze           ; nee -> wachten

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