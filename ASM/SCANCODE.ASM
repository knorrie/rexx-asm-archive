; SCANCODE.COM - vraagt toets op en geeft code van die toets
; bv. '5' -> 35, ALT-TAB -> 00A5

cseg    segment
        assume  cs:cseg
        org 100h

start:  mov     ah,08h          ; ¿ 1 toets opvragen
        int     21h             ; Ù
        cmp     al,'1'
        je      bye
        mov     bl,al           ; waarde veilig stellen in BL
        mov     dl,bl           ; kopie om mee te werken in DL
        mov     cl,04h          ; ¿ links cijfer in rechts zetten,
        shr     dl,cl           ; Ù links nullen (bv. AB Ä-> 0A)
        call    afb             ; hex/ASCII conversie + afbeelden
        mov     dl,bl           ; kopie om mee te werken in DL
        and     dl,0fh          ; links cijfer wissen (bv. AB Ä-> 0B)
        call    afb             ; hex/ASCII conversie + afbeelden
        jmp     start           ; dan nog een byte doen
bye:    mov     ax,4C00h        ; ¿ anders afsluiten
        int     21h             ; Ù

afb     proc    near            ; afbeelden specified as a proc near
        add     dl,30h          ; ¿
        cmp     dl,3ah          ; ³ hex/ASCII conversie
        jl      cijfer          ; ³
        add     dl,07h          ; Ù
cijfer: mov     ah,02h          ; ¿ letter afbeelden
        int     21h             ; Ù
        ret                     ; return
afb     endp

cseg    ends                    ; end of code segment
        end     start           ; end of assembly language program
