/*
  SCRVIEW.BAT - Yathzee-Top-11 Viewer Version 1.00 Hans van Kranenburg 1997
                Onderdeel van Yathzee v2.40

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
versie='2.40'; cls=1
RxCrStat('off')
Say SourceLine(2)
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
            Do Until Chars()=0; rc=RxGetKey('noecho'); End
          End
        Else cls=0
      End
    End
    If cls Then RxCls()
  End

RxCrStat('on')
Exit
/* End Main */

/* Other shit */

GetParams: Procedure Expose scr. nfiles
Arg poc; rc=1
If poc=''; Then Do; Do a=3 to 14; Say SourceLine(a); End; rc=0; End
nfiles=Words(poc)
Do n=1 To nfiles
  scr.n=Word(poc,n)
  If Pos('.',scr.n)=0 Then scr.n=scr.n||'.SCR'
End
Return rc

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure

Arg scr
ok=0; opened=0
Select
  When Stream(scr,'c','open read')<>'READY'
    Then Say '  Error opening 'scr
  When \(CharIn(scr,1,5)<>'YT11F' & Stream(scr,'c','query size')=0,
       & Stream(scr,'c','query size')<>247 | CharIn(scr,1,5)='YT11F',
       & Stream(scr,'c','query size')<>0 & Stream(scr,'c','query size')=247)
    Then Do; Say scr' is not a Yathzee-Top-11 file.'; opened=1; End
  Otherwise
    ok=1; opened=1
End
If opened Then rc=Stream(scr,'c','close')

Return ok
/* Einde Top11File */

/* Speler wil Yathzee-Top-11 zien */
Top11Zien: Procedure Expose versie

Arg scr
RxCls(); Say; Say
Say Centre('Yathzee-Top-11: 'SubStr(scr,1,Pos('.',scr)-1)'  SCRVIEW Version',
  versie,80); Say
Queue 'ษออออออออออออออออออออออออออออออออออัอออออออออออออออออออป'
Queue 'บ Player                           ณ Score             บ'
Queue 'วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ'
Queue 'ศออออออออออออออออออออออออออออออออออฯอออออออออออออออออออผ'
Do 3; Parse Pull q; rc=CharOut(,Centre(q,80)); End
rc=Stream(scr,'c','open read')
rc=Stream(scr,'c','seek =6')
Do n=8 To 18
  a=(CharIn(scr,,20))(Right(C2D(CharIn(scr,,2)),3,0))
  rc=CharOut(,Centre(('บ ')(Right(n-7,2,'0'))('. ')(Left(a,20))('         ')||,
  ('ณ ')(Right(a,3))('               บ'),80))
End
rc=Stream(scr,'c','close')
Parse Pull q; rc=CharOut(,Centre(q,80))
Say; Say; rc=Charout(,Centre('Press any key to continue ...',80))
Do Until Chars()=0; rc=RxGetKey('noecho'); End

Return ''
/* Einde Top11Zien */
