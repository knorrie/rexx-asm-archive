; USRINPUT.ASM (USRINPUT.RX)
;
;   UserInput v2.00 - Hans van Kranenburg 1996 - voor PC DOS 7 REXX
;
;   History:
;
;   Versie 1.00  In Produktie gegaan: -
;   Wijzigingen:
;     Dit is de alleereerste versie van UserInput, in REXX geschreven
;
;   Versie 1.01  In Produktie gegaan: - (gelijk met Yathzee v2.30)
;   Wijzigingen:
;     m.b.v. uitgebreide RxCrStat kan nu gecontroleerd worden of de cursor bij
;     het aanroepen van UsrInput wel of niet getoond wordt. Bij het verlaten
;     van UsrInput kan die cursor dan weer netjes teruggezet worden.
;
;   Versie 2.00  In Produktie gegaan: -
;   Wijzigingen:
;     UserInput nu volledig in Assembler!!
;     Much many more functies, o.a. kleur
;     USRINPUT.TXT toegevoegd: zeer(!) beknopte handleiding
;       (ik heb 'm geloof ik een beetje te beknopt gemaakt, maar met enige
;        studie en wat geprobeer moet er wel uit te komen zijn, geloof ik,
;        als het echt niet lukt, stuur dan maar een E-mailtje)
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ; begin data 1
  org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  RXRESULT      dd      ?
  ; einde data 1

  org           100h
start:          jmp codestart

  ; begin data 2
   ; REXX arg 1 ->
  at            db      ?               ; aantal tekens
  opt           db      ?               ; opties
    ; bit                                bv.
    ;  0 - cursor on/off                 1
    ;  1 - echo on/off                   1
    ;  2 - uppercase                     0  -> 01011011b = 5Bh
    ;  3 - insert                        1
    ;  4 - enter nodig                   1
    ;  5 - str weg bij wijzigen          0
    ;  6 - wel/niet cursor-pos opgegeven 1
    ;  7 - wel/niet rchr opgegeven       0
  color         db      ?               ; kleur attribuut
  chr           db      ?               ; teken op lege plek
  cposrc        dw      ?               ; opgegeven cpos in row/col-formaat
  rchr          db      ?               ; replace character
   ; <- REXX arg 1

   ; REXX arg 2 ->
  str           db      0FFh dup(?)     ; input string
   ; <- REXX arg 2

  ls            db      ?               ; length str
  strsav        db      0FFh dup(?)     ; reservekopie beginwaarde str
  lssav         db      ?               ; reservekopie beginwaarde ls
  strrchr       db      0FFh dup(?)     ; str met rchr
  cposinp       dw      ?               ; cpos begin inputhok
  cpossav       dw      ?               ; cpos bij binnenkomst
  cstatsav      dw      ?               ; cstat (1/0+scanlines) bij binnenkomst
   ; string pointer is register bp
  vpage         db      ?               ; video page
  cols          db      ?               ; aantal kolommen op scherm
  ; einde data 2

  ; begin hoofdprogramma
codestart:      cmp     RXARGC,0002h    ; Controleren aantal parameters
                ja      errorexit       ; 0 < RXARGC <= 2
                cmp     RXARGC,0000h
                je      errorexit

                call    arg1            ; arg1 ophalen
                call    curssav         ; cursorinfo opslaan
                call    cposinit        ; cpostellers initialiseren
                call    arg2            ; str ophalen
                call    crstat          ; cursor on/off
                call    prtstr          ; afbeelden hok / inhoud (bij echo on)
                call    setcpos         ; cursor naar beginpositie
                call    input           ; userinput
                call    uppercase       ; convert to uppercase
                call    result          ; str bij REXX dumpen
                call    cursrestore     ; cursorinfo terughalen

exit:           mov     ax,4C00h        ; afsluiten
                int     21h
  ; einde hoofdprogramma

