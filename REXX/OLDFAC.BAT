/* Recursief programma: bereken x! */
Trace ?R

Numeric Digits 1000
Arg x
Say x'! =' fac(x)
Exit

fac: procedure /* recursieve functie */
Arg n
If n=0 Then Return 1
Return fac(n-1)*n
