/* Main */
Numeric Digits 1000
Do Forever
  rc=Charout(,'getal ? ')
  Parse Linein a
  Say a'!= 'Fac(a)
  Say D2X(Fac(a))
  Say Length(D2X(Fac(a)))
  Do n=1 to Fac(a)
    rc=CharOut(,'0D'x||n)
  End
  Say
End

/* end main */

/* Faculteit x */
Fac: Procedure

Arg x
Select
  When Datatype(x)<>'NUM' Then error=1
  When Trunc(Abs(x))<>x Then error=1
  Otherwise error=0
    ret=1
    Do x=x to 2 by -1
      ret=ret*x
    End x
End
If error Then Do; Say 'Error 40: 'Errortext(40); ret='Error'; End

Return ret
/* end fac */
