; WRSVMEM.ASM (WRSVMEM.RX)
;
;   WRite String to Video MEM - PC DOS 7 REXX External Function
;   Write string directly to video memory
;
;   Aanroepen:
;     WrSVMem('bp bh bl dh dl cx'x,str)
;       bp - 00h = Alleen char (uit str, bl heeft geen betekenis)
;            01h = Alleen attribuut (uit str, bl heeft geen betekenis)
;            02h = Alleen attribuut (uit bl, cx opgeven)
;            03h = Char en Attr (uit str,bl)
;            04h = Char en Attr (uit str)
;       bh - Display Page      (00h-03h)
;       bl - Color Attribute   (00h-0FFh)
;       dh - row               (00h-18h)
;       dl - col               (00h-4Fh)
;    alleen bij bp = 02h:
;       cx - aantal            (0000h-FFFFh)
;       str niet opgeven!
;
;   bv. WrSVMem('030007061A'x,'Hello World!!')
;
;

code            segment
  assume        cs:code,ss:code,ds:code,es:code

  ; begin data
  org           82h
  RXARGC        dw      ?
  RXARGV        dd      ?
  ; einde data


  org           100h
start:          cmp     RXARGC,0002h    ; Controleren aantal parameters
                ja      errorexit
                cmp     RXARGC,0000h
                je      errorexit

                push    ds

                lds     si,RXARGV       ; pointer to argument array
                mov     cx,[si]
                cmp     cx,0005h        ; length arg1 moet min 5 bytes zijn
                jb      errorexit
                lds     si,[si+02h]     ; arg1
                cld
                xor     ax,ax
                lodsb                   ; wat afbeelden?
                  cmp     al,04h        ; max 04h
                  ja      errorexit
                  cmp     al,02h        ; alleen attr uit bl, cx keer
                  jne     jp_a
                  cmp     cx,0007h      ; dan moet cx opgegeven zijn
                  jne     errorexit
                  cmp     es:RXARGC,0001h ; en 1 parameter
                  jne     errorexit
                  jmp     jp_c

jp_a:           cmp     es:RXARGC,0002h
                jne     errorexit

jp_c:           mov     bp,ax
                lodsw
                xchg    ah,al
                mov     bx,ax           ; bh=display page, bl=color attribute
                  cmp     bh,03h        ; page max 03h
                  ja      errorexit
                lodsw
                mov     dx,ax           ; dl=col, dh=row
                  cmp     dh,18h        ; row max 18h (24d)
                  ja      errorexit
                  cmp     dl,4Fh        ; col max 4Fh (79d)
                  ja      errorexit
                cmp     bp,0002h        ; bij bp=02h, cx ophalen
                jne     jp_b
                lodsw
                xchg    ah,al
                mov     cx,ax
                pop     ds              ; alvast terug
                push    cx
                jmp     jp_b

errorexit:      mov     ax,4C01h        ; error bye bye
                int     21h

jp_b:           push    dx              ; wordt vernietigd bij mul
                xor     ax,ax
                mov     al,bh           ; display page in al
                mov     cx,1000h        ; offset begin page in videoseg
                mul     cx              ;  is pagenummer * 1000h (4096d)
                mov     di,ax
                pop     dx

                xor     ax,ax           ; row en col erbij
                mov     al,dl           ;  -> (row*80d + col)*2d
                mov     cl,80d
                mul     cl
                xor     dl,dl
                xchg    dh,dl
                add     ax,dx
                shl     ax,01h
                add     di,ax           ; nu offset in videoseg in di

                mov     ax,0B800h       ; adres videoseg
                mov     es,ax

                cmp     bp,0002h        ; als attr uit bl moet komen, cx keer
                jne     jp_k
                pop     cx
                jmp     jp_l

jp_k:           pop     ds
                lds     si,RXARGV       ; pointer to argument array
                mov     cx,[si+06h]     ; length arg2
                lds     si,[si+08h]     ; arg2

jp_l:           jcxz    exit            ; dan niets te doen
                cld                     ; vooruit verplaatsen

                cmp     bp,0000h        ; char/str
                je      jp_bp00
                cmp     bp,0001h        ; attr/str
                je      jp_bp01
                cmp     bp,0002h        ; attr/bl/cx
                je      jp_bp02
                cmp     bp,0003h        ; char+attr/str/bl
                je      jp_bp03
                cmp     bp,0004h        ; char+attr/str
                je      jp_bp04

jp_bp00:
loop_00:        lodsb
                stosb                   ; char erin, attr overslaan
                inc     di
                loop    loop_00
                jmp     exit

jp_bp01:
loop_01:        lodsb
                inc     di              ; char overslaan, attr erin
                stosb
                loop    loop_01
                jmp     exit

jp_bp02:        mov     al,bl
loop_02:        inc     di              ; char overslaan, attr erin
                stosb
                loop    loop_02
                jmp     exit

jp_bp03:        mov     ah,bl
loop_03:        lodsb
                stosw                   ; char + attribute to videomem
                loop    loop_03
                jmp     exit

jp_bp04:    rep movsb

exit:           mov     ax,4C00h        ; bye bye
                int     21h

code            ends
  end           start
