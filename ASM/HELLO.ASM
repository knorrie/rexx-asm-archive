; HELLO.ASM - Hello World!! - de assembler is ontdekt

cr      equ     0DH
lf      equ     0AH

Code Segment
  Assume        cs:code
  Org           100h

start:          jmp codestart

  ; BEGIN DATA GEBIED
  hello         db 'Hello World!!',cr,lf,'$'
  ; EINDE DATA GEBIED

codestart:      mov     dx,offset hello ; offset string hello
                mov     ah,09h          ; string schrijven
                int     21h
                mov     ax,4C00h        ; exit
                int     21h
Code Ends
  End   start
