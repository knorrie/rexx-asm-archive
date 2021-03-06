; SCANC.COM
;   Input : toets(encombinatie)
;   Output: scancode en toetscode
; Programma beeindigen met ALT-[1]

Code    Segment
        Assume  cs:Code
        Org     100h

start:          mov     ah,10h          ; Functie 10h van int 16h
                int     16h
                cmp     ax,0001h        ; ALT-[1] ingetoetst?
                je      byebye          ; dan afsluiten
                mov     dl,ah
                call    afb
                mov     dl,al
                call    afb
                mov     ah,02h          ; CR/LF afbeelden
                mov     dl,0Dh
                int     21h
                mov     dl,0Ah
                int     21h
                jmp     start           ; nog een toets(encominatie)

byebye:         mov     ax,4C00h
                int     21h             ; bye bye

afb     proc    near
                push    ax
                mov     bl,dl           ; tijdelijke opslag i.v.m. 2x gebruiken
                mov     cl,04h          ; � links cijfer in rechts zetten,
                shr     dl,cl           ; � links nullen (bv. AB �-> 0A)
                call    afb2            ; hex/ASCII conversie + afbeelden
                mov     dl,bl           ; kopie om mee te werken in DL
                and     dl,0Fh          ; links cijfer wissen (bv. AB �-> 0B)
                call    afb2            ; hex/ASCII conversie + afbeelden
                pop     ax
                ret                     ; return
afb     endp

afb2    proc    near
                add     dl,30h          ; �
                cmp     dl,3ah          ; � hex/ASCII conversie
                jl      jmp_afb2        ; �
                add     dl,07h          ; �
jmp_afb2:       mov     ah,02h          ; � letter afbeelden
                int     21h             ; �
                ret
afb2    endp

Code    Ends
  End   start
