/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ   YATHZEE Versie 2.13  Hans van Kranenburg 1995-1996  IBM PC DOS 7.0 REXX    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

Yathzee 2.13, Dedicated to Knorrie

Yathzee-history:

 Versie 1.00 In produktie gegaan: -

 Versie 2.00 In produktie gegaan: -
 Wijzigingen:
   Alles, het programma is totaal herschreven

 Versie 2.01 In produktie gegaan: -
 Wijzigingen:
   Bij verkeerde keuze is '--' in 'ฤฤ' veranderd
   Type-foutje bij 'Is scl.sp>63 Then bonus=35' verbeterd

 Versie 2.02 In produktie gegaan: -
 Wijzigingen:
   Gooien.stenen routine aangepast, nu ook voor stenen vasthouden
   Extra keuze bij gooien: Alle stenen vast
   Bonus-bug opgelost
   Veranderde manier opbouw openingsscherm; nu m.b.v. internal data queue
   Aanpassing routine scherm opbouwen, programmacode past nu op scherm

 Versie 2.10 In produktie gegaan: 20 april 1996
 Wijzigingen:
   Er wordt nu een Yathzee-Top-10 bijgehouden
   Veel kleine dingen aangepast

 Versie 2.11 In produktie gegaan: 03 mei 1996
 Wijzigingen:
   De Yathzee-Top-10 is een Yathzee-Top-11 geworden
   Invoer van toetsenbord ook met Linein, doskey wordt niet gebruikt,
     dus niet al de keuzes in doskey-history
   Kleine stroomlijn- en schoonheidsfoutjes verholpen

 Versie 2.12 In produktie gegaan: 03 juni 1996
 Wijzigingen:
   Schrijfwijze aanroep rx-external + internal functions aangepast
     [bv. Rxcls() --> RxCls()]
   Los/Vast routine wordt nu als functie aangeroepen
   Top11File routine wordt nu als functie aangeroepen
   Keuze.Punten routine wordt nu als functie aangeroepen
   Het is mogelijk d.m.v. het opgeven van parameter een andere top11file
     te gebruiken
   Programmastructuurschema toegevoegd
   Yathzee waarschuwt als een keuze geen punten oplevert
   Bonus aangepast, nu bonus bij punten>=63, niet bij >63, dit is officieel zo!
   Diverse kleine dingen aangepast/verbeterd

 Versie 2.13 In produktie gegaan: -
 Wijzigingen:
   Bonus-probleem van versie 2.12 was nog niet helemaal opgelost, in de routine
     Einde wordt nog een keer het totaal aantal punten berekend, hier was ik
     vergeten de > ook in een >= te veranderen (ken je programma ?!)
   Keyboardbuffer niet leegmaken bij vasthouden, dit i.v.m. snel kiezen bij
     langzame computer
   Bij Alle stenen vast/los alleen die, waarbij het nodig is
   Nieuwe functie: ScrSiz(rows,cols), Return Code 1 bij schermbreedte gelijk
     aan opgegeven parameters, anders 0
     Is die lompe Signal Exit daar ook gelijk weg!
   Met nieuwe loop ook Signal Opening2 in Opening weggewerkt
   DUS: YATHZEE NU HELEMAAL GOTOLESS!!
   Volle Bak bij 5 gelijke stenen wordt nu geweigerd
   Keyboardbuffer niet leegmaken bij keuze, niet nodig
   Kleine dingen

Einde Yathzee-history

