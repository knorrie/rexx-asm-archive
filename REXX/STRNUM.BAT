/* REXX-programma dat een ingetypt woord omzet in een getal door de
   bij de letters behorende ASCII-nummers op te tellen */

Say'Programma be‰indigen met CTRL-C'
Say
Say'string?'

Do Forever
  getal=0
  Parse Pull string
  Do n=1 to Length(string)
    getal=getal+c2d(substr(string,n,1))
  End
  Say getal
End
