/**/
Say 'Functie:'
Pull f
Do Forever
  Say 'x:'
  Pull x
  Interpret f
  Say y
End
Exit

/* Faculteit x */
Fac: Procedure

Arg x
Select
  When Datatype(x)<>'NUM' Then error=1
  When Trunc(Abs(x))<>x Then error=1
  Otherwise error=0
    x=Trunc(Abs(x)); rc=1
    Do x=x to 2 by -1
      rc=rc*x
    End x
End
If error Then Do; Say 'Error 40: 'Errortext(40); rc='Error'; End

Return rc
/* end fac */
