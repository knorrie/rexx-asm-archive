/* Voorbeeld van Wacht-Balk die laat zien hoever een proces gevorderd is */
/* ANSI.SYS driver wordt gebruikt!! */

RxCrStat('off')
rc=CharOut(,'[0;37;44m')
rc=CharOut(,'[2J')
rc=CharOut(,'[5;0H')
a=Copies(' ',8); b=Copies(' ',15)
rc=CharOut(,a'ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป',
b'บ                                                              บ',
b'บ                                                              บ',
b'บ ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู บ',
b'บ 0%                           50%                        100% บ',
b'ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ')
rc=CharOut(,'[19;9H')
rc=CharOut(,'Seconden ?')
Do Forever
  rc=CharOut(,'[19;20H')
  rc=CharOut(,'[K')
  RxCrStat('on'); Pull sec; RxCrStat('off')
  If sec='' Then Leave
  rc=CharOut(,'[6;11H'); rc=CharOut(,Copies(' ',60))
  rc=CharOut(,'[7;11H'); rc=CharOut(,Copies(' ',60))
  x=sec/60; y=0; rc=Time('r')
  rc=CharOut(,'[0;31;44m')
  Do n=11 to 70
    y=y+x
    Do While Time('e')<y; End
    rc=CharOut(,'[6;'n'H')
    rc=CharOut(,'Ü')
    rc=CharOut(,'[7;'n'H')
    rc=CharOut(,'฿')
  End
  rc=CharOut(,'[0;37;44m')
End
rc=CharOut(,'[0;37;40m')
rc=CharOut(,'[2J')
RxCrStat('on'); Exit
