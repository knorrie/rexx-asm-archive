/* Lockup System v1.00 by Hans van Kranenburg */
Trace Off
Call On Halt
rc=Charout(,'Enter password or escape to quit: ')
passwd=''
Do Until c2d(key)=13
  key=Rxgetkey(noecho)
  If c2d(key)=27 Then Signal Exit
  If c2d(key)=13 Then Iterate
  passwd=(passwd)(key)
End
Say; Say 'System locked'
rc=Charout(,'Enter password: ')
Do Until match=passwd
  match=''
  Do Until c2d(key)=13
    key=Rxgetkey(noecho)
    If c2d(key)=13 Then Iterate
    match=(match)(key)
  End
  If match<>passwd Then Do
    Say; rc=Charout(,'Incorrect password, try again: ')
  End
End
Say; Say 'System unlocked'

Exit:
Exit

Halt:
Return
