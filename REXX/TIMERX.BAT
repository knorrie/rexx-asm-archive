/**/
RxCrStat('off')
time66=6.70
time01=time66*66
Say '66 MHz: 'time66' (s)'
rc=Time('r')
Do n=1 to 8192
  rc=CharOut(,X2C('0D')||Right(n,4,0))
End n
t=Time('e')
Say; Say 'Huidige snelheid: 't' (s) --> 'time01/t' MHz'
RxCrStat('on')
Do Forever
  rc=CharOut(,'Snelheid ? ')
  Pull s; If s='' Then Leave
  Say s' MHz: 'time01/s' (s)'
End
Exit