arg1            proc    near            ; ophalen en verwerken arg 1
                push    ds
                lds     di,RXARGV       ; pointer to argument array
                mov     bx,[di]         ; length arg 1 in bx !!
                cmp     bx,0004h        ; minimaal 4 bytes
                jb      errorexit
                cmp     bx,0007h        ; maximaal 7 bytes
                ja      errorexit
                lds     si,[di+02h]     ; arg 1
                cld                     ; arg 1 kopi‰ren in at, opt, color, chr
                lea     di,at           ;  en evt. cposrc en rchr
                mov     cx,bx           ; lengte arg 1
            rep movsb                   ; kopi‰ren
                pop     ds              ; ds weer terug
                cmp     at,00h          ; als gevraagde input-lengte 0 is, dan
                je      exit            ;  hebben we niets te doen
                                        ; controleren lengte arg 1
                test    opt,80h         ; rchr opgegeven ?
                jz      jp_arg1_0       ; nee
                cmp     bx,0007h        ; ja -> lengte 7 ?
                jne     errorexit       ; nee
                ret                     ; ja -> arg 1 OK
jp_arg1_0:      test    opt,40h         ; cpos opgegeven ?
                jz      jp_arg1_1       ; nee
                cmp     bx,0006h        ; ja -> lengte 6 ?
                jne     errorexit       ; nee
                ret                     ; ja -> arg 1 OK
jp_arg1_1:      cmp     bx,0004h        ; lengte niet 4 ?
                jne     errorexit       ; dat kan niet
                ret
arg1            endp

  ; -- ErrorExit --
errorexit:      mov     ax,4C01h        ; afsluiten met errorcode
                int     21h
  ; -- ErrorExit --

curssav         proc    near            ; save cursor info
                mov     ah,0Fh          ; get screen info
                int     10h
                mov     vpage,bh        ; screen page
                mov     cols,ah         ; no. cols
                mov     ah,03h          ; get cursor info
                int     10h
                mov     cstatsav,cx     ; cursor on/off+scanlines
                mov     cpossav,dx      ; current cpos row/col
                ret
curssav         endp

cposinit        proc    near            ; initialiseren cpos
                test    opt,40h         ; cursorpos opgegeven ?
                jnz     jp_cposinit_0   ; ja
                mov     ax,cpossav      ; nee -> gebruik cpossav
                jmp     jp_cposinit_1
jp_cposinit_0:  mov     ax,cposrc       ; opgegeven cpos wandelend
                xchg    al,ah           ; col/row naar row/col
jp_cposinit_1:  mov     cposrc,ax       ; cpos wandelend
                mov     cposinp,ax      ; cpos vast
                ret
cposinit        endp

arg2            proc    near            ; ophalen arg2, str en bp init
                mov     al,chr          ; str en strrchr vullen met chr
                mov     cx,00FFh
                lea     di,str
                cld
            rep stosb
                mov     cx,00FFh
                lea     di,strrchr
            rep stosb
                mov     ls,00h          ; lengte str 0 stellen
                xor     bp,bp           ; bp is offset in str voor edit
                cmp     RXARGC,0001h    ; geen str opgegeven
                je      jp_arg2_1
                push    ds
                lds     di,RXARGV       ; pointer to argument array
                mov     bx,[di+06h]     ; length arg 2
                xor     ch,ch
                mov     cl,es:at
                cmp     bx,cx           ; maximale lengte str is at
                ja      errorexit
                lds     si,[di+08h]     ; arg 2
                cld                     ; arg 2 kopi‰ren in str
                lea     di,str
                mov     cx,bx           ; lengte
            rep movsb                   ; kopi‰ren
                pop     ds              ; ds weer terug
                mov     ls,bl           ; nu ds weer terug is de lengte in ls
                                        ; opslaan
jp_arg2_1:      test    opt,80h         ; rchr ?
                jz      jp_arg2_0       ; nee
                mov     cx,bx           ; strrchr vullen met rchr's
                mov     al,rchr
                lea     di,strrchr
            rep stosb
jp_arg2_0:      lea     si,str          ; reservekopie str/ls in strsav/lssav
                lea     di,strsav
                cld
                mov     cx,0100h
            rep movsb
                ret
arg2            endp

crstat          proc    near            ; cursor on/off instellen
                mov     ah,03h          ; scanlines opvragen
                int     10h
                mov     bh,ch           ; starting scanline
                mov     bl,opt          ; options
                push    cx              ; scanlines
                mov     cl,05h          ; bit 0 naar bit 5 verschuiven
                shl     bl,cl
                pop     cx
                and     bx,2020h        ; alleen bit 5 overhouden
                and     bh,bl           ; bit 5 in bh wordt 1 als crstat en
                                        ;  opgegeven cursor gelijk zijn
                                        ;  N.B. bit 5 van starting scanline
                                        ;  die in bh staat is gezet als de
                                        ;  cursor door REXX is UITgezet !
                jnz     jp_crstat_0     ; als bit 5 niet gezet is hoeven de
                                        ;  scanlines ook niet opnieuw worden
                                        ;  ingesteld
                ret
