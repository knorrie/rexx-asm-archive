; RXERROR.ASM - Hans van Kranenburg 1996 : Laat REXX een error 40 maken

  cr            equ     0DH
  lf            equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          mov     ax,4C01h        ; non-zero return code at exit
                int     21h

Code Ends
  End           start
