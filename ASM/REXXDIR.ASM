; Gaat naar x:\knorrie\rexx

code            segment
  assume        cs:code,ss:code,ds:code,es:code
  org           0100h

start:          mov     ah,0Eh          ; DOS: change drive
                mov     dl,17h          ; x:
                int     21h
                mov     ah,3Bh          ; DOS: change dir
                lea     dx,rexxdir      ; rexxdir
                int     21h
exit:           mov     ax,4C00h        ; DOS: afsluiten
                int     21h

rexxdir         db      '\KNORRIE\REXX',00h

code            ends
  end           start