Programmastuctuurschema (boomdiagram)

 Verklaring gebruikte letters:
  S=Subroutine
  Z=Zelfde routine
  M=Routine die van verschillende plaatsen wordt aangeroepen
  O=Optioneel aangeroepen
  N=Staat niet op deze plek in programma

 Yathzee v2.13
 รฤฤ[Z]Hoofdprogramma
 ณ   รฤฤ[S]Controleren schermgrootte
 ณ   รฤฤ[S]Top11File
 ณ   รฤฤ[S]Opening
 ณ   ณ   รฤฤ[Z]Openingsscherm afbeelden
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (aantal spelers)
 ณ   ณ   ณ   ภฤฤ[SMON]Top11Zien
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (namen en initialen)
 ณ   ณ   ภฤฤ[Z]Variabelen voor puntentelling beginwaarden geven
 ณ   รฤฤ[S]SchermOpbouwen
 ณ   รฤฤ[S]Gooien
 ณ   ณ   ภฤฤ[S]Stenen (=vast/los)
 ณ   รฤฤ[S]BubbleSort
 ณ   รฤฤ[S]Keuze
 ณ   ณ   ภฤฤ[S]Punten
 ณ   รฤฤ[S]Einde
 ณ   ณ   รฤฤ[Z]Na(a)m(en) winnaar(s) afbeelden
 ณ   ณ   รฤฤ[Z]Yathzee-Top-11 bijwerken
 ณ   ณ   ภฤฤ[Z]Nog een keer? & Tot ziens!
 ณ   รฤฤ[SMN]Top11Zien
 ณ   ภฤฤ[Z]Yathzee verlaten
 ภฤฤ[ZM]Top11Zien

Einde Programmastructuurschema
*/

/* Hoofdprogramma */
RxCrStat('off'); versie='2.13'; jaar='1996'
If ScrSiz(25,80) Then Do
  Arg file .; scr=Top11File(file); Drop file
  Do Until sp=-1
    Call Opening
    Call SchermOpbouwen
    Do 13 Until sp=-1
      Do sp=1 To splrs Until sp=-1
        Call Gooien
        Call BubbleSort
        Call Keuze
      End sp
    End
    Call Einde
  End
  Call Top11Zien
  RxCls()
End

/* Yathzee verlaten */
RxCrStat('on')
Exit
/* einde Hoofdprogramma */

/* Controleren schermgrootte */
ScrSiz: Procedure

Arg rows, cols
If Word(RxScrSiz(),1)<>rows | Word(RxScrSiz(),2)<>cols Then Do
  rc=0
  /*   0123456789012345678901234567890123456789  */
  Say 'Om Yathzee te draaien moet het scherm   '||,
      'in een 80x25-modus staan.'
End
Else rc=1

Return rc
/* Einde ScrSiz */

/* Naam van Yathzee-Top-11-file, wordt evt. aangemaakt */
Top11File: Procedure Expose versie

