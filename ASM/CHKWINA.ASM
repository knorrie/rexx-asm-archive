; Controleert of de huidige drive A: of B: is. Als dat zo is wordt een drive
; change uitgevoerd naar drive C:, omdat Windows anders steeds op de diskette
; blijft kijken bij het opstarten van z'n rommeltje.

code            segment
  assume        cs:Code,ss:Code,ds:Code,es:Code
  org           0100h

start:          mov     ah,19h          ; DOS: huidige drive opvragen
                int     21h
                add     al,41h
                cmp     al,'B'          ; Drive A: of B:
                jbe     naarc
                cmp     al,'M'          ; CD-ROM
                jne     exit
naarc:          mov     ah,0Eh          ; DOS: huidige drive instellen
                mov     dl,02h          ; Drive C:
                int     21h
exit:           mov     ax,4C00h        ; DOS: Afsluiten
                int     21h

code            ends
  end           start