jp_crstat_0:    xor     ch,bh           ; als cursor veranderd moet worden
                                        ;  bit 5 van starting scanl omgooien
                mov     ah,01h          ; scanlines instellen
                int     10h
                ret
crstat          endp

prtstr          proc    near            ; afbeelden hok met str of rchr en chr
                test    opt,02h         ; echo on ?
                jz      jp_prtstr_2     ; nee
                push    bp
                mov     ax,1300h        ; string afbeelden zonder dat de cursor
                mov     bh,vpage        ;  verplaatst wordt
                mov     bl,color        ; color attribute
                test    opt,80h         ; rchr ?
                jz      jp_prtstr_0
                lea     bp,strrchr      ; offset string met rchr
                jmp     jp_prtstr_1
jp_prtstr_0:    lea     bp,str          ; offset string
jp_prtstr_1:    xor     ch,ch
                mov     cl,at           ; aantal tekens
                mov     dx,cposinp      ; cpos begin hok
                int     10h
                pop     bp
jp_prtstr_2:    ret
prtstr          endp

input           proc    near            ; userinput
                mov     ah,00h          ; toetsenbordinvoer
                int     16h

jp_input_1:     cmp     al,20h          ; - valid characters -
                jb      jp_input_2
                call    validchr
                jmp     jp_input_11

jp_input_2:     cmp     ax,1C0Dh        ; - enter -
                jne     jp_input_3
                ret

jp_input_3:     cmp     ax,0E08h        ; - bs -
                jne     jp_input_4
                call    backspace
                jmp     jp_input_11

jp_input_4:     cmp     ax,5300h        ; - del -
                jne     jp_input_5
                call    delete
                jmp     jp_input_11

jp_input_5:     cmp     ax,4B00h        ; - left -
                jne     jp_input_6
                call    left
                jmp     jp_input_11

jp_input_6:     cmp     ax,4D00h        ; - right -
                jne     jp_input_7
                call    right
                jmp     jp_input_11

jp_input_7:     cmp     ax,4700h        ; - home -
                jne     jp_input_8
                call    home
                jmp     jp_input_11

jp_input_8:     cmp     ax,4F00h        ; - end -
                jne     jp_input_9
                call    end_
                jmp     jp_input_11

jp_input_9:     cmp     ax,5200h        ; - ins -
                jne     jp_input_10
                xor     opt,08h         ; ins omzetten in opt
                jmp     jp_input_11

jp_input_10:    cmp     al,1Bh          ; - esc -
                jne     jp_input_11
                call    escape
                ;jmp     jp_input_11

jp_input_11:    mov     dl,ls           ; stoppen als er geen enter hoeft
                cmp     dl,at           ;  gegeven te worden en het hok vol is
                jne     input           ; nieuwe input
                test    opt,10h
                jz      jp_input_12
                jmp     input           ; nieuwe input als enter wel/1 nodig
jp_input_12:    ret
input           endp

validchr        proc    near
                push    ax              ; getypte teken bewaren
  ; evt. hok clearen
                test    opt,20h         ; als bit 5 van opt is gezet hok
                jz      jp_vc_4         ;  clearen
                call    clear
  ; controleren of er wel ingevoegd kan worden
jp_vc_4:        mov     cl,at           ; at in cl
                cmp     ls,cl           ; hok vol ?
                jne     jp_vc_1         ; dan kan je niets meer invoegen
                test    opt,08h         ;  - als insert aan staat
                jnz     jp_vc_0
                xor     ch,ch           ;  - als insert uit staat en de cursor
                mov     cl,at           ;    aan einde hok staat
                cmp     bp,cx
                je      jp_vc_0
  ; ja -> controleren letter invoegen of toevoegen
jp_vc_1:        test    opt,08h         ; als insert dan rest opschuiven
                jnz     jp_vc_6
                xor     ch,ch           ; als insert uit staat en de cursor
                mov     cl,ls           ;  helemaal achteraan staat
                cmp     bp,cx           ;  (str, niet hok) dan wel een rchr
                je      jp_vc_5         ;  toevoegen
                jmp     jp_vc_2
  ; insert aan, boel opschuiven
