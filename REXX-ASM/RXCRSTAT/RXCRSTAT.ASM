; RXCRSTAT.ASM
;
;   REXX cursor state - uitgebreide versie
;   Hans van Kranenburg 1996 - voor PC DOS 7 REXX
;
;   Als er geen paramters worden opgegeven, retourneert deze functie de
;   huidige instelling. 1 betekent dat de cursor aanstaat en 0 betekent dat
;   deze uitstaat. Deze versie van RxCrStat herkent alleen dat de cursor uit-
;   staat als deze door RxCrStat zelf is uitgezet. Dit zal waarschijnlijk geen
;   problemen geven omdat dit de enige manier is om het in REXX te doen.
;

Code Segment
  Assume        cs:Code,ss:Code,ds:Code,es:Code

  ; Begin Data
  Org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  RXRESULT      dd      ?
  ; Einde Data

  Org           100h

Start:          cmp     RXARGC,0001h    ; Maximaal 1 parameter
                ja      ErrorExit       ; meer? -> ErrorExit
                cmp     RXARGC,0000h    ; Bij 0 parameters naar uitbreiding
                je      Uitb            ;   springen

  ; Oorspronkelijke RxCrStat ->
                LDS     SI,RXARGV       ; ® adres Arg(1)-pointer ¯
                MOV     BP,[SI]         ; bp=Length(Arg(1))
                LDS     SI,[SI+02h]     ; ® adres van Arg(1) ¯
                LODSW                   ; ax=Left(Arg(1),2)
                AND     AX,0DFDFh       ; AND ax met 11011111b -> hoofdletters
                CMP     BP,03h          ; Select; When bp=3 'off'
                JZ      jmp_oorsp1      ;     Then jmp_oorsp1
                CMP     BP,02h          ;   When bp<>2
                JNZ     ErrorExit       ;     Then ErrorExit
                CMP     AX,4E4Fh        ;   When ax<>4E4F 'ON'
                JNZ     ErrorExit       ;     Then ErrorExit
                JMP     jmp_oorsp2      ;   Otherwise jmp_oorsp2; End

jmp_oorsp1:     CMP     AX,464Fh        ; If ax<>464F 'OF'
                JNZ     ErrorExit       ;   Then ErrorExit
                LODSB                   ; al=Substr(Arg(1),3,1)
                AND     AL,0DFh         ; AND al met 11011111b -> hoofdletter
                CMP     AL,46h          ; If al<>46 'F'
                JNZ     ErrorExit       ;   Then ErrorExit

jmp_oorsp2:     MOV     AH,03h          ; ch=starting scan line
                INT     10h             ; cl=ending scan line
                AND     CH,0DFh         ; AND ch met 11011111b -> bit 5 uit
                                        ;   (als die nog niet uit was)
                                        ;   de cursor is er nu weer als de
                                        ;   grootte mbv functie 3 wordt in-
                                        ;   gesteld.
                CMP     BP,03h          ; If bp<>3 (bp='ON')
                JNZ     jmp_oorsp3      ;   Then jmp_oorsp3 Nop
                OR      CH,20h          ; Else OR ch met 00100000b
                                        ;   hier wordt bit 5 aangezet
                                        ;   (als die nog niet aan was)
                                        ;   als bit 5 aan is dan is de begin-
                                        ;   scanline groter als eindscanline
                                        ;   en is de cursor niet te zien
jmp_oorsp3:     MOV     AH,01h          ;   SetCursorSize(startline,endline)
                INT     10h             ;                 CH        CL
  ; <- Oorspronkelijke RxCrStat
                jmp     Exit            ; Afsluiten

Uitb:           les     di,RXRESULT
                mov     ah,03h          ; scanlines cursor ophalen
                int     10h             ; ch=start cl=end
                test    ch,00100000b    ; als deze bit aanstaat heeft RxCrStat
                jnz     jmp_uitb1       ;   de cursor eerder een keer uitgezet
                mov     al,'1'          ; '1'
                jmp     jmp_uitb2
jmp_uitb1:      mov     al,'0'          ; '0'
jmp_uitb2:      stosb

Exit:           mov     ax,4C00h        ; Afsluiten
                int     21h

ErrorExit:      mov     ax,4C01h        ; Afsluiten met errorlevel 1
                int     21h

Code Ends
  End           Start
