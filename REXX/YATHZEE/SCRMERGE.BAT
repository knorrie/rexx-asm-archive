/*
  SCRMERGE.BAT - Yathzee-Top-11 Merge Version 1.00 Hans van Kranenburg 1996
                 Onderdeel van Yathzee v2.30

  Leest 1 of meerdere Yathzee-Top-11 files in en schijft ‚‚n file weg met
  daarin de 11 hoogste scores

  SCRMERGE.BAT werkt alleen met Yathzee-Top-11 files van het formaat v2.20
  Yathzee-Top-1x Files van het formaat voor v2.20 kunnen na ze geconverteerd
  te hebben met SCRCONV.BAT ook meegemerged worden

  Parameters:
    - filenames van Yathzee-Top-11 files
    - laatste parameter is de naam van de file die als outputfile gebruikt moet
      worden, als deze al bestaat, wordt de inhoud overschreven
    > als een filename wordt opgegeven zonder extensie wordt .SCR toegevoegd
      type om dit te voorkomen wel een punt, maar geen extensie

  Bij gelijke scores gaan de scores van de latergenoemde files voor

  bv. "SCRMERGE.BAT \YATHZEE\YATHZEE.SCR SCORES.SCR SCORES.SCR"
*/

/* Main */
versie='1.00'; jaar='1996'
Message('begin')
If GetParams(Arg(1)) /* set variables: scr. nfiles */
  Then Do
    Say
    Do n=1 To nfiles-1
      If Top11File(scr.n)
        Then Do
          Message('reading',scr.n)
          OpenFile(scr.n,'read',0)
          SetFPos(scr.n,6)
          Do a=1 To 11
            Message('.')
            b=((n-1)*11)+a
            top.b=ReadEntry(scr.n)
          End
          Say
          CloseFile(scr)
        End
      Else Do
        Message('default')
        Do a=1 to 11
          Message('.')
          b=((n-1)*11)+a
          top.b=(Left('SCRMERGE v'versie,20))(000)
        End
        Say
      End
    End
    Message('bubble')
    Call BubbleSort
    Message('preparing')
    If PrepareFile(scr.nfiles)
      Then Do
        Message('writing',scr.nfiles)
        OpenFile(scr.nfiles,,0)
        SetFPos(scr.nfiles,6)
        Do n=(nfiles-1)*11 To (nfiles-1)*11-10 By -1
          Message('.')
          WriteEntry(scr.nfiles,top.n)
        End
        Say
        CloseFile(scr.nfiles)
      Message('complete')
      End
  End

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
    When p='.' Then rc=CharOut(,'.')
    When p='BEGIN' Then Say SourceLine(2)
    When p='NOPARAM' Then Do a=3 to 19; Say SourceLine(a); End
    When p='OPENERROR'
      Then Do; Say '  Error opening 'Arg(n+1); n=n+1; End
    When p='DEFAULT' Then rc=CharOut(,'    Using default SCRMERGE values ')
    When p='NOTYT11F'
      Then Do; Say '  'Arg(n+1)' is not a Yathzee-Top-11 file.'; n=n+1; End
    When p='READING' Then Do; rc=CharOut(,'  Reading 'Arg(n+1)' '); n=n+1; End
    When p='WRITING' Then Do; rc=CharOut(,'  Writing 'Arg(n+1)' '); n=n+1; End
    When p='BUBBLE' Then Say '  BubbleSorting scores ...'
    When p='PREPARING' Then Say '  Preparing outputfile ...'
    When p='COMPLETE' Then Say '  Files merged.'
  End
End
Return ''

BubbleSort: Procedure Expose nfiles top.
Do grens=((nfiles-1)*11)-1 To 1 By -1 Until ok; ok=1
  Do n=1 To grens; m=n+1
    If Right(top.n,3)>Right(top.m,3)
      Then Do; ok=0; h=top.n; top.n=top.m; top.m=h; End
  End n
End grens
Return

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

WriteEntry:
Return Left(CharOut(Arg(1),(Left(Arg(2),20))(D2C(Right(Arg(2),3),2))),0)

PrepareFile: Procedure
Arg scr
rc=RxCreate(scr)
ok=Top11File(scr)
If ok
  Then Do
    OpenFile(scr,'write',0)
    rc=CharOut(scr,'YT11F')
    CloseFile(scr)
  End
Return ok