jp_vc_6:        lea     di,str          ; van str naar str
                xor     ch,ch           ; ls in cx
                mov     cl,ls
                add     di,cx
                mov     si,di
                dec     si
                sub     cx,bp           ; aantal tekens schuiven
                std
            rep movsb
  ; en een rchr aan strrchr toevoegen
jp_vc_5:        inc     ls              ; str is nu een teken langer
                                        ; deze regel staat hier omdat hier
                                        ; langsgekomen wordt als er een teken
                                        ; aan str toegevoegd is
                test    opt,80h         ; rchr ?
                jz      jp_vc_2         ; nee
                lea     di,strrchr      ; rchr toevoegen aan strrchr
                xor     ch,ch
                mov     cl,ls
                dec     cx
                add     di,cx
                mov     al,rchr
                stosb
  ; teken invoegen of toevoegen
jp_vc_2:        lea     di,str          ; positie in string waar teken
                add     di,bp           ;  moet worden ingevoegd
                pop     ax
                stosb                   ; getypte teken invoegen
  ; str opnieuw afbeelden en cursor rechts
jp_vc_3:        call    prtstr
                jmp     right
jp_vc_0:        pop     ax
                ret
validchr        endp

backspace       proc    near
                test    opt,20h         ; als bit 5 van opt is gezet hok
                jz      jp_bs_0         ;  clearen
                jmp     clear
jp_bs_0:        cmp     bp,0000h        ; alleen als een teken voor de cursor
                je      jp_bs_1         ;  staat
                lea     si,str          ; van str naar str
                add     si,bp
                mov     di,si
                dec     di
                xor     ch,ch           ; aantal tekens dat naar voren
                mov     cl,ls           ;  geschoven moet worden
                sub     cx,bp
                cld
            rep movsb
                mov     al,chr
                stosb
                test    opt,80h         ; rchr ?
                jz      jp_bs_2         ; nee
                lea     di,strrchr      ; laatste rchr veranderen in chr
                mov     al,chr
                xor     ch,ch
                mov     cl,ls
                add     di,cx
                dec     di
                stosb
jp_bs_2:        dec     ls
                call    prtstr
                jmp     left
jp_bs_1:        ret
backspace       endp

delete          proc    near
                test    opt,20h         ; als bit 5 van
                jz      jp_del_0        ;  opt is gezet dan hok clearen
                jmp     clear
jp_del_0:       xor     ch,ch           ; niet als er niets meer valt te
                mov     cl,ls           ;  deleten
                cmp     bp,cx
                je      jp_del_2
                lea     si,str          ; van str naar str
                add     si,bp
                mov     di,si
                inc     si
                xor     ch,ch           ; aantal tekens dat naar voren
                mov     cl,ls           ;  geschoven moet worden
                sub     cx,bp
                cld
            rep movsb
                mov     al,chr
                stosb
                test    opt,80h         ; rchr ?
                jz      jp_del_1        ; nee
                lea     di,strrchr      ; laatste rchr veranderen in chr
                mov     al,chr
                xor     ch,ch
                mov     cl,ls
                add     di,cx
                dec     di
                stosb
jp_del_1:       dec     ls
                call    prtstr
jp_del_2:       ret
delete          endp

left            proc    near
                and     opt,0DFh        ; strweg uitzetten
                cmp     bp,0000h        ; cursor aan begin hok ?
                jne     jp_left_0       ; nee
                ret                     ; ja -> kan je niet verder naar links
jp_left_0:      dec     bp              ; string pointer verlagen
                test    cposrc,00FFh    ; al op eerste kolom schermregel?
                jnz     jp_left_1       ; nee -> gewoon naar rechts
                mov     ax,cposrc       ; ja ->
                sub     ax,0100h        ; 1 regel omhoog
                mov     al,cols         ; aan einde regel
                dec     al
                mov     cposrc,ax
                jmp     setcpos
jp_left_1:      dec     cposrc          ; cursor 1 positie naar links
                jmp     setcpos
left            endp

