/* REXX-programma om de datum van de 1e paasdag te berekenen */

/* Opvragen parameter - Helpscherm bij geen/foute parameter */
Arg jaar
Call parameter

/* Paasdatum berekenen en afbeelden */
If help \= true
  Then Call datum

/* Programma verlaten */
Exit

/* Parameter */
parameter:
If Datatype(jaar) \= num | jaar < 0
  Then Call helpscherm
Return

/* Helpscherm */
helpscherm:
help=true
Say'ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป'
Say'บ Paasdatum REXX v1.00                                         Hans v. K. บ'
Say'ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน'
Say'บ Op welke datum valt 1e paasdag in .... ?                                บ'
Say'บ                                                                         บ'
Say'บ PASEN.BAT [jaar]                                                        บ'
Say'บ   jaar is een jaartal groter dan 0, bv. 1995 of 1972                    บ'
Say'บ                                                                         บ'
Say'ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ'
Return

/* Datum */
datum:
a = jaar // 19
b = jaar // 4
c = jaar // 7
d = ((19*a)+24) // 30
e = ((2*b)+(4*c)+(6*d)+5) // 7
maart = 22+d+e
april = d+e-9

Say'Paasdatum REXX v1.00'
If maart > 0 & maart < 32
  Then Say'Datum van 1e paasdag in het jaar 'jaar' is 'maart' maart.'
  Else Say'Datum van 1e paasdag in het jaar 'jaar' is 'april' april.'
Return
