/* Paasdatum REXX v1.10 */

trace off
file='paasprn.txt'
rc=stream(file,'c','open write')

rc=Lineout(file,'Paasdatum REXX v1.10')

Do jaar = 1901 to 2099

  /* Datum berekenen */
  a = jaar // 19
  b = jaar // 4
  c = jaar // 7
  d = ((19*a)+24) // 30
  e = ((2*b)+(4*c)+(6*d)+5) // 7
  maart = 22+d+e
  april = d+e-9

  /* Controleren op uitzondering */
  If april = 26
    Then april = 19
  If april = 25 & d = 28 & a < 10
    Then april=18

  If length(maart)=1 Then maart='0'maart
  If length(april)=1 Then april='0'april

  /* Afbeelden datum */
  If maart >= 1 & maart <= 31
    Then rc=Lineout(file,jaar ':' maart 'maart')
    Else rc=Lineout(file,jaar ':' april 'april')

End

rc=stream(file,'c','close')
Exit
/* End of file */