right           proc    near
                and     opt,0DFh        ; strweg uitzetten
                xor     ch,ch           ; ls in cx
                mov     cl,ls
                cmp     bp,cx           ; cursor aan einde hok (1 achter einde
                                        ;  van str) ?
                jne     jp_right_0      ; dan kan je niet verder naar rechts
                ret
jp_right_0:     inc     bp
                inc     cposrc          ; cursor 1 positie naar rechts
                mov     cx,cposrc
                cmp     cl,cols         ; aan einde schermregel?
                jae     jp_right_1      ; ja
                jmp     setcpos         ; nee
jp_right_1:     add     ch,01h          ; cursor regel omlaag aan begin
                xor     cl,cl
                mov     cposrc,cx
                jmp     setcpos
right           endp

home            proc    near
                and     opt,0DFh        ; strweg uitzetten
                cmp     bp,0000h        ; al op goede plek?
                jne     jp_home_0
                ret
jp_home_0:      xor     bp,bp
                mov     cx,cposinp
                mov     cposrc,cx
                jmp     setcpos
home            endp

end_            proc    near
                and     opt,0DFh        ; strweg uitzetten
                xor     ah,ah
                mov     al,ls           ; ls is aan einde gelijk aan bp
                cmp     bp,ax           ; al op goede plek ?
                jne     jp_end_0        ; nee -> zet 'm er neer
                ret                     ; ja -> OK
jp_end_0:       mov     bp,ax
                mov     cl,cols
                div     cl
                xchg    al,ah
                mov     cx,cposinp
                add     cx,ax
                mov     cposrc,cx
                jmp     setcpos
end_            endp

escape          proc    near
                and     opt,0DFh        ; strweg uitzetten
                lea     si,strsav       ; strsav en lssav terugkopi‰ren
                lea     di,str
                cld
                mov     cx,100h
            rep movsb
                test    opt,80h         ; strrchr ook weer terug
                jz      jp_esc_0
                lea     di,strrchr
                xor     ch,ch
                mov     cl,lssav
                mov     al,rchr
            rep stosb
                mov     cx,00FFh
                sub     cl,lssav
            rep stosb
jp_esc_0:       call    prtstr
                jmp     home            ; cursor op beginpositie
escape          endp

setcpos         proc    near            ; cursor positie instellen
                test    opt,01h
                jz      jp_setcpos_0
                mov     ah,02h
                mov     bh,vpage
                mov     dx,cposrc
                int     10h
jp_setcpos_0:   ret
setcpos         endp

uppercase       proc    near            ; a-z veranderen in A-Z
                test    opt,04h         ; uppercase ?
                jz      jp_upp_1
                lea     si,str
                mov     di,si
                xor     ch,ch
                mov     cl,ls
                jcxz    jp_upp_1
lp_upp_0:       lodsb
                cmp     al,61h          ; a
                jb      jp_upp_0
                cmp     al,7Ah          ; z
                ja      jp_upp_0
                xor     al,20h
jp_upp_0:       stosb
                loop    lp_upp_0
jp_upp_1:       ret
uppercase       endp

result          proc    near            ; str dumpen in rxresult string buffer
                les     di,RXRESULT
                lea     si,str
                xor     ch,ch
                mov     cl,ls
                cld
            rep movsb
                ret
result          endp

cursrestore     proc    near            ; beginwaarden cursor terugzetten
                mov     ah,01h          ; cursor state
                mov     cx,cstatsav
                int     10h
                mov     ah,02           ; cpos
                mov     bh,vpage
                mov     dx,cpossav
                int     10h
                ret
cursrestore     endp

clear           proc    near            ; hok/str/ls/bp/cposrc/cursor clear
                and     opt,0DFh        ; str weg bij eerste wijziging uit
                xor     ch,ch           ; str leegmaken met chr
                mov     cl,ls
                lea     di,str
                mov     al,chr
                cld
            rep stosb
                test    opt,80h         ; rchr ?
                jz      jp_clear_0      ; nee
                lea     di,strrchr
                mov     al,chr
            rep stosb
jp_clear_0:     call    prtstr          ; afbeelden leeg hok indien echo on
                mov     ls,00h          ; str heeft lengte 0
                ;jmp     home            ; bp en cursor aanpassen mbv home
                                         ; hoeft niet omdat als clear
                                         ;  aangeroepen wordt, de cursor altijd
                                         ;  aan begin hok staat
                ret
clear           endp

code            ends
  end           start
