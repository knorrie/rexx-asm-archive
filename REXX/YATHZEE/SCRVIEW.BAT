/*
  SCRVIEW.BAT - Yathzee-Top-11 Viewer Version 1.00 Hans van Kranenburg 1996
                Onderdeel van Yathzee v2.30

  Laat de inhoud van n of meerdere Yathzee-Top-11 files zien

  SCRVIEW.BAT werkt alleen met Yathzee-Top-11 files van het formaat v2.20
  Yathzee-Top-1x Files van het formaat voor v2.20 kunnen na ze geconverteerd
  te hebben met SCRCONV.BAT ook meegeviewed worden

  Parameters:
    - filenames van Yathzee-Top-11 files
    > als een filename wordt opgegeven zonder extensie wordt .SCR toegevoegd
      type om dit te voorkomen wel een punt, maar geen extensie

  bv. "SCRVIEW.BAT \YATHZEE\YATHZEE.SCR SCORES.SCR"
*/

/* Main */
versie='1.00'; jaar='1996'; cls=1
RxCrStat('off')
Message('begin')
If GetParams(Arg(1)) /* set variables: scr. nfiles */
  Then Do
    Say
    Do n=1 To nfiles
      RxCls(); Say
      If Top11File(scr.n) Then Top11Zien(scr.n)
      Else Do
        If n<nfiles
          Then Do
            Say
            rc=Charout(,'Press any key to continue ...')
            WaitForKey()
          End
        Else cls=0
      End
    End
    If cls Then RxCls()
  End

RxCrStat('on')
Exit
/* End Main */

/* Subs */
GetParams: Procedure Expose scr. nfiles
Arg poc; rc=1
If poc='' Then Do; Message('noparam'); rc=0; End
nfiles=Words(poc)
Do n=1 To nfiles
  scr.n=Word(poc,n)
  If Pos('.',scr.n)=0 Then scr.n=scr.n||'.SCR'
End
Return rc

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure

Arg scr
ok=0
Select
  When OpenFile(scr,'read',5)<>'READY'
    Then Message('openerror',scr)
  When \(CharIn(scr,1,5)<>'YT11F' & GetFSize(scr)=0 & GetFSize(scr)<>247,
    | CharIn(scr,1,5)='YT11F' & GetFSize(scr)<>0 & GetFSize(scr)=247)
    Then Message('notYT11F',scr)
  Otherwise
    ok=1
End
CloseFile(scr)

Return ok
/* Einde Top11File */

Message: Procedure
Do n=1 To Arg()
  p=Translate(Arg(n))
  Select
    When p='BEGIN' Then Say SourceLine(2)
    When p='NOPARAM' Then Do a=3 to 14; Say SourceLine(a); End
    When p='OPENERROR'
      Then Do; Say '  Error opening 'Arg(n+1); n=n+1; End
    When p='NOTYT11F'
      Then Do; Say '  'Arg(n+1)' is not a Yathzee-Top-11 file.'; n=n+1; End
  End
End
Return ''

/* Speler wil Yathzee-Top-11 zien */
Top11Zien: Procedure Expose versie

Arg scr
RxCls(); Say; Say
Say Centre('Yathzee-Top-11: 'scr'  SCRVIEW Version 'versie,80); Say
Queue 'ษออออออออออออออออออออออออออออออออออัอออออออออออออออออออป'
Queue 'บ Player                           ณ Score             บ'
Queue 'วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ'
Queue 'ศออออออออออออออออออออออออออออออออออฯอออออออออออออออออออผ'
Do 3; Parse Pull q; rc=CharOut(,Centre(q,80)); End
OpenFile(scr,'read',0)
SetFPos(scr,6)
Do n=8 To 18
  a=ReadEntry(scr)
  rc=CharOut(,Centre(('บ ')(Right(n-7,2,'0'))('. ')(Left(a,20))('         ')||,
  ('ณ ')(Right(a,3))('               บ'),80))
End
CloseFile(scr)
Parse Pull q; rc=CharOut(,Centre(q,80))
Say; Say; rc=Charout(,Centre('Press any key to continue ...',80))
WaitForKey()

Return ''
/* Einde Top11Zien */

OpenFile:
Return Left(Stream(Arg(1),'c','open 'Arg(2)),Arg(3))

CloseFile:
Return Left(Stream(Arg(1),'c','close'),0)

GetFSize:
Return Stream(Arg(1),'c','query size')

SetFPos:
Return Left(Stream(Arg(1),'c','seek 'Arg(2)),0)

ReadEntry:
Return (CharIn(Arg(1),,20))(Right(C2D(CharIn(Arg(1),,2)),3,0))

WaitForKey:
Do Until Chars()=0; rc=RxGetKey('noecho'); End
Return ''
