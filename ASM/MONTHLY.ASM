; monthly.com - geeft errorlevel 1 als het de eerste keer is dat monthly.com
;               in een maand wordt aangeroepen

code            segment
  assume        cs:code,ss:code,ds:code,es:code
  org           0100h

start:          jmp     codestart

  datafile      db      'E:\BATCH\'
                db      'MONTHLY.DAT',00h
  yyyy          dw      ?
  mm            db      ?

codestart:      mov     ax,3D02h        ; file openen als read/write
                lea     dx,datafile
                int     21h

                mov     bx,ax           ; file-handle

                mov     ah,3Fh          ; lezen uit file
                mov     cx,0003h        ; aantal te lezen bytes
                lea     dx,yyyy
                int     21h

                mov     ah,2Ah          ; datum ophalen
                int     21h
                cmp     cx,yyyy         ; controleren met file
                jne     exit1
                cmp     dh,mm
                jne     exit1
                jmp     exit0           ; allebei gelijk -> niet eerste keer

  ; als het de eerste keer op de dag is, die datum in de file zetten
exit1:          mov     yyyy,cx         ; nieuwe waarden voor in file
                mov     mm,dh
                mov     ax,4200h        ; verplaats read/write pointer
                xor     cx,cx
                xor     dx,dx           ; helemaal aan het begin
                int     21h
                mov     ah,40h          ; schrijf naar file
                mov     cx,0003h        ; aantal te schrijven bytes
                lea     dx,yyyy
                int     21h
                mov     bp,4C01h        ; Wel de eerste keer
                jmp     exit

exit0:          mov     bp,4C00h        ; Niet de eerste keer

exit:           mov     ah,3Eh          ; file sluiten
                int     21h
                mov     ax,bp           ; afsluiten
                int     21h

code            ends
  end           start
