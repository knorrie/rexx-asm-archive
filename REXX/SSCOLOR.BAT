/* Screensaver "Color"
   evt: parameter: wait, hoe lang wachten voor andere kleur */

Arg wait .; If wait='' Then wait=1500
RxCrstat('off')
Do While Chars()=0
  Do n=0 to 112 by 16 While Chars()=0
    RxCls(n)
    Do t=1 to wait While Chars()=0; End
  End
End
Do While Chars()<>0; rc=RxGetKey('noecho'); End
RxCls(); RxCrStat('on')
Exit
