/* Paasdatum REXX v1.10 */

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Paasdatum REXX v1.10                                              Hans v. K. บ
ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บ Op welke datum valt 1e paasdag in .... ?                                     บ
บ                                                                              บ
บ PASEN.BAT [jaar]                                                             บ
บ   jaar is een jaartal tussen 1900 en 2100, bv. 1995 of 1972                  บ
บ                                                                              บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

/* Veranderingen van versie 1.00 naar 1.10:
   - alleen jaartallen tussen 1900 en 2100 i.p.v. alle jaartallen groter dan
     nul toegestaan omdat anders de berekening niet goed uitkomt
   - controlering op uitzonderingen toegevoegd
   - Helpscherm beslaat nu bij een 80-kolommen breed scherm de hele breedte

   waarschijnlijk wordt versie 1.20 of 2.00 uitgebreider wat betreft
   jaartallen die gekozen kunnen worden */

/* Opvragen parameter - Helpscherm bij geen/foute parameter */
Arg jaar
Call parameter

/* Paasdatum berekenen en afbeelden */
If help \= true
  Then Call datum
  Else Nop

/* Programma verlaten */
Exit

/* Parameter */
parameter:
If Datatype(jaar) \= num | jaar \> 1900 | jaar \< 2100
  Then Call helpscherm
Return

/* Helpscherm */
helpscherm:
help = true
c=0
/*
vpos = subword(rxgetpos(),1,1)
lines = subword(rxscrsiz(),1,1)
*/
Do line = 4 to 12
  Say sourceline(line)
  rxsetpos(subword(rxgetpos(),1,1) - 1,0)
End
Return

/* Datum */
datum:
Call datum_berekenen
Call controleren_op_uitzondering
Call afbeelden_datum
Return

/* Datum berekenen */
datum_berekenen:
a = jaar // 19
b = jaar // 4
c = jaar // 7
d = ((19*a)+24) // 30
e = ((2*b)+(4*c)+(6*d)+5) // 7
maart = 22+d+e
april = d+e-9
Return

/* Controleren op uitzondering */
controleren_op_uitzondering:
If april = 26
  Then april = 19
If april = 25 & d = 28 & a < 10
  Then april=18
Return

/* Afbeelden datum */
afbeelden_datum:
Say'Paasdatum REXX v1.10'
If maart > 0 & maart < 32
  Then Say'Datum van 1e paasdag in het jaar 'jaar' is 'maart' maart'
  Else Say'Datum van 1e paasdag in het jaar 'jaar' is 'april' april'
Return
