; MUL.ASM - Hans van Kranenburg 08-23-1996 : berekent produkt van twee getallen
; Mijn allereerste helemaal zelf geschreven assemblerprogramma!

  cr            equ     0DH
  lf            equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; Begin Data
  msg1          db      'Eerste cijfer: $'
  msg2          db      cr,lf,'Tweede cijfer: $'
  msg3          db      cr,lf,'Produkt is: $'
  enter         db      cr,lf,'$'
  ; Einde Data

codestart:      mov     dx,offset msg1  ; msg1 (cijfer1) afbeelden
                call    wrtstr
                call    getnum          ; input cijfer 1, in al
                mov     bl,al           ; kopie cijfer in bl
                mov     dx,offset msg2  ; msg2 (cijfer2) afbeelden
                call    wrtstr
                call    getnum          ; input cijfer 2, in al
                mul     bl              ; ax = al * bl
                aam                     ; de twee cijfers in unpacked BCD in ax
                push    ax              ; ax bewaren
                mov     dx,offset msg3  ; msg3 (produkt) afbeelden
                call    wrtstr
                pop     ax              ; ax terug
                mov     dh,al           ; cijfer1 (hex) in dl
                mov     dl,ah           ; cijfer 2 veilig stellen
                cmp     dl,00h          ; kijken of eerste getal een 0 is
                jz      jump            ; dan niet afbeelden
                call    wrtnum          ; eerste getal afbeelden
jump:           mov     dl,dh           ; output voorbereiden cijfer2
                call    wrtnum          ; tweede getal afbeelden
                mov     dx,offset enter ; nog een crlf er achteraan
                call    wrtstr
                mov     ax,4C00h        ; exit
                int     21h

wrtstr:         mov     ah,09h          ; string schrijven
                int     21h
                ret

getnum:         mov     ah,01h          ; character lezen
                int     21h
                sub     al,30h          ; conversie ascii-hex
                ret

wrtnum:         add     dl,30h          ; conversie hex-ascii
                mov     ah,02h          ; character schrijven
                int     21h
                ret

Code Ends
  End           start
