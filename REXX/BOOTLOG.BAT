/* BOOTLOG */
Arg x .
lf='C:\BOOT.LOG' /* LogFile */
rc=Stream(lf,'c','open')
size=Stream(lf,'c','query size') /* SIZE of logfile */

If x='NEW' Then Do
  rc=CharOut(,'Last boot: 'CharIn(lf,size-25,25))
  rc=Stream(lf,'c','seek <1')
  currboot=SubStr(Date('w'),1,2)' 'Right(Date('n'),11,'0')' 'Time()||,
    X2C('0D')||X2C('0A')||X2C('1A')
  rc=CharOut(lf,currboot)
End
Else Do (size-1)/25
  rc=CharOut(,CharIn(lf,,25))
End

rc=Stream(lf,'c','close')
/* EOF BOOTLOG.BAT */
