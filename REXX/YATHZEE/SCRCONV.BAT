/*
  SCRCONV.BAT - Yathzee-Top-1x convertor Version 1.00 Hans van Kranenburg 1996
                Onderdeel van Yathzee v2.20

  Leest oude Yathzee-Top-1x file (v2.10 Top-10 en vanaf v2.11 Top-11) en
  converteert 'm naar nieuwe formaat (v2.20)

  Parameters:
    1: filename van Yathzee-Top-1x file

  bv. "SCRCONV.BAT \YATHZEE\YATHZEE.SCR"
*/

/* Main */
versie='1.00'; jaar='1996'; top.=''
Message('begin')
If Top11File(Arg(1))
  Then Do
    Message(,'reading')
    OpenFile(scr,'read',0)
    Do n=1 To 11
      Message('.')
      top.n=ReadEntry(scr)
    End
    CloseFile(scr)
    Message(,'preparing')
    PrepareFile(scr)
    Message('writing')
    OpenFile(scr,,0)
    SetFPos(scr,6)
    Do n=1 To 11
      Message('.')
      WriteEntry(scr,top.n)
    End
    CloseFile(scr)
  Message(,'complete')
  End

Exit
/* End Main */

/* Subs */

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure Expose scr

/* naam */
Arg scr, .
If scr='' Then Message('noparam')

ok=0
If scr<>''
  Then Do
    /* controle file */
    Select
      When RxIsDir(scr)=''
        Then Message(,'notYT11F',scr,'opnieuw')
      When OpenFile(scr,,5)<>'READY'
        Then Message(,'openerror',scr,'opnieuw')
      When \(GetFSize(scr)=230 | GetFSize(scr)=253)
        Then Message(,'notYT11F',scr,'opnieuw')
      Otherwise
        ok=1
    End
    CloseFile(scr)
  End

Return ok
/* Einde Top11File */

Message: Procedure
Do n=1 To Arg()
  p=Translate(Arg(n))
  Select
    When p='.' Then rc=CharOut(,'.')
    When p='' Then Say
    When p='BEGIN' Then Say SourceLine(2)
    When p='NOPARAM' Then Do a=3 to 11; Say SourceLine(a); End
    When p='OPENERROR' Then Do; Say '  Error opening 'Arg(n+1)'.'; n=n+1; End
    When p='NOTYT11F'
      Then Do; Say '  'Arg(n+1)' is geen Yathzee-Top-11 file.'; n=n+1; End
    When p='OPNIEUW'
      Then Say '  Controleer het nummer en kies opnieuw of raadpleeg de',
        'inlichtingendienst.'
    When p='READING' Then rc=CharOut(,'  Reading ')
    When p='WRITING' Then rc=CharOut(,'  Writing ')
    When p='PREPARING' Then Say '  Preparing outputfile...'
    When p='COMPLETE' Then Say '  File converted.'
  End
End
Return ''

OpenFile:
Return Left(Stream(Arg(1),'c','open 'Arg(2)),Arg(3))

CloseFile:
Return Left(Stream(Arg(1),'c','close'),0)

GetFSize:
Return Stream(Arg(1),'c','query size')

SetFPos:
Return Left(Stream(Arg(1),'c','seek 'Arg(2)),0)

ReadEntry:
Return Left((CharIn(Arg(1),,23))(Left('SCRCONV v'versie,20)(000)),23)

WriteEntry:
Return Left(CharOut(Arg(1),(Left(Arg(2),20))(D2C(Right(Arg(2),3),2))),0)

PrepareFile: Procedure
Arg scr
rc=RxCreate(scr)
OpenFile(scr,'write',0)
rc=CharOut(scr,'YT11F')
CloseFile(scr)
Return ''

/* End Subs */
