/* Paasdatum REXX v1.20
   Veranderingen van versie 1.10 naar 1.20:
   - er wordt gecontroleerd of het scherm 40 of 80 kolommen heeft, de uitvoer
     wordt daaraan aangepast
   - helpscherm wordt sneller neergezet
*/

/* Schermbreedte opvragen */
cols=Subword(Rxscrsiz(),2,1)
/* Opvragen parameter - Helpscherm bij geen/foute parameter */
Arg jaar
If jaar<1900 | jaar>2100 Then Do
  If cols=80 Then Do
    rc=Charout(,'ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป')
    rc=Charout(,'บ Paasdatum REXX v1.20                                              Hans v. K. บ')
    rc=Charout(,'ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน')
    rc=Charout(,'บ Op welke datum valt 1e paasdag in het jaar .... ?                            บ')
    rc=Charout(,'บ                                                                              บ')
    rc=Charout(,'บ PASEN.BAT [jaar]                                                             บ')
    rc=Charout(,'บ   jaar is een jaartal tussen 1900 en 2100, bv. 1995 of 1972                  บ')
    rc=Charout(,'บ                                                                              บ')
    rc=Charout(,'ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ')
  End
  Else Do
    rc=Charout(,'ษออออออออออออออออออออออออออออออออออออออป')
    rc=Charout(,'บ Paasdatum REXX v1.20      Hans v. K. บ')
    rc=Charout(,'ฬออออออออออออออออออออออออออออออออออออออน')
    rc=Charout(,'บ Op welke datum valt 1e paasdag in    บ')
    rc=Charout(,'บ  het jaar .... ?                     บ')
    rc=Charout(,'บ                                      บ')
    rc=Charout(,'บ PASEN.BAT [jaar]                     บ')
    rc=Charout(,'บ   jaar is een jaartal tussen 1900 en บ')
    rc=Charout(,'บ    2100, bv. 1995 of 1972            บ')
    rc=Charout(,'บ                                      บ')
    rc=Charout(,'ศออออออออออออออออออออออออออออออออออออออผ')
  End
  Signal exit
End

/* Datum berekenen */
a = jaar // 19
b = jaar // 4
c = jaar // 7
d = ((19*a)+24) // 30
e = ((2*b)+(4*c)+(6*d)+5) // 7
maart = 22+d+e
april = d+e-9

/* Controleren op uitzondering */
If april = 26 Then april = 19
If april = 25 & d = 28 & a < 10 Then april=18

/* Afbeelden datum */
Say'Paasdatum REXX v1.20'
If maart > 0 & maart < 32
  Then Say'Datum van 1e paasdag in het jaar 'jaar' is 'maart' maart'
  Else Say'Datum van 1e paasdag in het jaar 'jaar' is 'april' april'

/* Programma verlaten */
exit:
Exit