Arg scr
If scr='' Then Do
  Parse Source . . execfile
  scr=(SubStr(execfile,1,LastPos('\',execfile)))('YATHZEE.SCR')
End
Say 'Yathzee-Top-11: 'scr
If RxIsDir(scr)='' Then Do
  rc=Stream(scr,'c','open write')
  rc=CharOut(scr,Copies('Yathzee v'versie'       000',11))
  rc=Stream(scr,'c','close')
End

Return scr
/* einde Top11File */

/* Opening */
Opening: Procedure Expose splrs naam. init. punten scl. scr. scr versie jaar

/* Openingsscherm afbeelden */
Do Until splrs<>'T'
  RxCls(16)
  Queue 'Û     Û  Û฿฿฿฿฿Û  ฿฿฿Û฿฿฿  Û     Û  ฿฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û฿฿฿฿฿฿'
  Queue 'Û     Û  Û     Û     Û     Û     Û        Û  Û        Û      '
  Queue '฿฿฿Û฿฿฿  Û฿฿฿฿฿Û     Û     Û฿฿฿฿฿Û   ÜÜÜ฿฿฿  Û฿฿฿฿฿   Û฿฿฿฿฿ '
  Queue '   Û     Û     Û     Û     Û     Û  Û        Û        Û      '
  Queue '   Û     Û     Û     Û     Û     Û  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ'
  Queue ''
  Queue 'Û฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û     Û  Û     Û'
  Queue 'Û     Û  Û         Û   Û    Û   Û '
  Queue 'Û฿฿฿Û฿฿  Û฿฿฿฿฿     ÛÛÛ      ÛÛÛ  '
  Queue 'Û    Û   Û         Û   Û    Û   Û '
  Queue 'Û     Û  ÛÜÜÜÜÜÜ  Û     Û  Û     Û'
  RxSetPos(2,0); Do 11; Parse Pull q; rc=RxWrScr(Centre(q,80),18); End
  RxSetPos(24,0)
  rc=RxWrScr(Centre('Versie 'versie'  Hans van Kranenburg 'jaar'  IBM PC DOS',
  '7.0 REXX',80),23)
  If splrs<>'T' Then RxSleep(2)

  /* Informatie spelers opvragen (aantal spelers) */
  splrs=0
  RxSetPos(14,5)
  rc=RxWrScr("Aantal spelers [1-5] of 'T' voor Yathzee-Top-11 ?",23)
  RxCls(,14,55,14,55)
  Do Until splrs>=1 & splrs<=5 | splrs='T'
    Do While Chars()<>0; rc=RxGetKey('noecho'); End
    RxSetPos(14,55)
    RxCrStat('on'); splrs=Translate(RxGetKey('echo')); RxCrStat('off')
    RxCls(16,22,0,22,79)
    Select
      When splrs='T' Then Do; Call Top11Zien; End
      When splrs>=1 & splrs<=5 Then Nop
      Otherwise
        RxSetPos(22,0)
        rc=RxWrScr(Centre("Aantal spelers tussen 1 en 5 of 'T' voor Yathzee-To"||,
          'p-11',80),23)
    End
  End
End

/* Informatie spelers opvragen (namen en initialen) */
Do n=1 To splrs; v=15+n
  RxSetPos(v,5); rc=RxWrScr('Naam speler 'n':',23)
  RxCls(,v,20,v,39); RxSetPos(v,20)
  RxCrStat('on'); Parse Pull naam.n; RxCrStat('off')
  RxCls(16,v,40,v,79);RxCls(16,v+1,0,v+1,66)
  naam.n=Strip(SubStr(naam.n,1,20))
  RxSetPos(v,44); rc=RxWrScr('Initialen speler 'n':',23)
  RxCls(,v,64,v,67); RxSetPos(v,64)
  RxCrStat('on'); Parse Pull init.n; RxCrStat('off')
  RxCls(16,v,68,v,79); RxCls(16,v+1,0,v+1,79); RxCls(16,v+2,0,v+2,30)
  init.n=Strip(SubStr(init.n,1,4))
End n

/* Variabelen voor puntentelling beginwaarden geven */
punten=Copies('0',splrs*13); scl.=0; scr.=0

Return
/* einde Opening */

/* Scherm opbouwen */
SchermOpbouwen:

RxCls(); RxCls(16,24,0,24,79)
RxSetPos(0,0); rc=RxWrScr(Centre('YATHZEE Versie 'versie,80),23)
RxSetPos(0,61); rc=RxWrScr('Hans van Kranenburg',23,7); Say
rc=CharOut(,'ษอออออออออออออหออออัออออัออออัออออัออออหออออออออออออออหออออัอออ'||,
  'อัออออัออออัออออป')
rc=CharOut(,'บEnen         บ    ณ    ณ    ณ    ณ    บDrie dezelfde บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บTween       บ    ณ    ณ    ณ    ณ    บVier dezelfde บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บDrien       บ    ณ    ณ    ณ    ณ    บVolle bak     บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บVieren       บ    ณ    ณ    ณ    ณ    บKleine straat บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บVijven       บ    ณ    ณ    ณ    ณ    บGrote straat  บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บZessen       บ    ณ    ณ    ณ    ณ    บYathzee       บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'วฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤถVrije keuze   บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บTotaal puntenบ    ณ    ณ    ณ    ณ    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤ'||,
  'ฤลฤฤฤฤลฤฤฤฤลฤฤฤฤถ')
rc=CharOut(,'บExtra bonus  บ    ณ    ณ    ณ    ณ    บTotaal rechts บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'บTotaal links บ    ณ    ณ    ณ    ณ    บTotaal links  บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,'ศอออออออออออออสออออฯออออฯออออฯออออฯออออนTotaal ฤฤฤฤฤฤ>บ    ณ   '||,
  ' ณ    ณ    ณ    บ')
rc=CharOut(,Right('ศออออออออออออออสออออฯออออฯออออฯออออฯออออผ',80))
RxSetPos(14,0); rc=RxWrScr('Speler',9)
v.=1; Gooien.Stenen('los'); Drop v.
Do n=1 To splrs
  RxSetPos(1,5*(n+2)); rc=RxWrScr(init.n,7)
  RxSetPos(1,5*(n+10)); rc=RxWrScr(init.n,7)
End n
Do n=10 To 12; Do q=1 To splrs; RxSetPos(n,13+5*q); Say 0; End q; End n
Do n=11 To 13; Do q=1 To splrs; RxSetPos(n,53+5*q); Say 0; End q; End n

Return
/* einde SchermOpbouwen */

/* Gooien */
Gooien: Procedure Expose sp naam.sp init.sp st.

v.=0 /* steen vast */
RxCls(,14,20,14,38)
RxSetPos(14,7); rc=RxWrScr(sp,9)
RxSetPos(14,19); rc=RxWrScr(naam.sp,9)
RxSetPos(24,0); rc=RxWrScr('Worp',23)
Do worp=1 To 3
  RxSetPos(24,5); rc=RxWrScr(worp,23)
  Do n=1 To 5
    If \v.n Then Do; st.n=Random(1,6); RxSetPos(22,n*7+18); Say st.n; End
  End n
  If worp<3 Then Do
    RxCls(,15,0,19,79); RxSetPos(15,0)
    Say 'Welke stenen moeten vastgehouden worden bij de volgende worp?'
    Say '  1. Steen 1    5. Steen 5'
    Say '  2. Steen 2    V. Alle stenen vasthouden'
    Say '  3. Steen 3    L. Alle stenen los'
    Say '  4. Steen 4    G. Volgende worp'
    Do Until n='G' | C2D(n)=13
      RxSetPos(15,62)
      RxCrStat('on'); n=Translate(RxGetKey('echo')); RxCrStat('off')
      RxCls(16,24,6,24,79)
      Select
        When n>=1 & n<=5 Then
          If v.n Then Gooien.Stenen('los',n,n)
          Else Gooien.Stenen('vast',n,n)
        When n='V' Then Gooien.Stenen('vast')
        When n='L' Then Gooien.Stenen('los')
        When n='G' | C2D(n)=13 Then Nop
        Otherwise
          RxSetPos(24,6)
          rc=RxWrScr(Centre('Verkeerde keuze ฤฤ Toets 1, 2, 3, 4, 5, V, L of'||,
          ' G',68),23)
      End
    End
  End
End worp
Gooien.Stenen('los'); RxCls(16,24,0,24,5)

Return
/* einde Gooien */

/* Bepaald aantal stenen los/vast                 ฺฤฤฤ default ฤฤฤฟ
   Parameters: ['los'/'vast'] en evt. [van steen (1)] [tot steen (5)] */
Gooien.Stenen: Procedure Expose v.

Arg lv, st1, st2
If st1='' Then st1=1
If st2='' Then st2=5
If lv='LOS' Then Do; lv=0; kl=7; End
Else If lv='VAST' Then Do; lv=1; kl=10; End
Do n=st1 To st2
  If v.n=lv Then Iterate
  v.n=lv
  RxSetPos(21,16+7*n); rc=RxWrScr('ษอออป',kl)
  RxSetPos(22,16+7*n); rc=RxWrScr('บ',kl)
  RxSetPos(22,20+7*n); rc=RxWrScr('บ',kl)
  RxSetPos(23,16+7*n); rc=RxWrScr('ศอออผ',kl)
End n

Return ''
/* einde Gooien.Stenen */

/* Stenen sorteren m.b.v. Bubble Sort */
BubbleSort: Procedure Expose st.

Do grens=5-1 To 1 By -1 Until ok; ok=1
  Do n=1 To grens; m=n+1
    If st.n>st.m Then Do; ok=0; h=st.n; st.n=st.m; st.m=h; End
  End n
End grens

Return
/* einde BubbleSort */

/* Keuze maken */
Keuze: Procedure Expose punten sp scl. scr. st.

RxCls(,15,0,19,79); RxSetPos(15,0)
Say 'Maak uw keuze:'
Say '  1. Enen     5. Vijven           9. Volle bak       13. Vrije keuze'
Say '  2. Tween   6. Zessen          10. Kleine straat   14. Einde spel'
Say '  3. Drien   7. Drie dezelfde   11. Grote straat'
Say '  4. Vieren   8. Vier dezelfde   12. Yathzee'
c=0; Do Until k>=1 & k<=13 & c=1 | k=14
  RxCls(,15,15,15,79); RxSetPos(15,15)
  RxCrStat('on'); Parse LineIn k; RxCrStat('off')
  RxCls(16,24,0,24,79); RxSetPos(24,0)
  Select
    When k>=1 & k<=13 Then
      If SubStr(punten,13*(sp-1)+k,1)=0 Then Do
        c=Keuze.Punten(k)
        If c Then punten=Overlay(c,punten,13*(sp-1)+k)
      End
      Else rc=RxWrScr(Centre('Deze keuze is al eerder gemaakt',80),23)
    When k=14 Then sp=-1
    Otherwise rc=RxWrScr(Centre('Verkeerde keuze gemaakt',80),23)
  End
End

Return
/* einde Keuze */

/* Punten berekenen en weergeven */
Keuze.Punten: Procedure Expose sp scl. scr. st.

Arg k
/* Punten voor de gemaakte keuze berekenen */
punten=0; bonus=0
Select
  When k>=1 & k<=6 Then
    Do n=1 To 5; If st.n=k Then punten=punten+st.n; End n
  When k=7 Then
    If st.1=st.2 & st.2=st.3 | st.2=st.3 & st.3=st.4 | st.3=st.4 & st.4=st.5
      Then Do n=1 To 5; punten=punten+st.n; End n
  When k=8 Then
    If st.1=st.2 & st.2=st.3 & st.3=st.4 | st.2=st.3 & st.3=st.4 & st.4=st.5
      Then Do n=1 To 5; punten=punten+st.n; End n
  When k=9 Then
    If (st.1=st.2 & st.2=st.3 & st.3<>st.4 & st.4=st.5 | st.1=st.2 & st.2<>st.3,
      & st.3=st.4 & st.4=st.5) & st.1<>st.5 Then punten=25
  When k=10 Then Do
    /* Begin oplossing kleine straat-probleem */
    s=st.1; Do n=2 To 5; s=(s)(st.n); End n
    Do n=1 To 4; m=n+1
      If SubStr(s,n,1)=SubStr(s,m,1) Then s=DelStr(s,m,1)
    End n
    Do n=1 To 5; st.n=SubStr(s,n,1,'0'); End n
    /* Einde oplossing kleine straat-probleem */
    If st.1=st.2-1 & st.2=st.3-1 & st.3=st.4-1 | st.2=st.3-1 & st.3=st.4-1,
      & st.4=st.5-1 Then punten=30
  End
  When k=11 Then
    If st.1=st.2-1 & st.2=st.3-1 & st.3=st.4-1 & st.4=st.5-1 Then punten=40
  When k=12 Then If st.1=st.2 & st.2=st.3 & st.3=st.4 & st.4=st.5 Then punten=50
  When k=13 Then Do n=1 To 5; punten=punten+st.n; End n
End

/* Waarschuwen als er geen punten behaald worden */
ok=1
If punten=0 Then Do
  RxSetPos(24,0); rc=RxWrScr(Centre('Deze keuze levert geen punten op! Doorg'||,
    'aan [J/N] ?',80),23)
  Do Until n='J' | n='N'
    Do While Chars()<>0; rc=RxGetKey('noecho'); End
    n=Translate(RxGetKey('noecho'))
    If n='N' Then ok=0
  End
  RxCls(16,24,0,24,79)
End

/* Punten optellen bij totaalscore en afbeelden */
If ok Then Do
  If k<=6 Then Do
    scl.sp=scl.sp+punten
    If scl.sp>=63 Then bonus=35
    RxSetPos(10,11+5*sp); Say Right(scl.sp,3)
    RxSetPos(11,12+5*sp); Say Right(bonus,2)
    RxSetPos(12,11+5*sp); Say Right(scl.sp+bonus,3)
    RxSetPos(12,51+5*sp); Say Right(scl.sp+bonus,3)
    RxSetPos(k+2,12+5*sp)
  End
  Else Do
    scr.sp=scr.sp+punten
    If scl.sp>=63 Then bonus=35
    RxSetPos(11,51+5*sp); Say Right(scr.sp,3)
    RxSetPos(k-4,52+5*sp)
  End
  Say Right(punten,2)
  RxSetPos(13,51+5*sp); Say Right(scl.sp+bonus+scr.sp,3)
End

Return ok
/* einde Keuze.Punten */

/* Einde */
Einde: Procedure Expose splrs sp scl. scr. naam. scr versie

/* Na(a)m(en) winnaar(s) afbeelden */
Do n=1 To splrs; sct.n=scl.n+scr.n; If scl.n>=63 Then sct.n=sct.n+35; End n
sct=sct.1
If splrs>1 Then Do n=2 To splrs; If sct.n>sct Then sct=sct.n; End n
w=0; Do n=1 To splrs
  If sct.n=sct Then Do; w=w+1
    If naam.n='' Then naamx.w='Speler 'n
    Else naamx.w=naam.n
  End
End n
RxCls(,15,0,19,79)
If sct=1 Then txt='punt' ;Else txt='punten'
If w=1 Then Do
  RxSetPos(17,0)
  Say Centre(naamx.1' heeft gewonnen met 'sct' 'txt'!',80)
End
Else Do
  RxSetPos(16,0)
  Say 'Deze spelers hebben gewonnen met 'sct' 'txt':'
  Do n=1 To w
    If n//2=0 Then x=27; Else x=2
    RxSetPos(16+Trunc(Abs(n/2+1/2),0),x); Say naamx.n
  End n
End

/* Yathzee-Top-11 bijwerken */
/* totaalscores spelers + namen controleren */
Do n=splrs To 1 By -1
  If naam.n='' Then naam.n=SubStr('Yathzee v'versie,1,20)
  Else naam.n=SubStr(naam.n,1,20)
  sc.n=(naam.n)(Right(sct.n,3,'0'))
End n

/* file openen + oude Yathzee-Top-11 inlezen */
rc=Stream(scr,'c','open')
Do n=11+splrs To splrs+1 By -1; sc.n=CharIn(scr,,23); End n

n=n+1; If SubStr(sc.n,21,3)<sct Then Do
  /* alle scores sorteren m.b.v. Bubblesort */
  Do grens=splrs+11-1 To splrs By -1 Until stop; stop=0
    Do n=1 To grens Until ok; m=n+1; ok=0
      If SubStr(sc.n,21,3)>SubStr(sc.m,21,3) Then Do
        h=sc.n; sc.n=sc.m; sc.m=h; End
      Else If n>splrs Then ok=1
      Else If n=splrs Then Do; ok=1; stop=1; End
    End n
  End grens

  /* nieuwe Yathzee-Top-11 wegschrijven */
  rc=Stream(scr,'c','seek =1')
  Do n=11+splrs To splrs+1 By -1; rc=CharOut(scr,sc.n); End n
End

/* file sluiten */
rc=Stream(scr,'c','close')

/* Nog een keer? & Tot ziens! */
RxSetPos(24,0); rc=RxWrScr(Centre('Opnieuw beginnen [J/N] ?',80),23)
Do Until n='J' | n='N'
  Do While Chars()<>0; rc=RxGetKey('noecho'); End
  n=Translate(RxGetKey('noecho'))
  If n='J' Then sp=0
  If n='N' Then Do
    RxSetPos(24,0); rc=RxWrScr(Centre('Tot ziens!',80),23)
    sp=-1; RxSleep(2)
  End
End

Return
/* einde Einde */

/* Speler wil Yathzee-Top-11 zien */
Top11Zien: Procedure Expose scr splrs versie

RxCls(); Say; Say
Say Centre('Yathzee-Top-11  YATHZEE Versie 'versie,80); Say
Queue 'ษออออออออออออออออออออออออออออออออออัอออออออออออออออออออป'
Queue 'บ Speler                           ณ Score             บ'
Queue 'วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ'
Queue 'ศออออออออออออออออออออออออออออออออออฯอออออออออออออออออออผ'
Do 3; Parse Pull q; rc=CharOut(,Centre(q,80)); End
rc=Stream(scr,'c','open read')
Do n=8 To 18
  rc=CharOut(,Centre('บ 'Right(n-7,2,'0')'. 'CharIn(scr,,20)'         ณ '||,
  CharIn(scr,,3)'               บ',80))
End
rc=Stream(scr,'c','close')
Parse Pull q; rc=CharOut(,Centre(q,80))
Do While Chars()<>0; rc=RxGetKey('noecho'); End; Say; Say
rc=Charout(,Centre('Druk op een toets om verder te gaan ...',80))
Do Until Chars()=0; rc=RxGetKey('noecho'); End

Return
/* einde Top11Zien */
/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                            END OF FILE - YATHZEE                             บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
