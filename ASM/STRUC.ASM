Codesg Segment para 'Code'
        Assume  cs:codesg,ds:codesg,ss:codesg
        Org     100h

begin:          jmp short main
;-------------------------------------------
parlist struc
        maxlen  db      25
        actlen  db      ?
        namein  db      25 dup(' ')
parlist ends

params parlist <>

        prompt  db      'What is name?$'
;-------------------------------------------

main    proc    near
        mov     ah,09h
        lea     dx,prompt
        int     21h
        mov     ah,0ah
        lea     dx,params
        int     21h
        mov     al,params.actlen
        mov     ax,4c00h
        int     21h
main    endp
Codesg  Ends
  End   begin
