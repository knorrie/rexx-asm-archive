/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ   YATHZEE Versie 2.20  Hans van Kranenburg 1995-1996  IBM PC DOS 7.0 REXX    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

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

 Versie 2.20 In produktie gegaan: 31 juli 1996
 Wijzigingen:
   Aangepast formaat Yathzee-Top-11 files, conversieprogramma vanaf v2.20
     bijgesloten, nu herkenning wel of geen YT11 file, scores worden als hex-
     getallen van 2 bytes opgeslagen
   Vanwege hiervoor besproken verandering en vele veranderingen van v2.13
     besloten v2.13 niet in produktie te brengen maar verder te gaan met v2.20
   Controle op DataType bij keuze, voorheen veroorzaakte keuze bv. "12j" een
     foutmelding doordat dit >=1 en <=13 is
   De BubbleSort methode voor het sorteren van de stenen en vervolgens het
     vaststellen van het puntenaantal is vervangen door de Verzamel methode
   Als gevolg van de vervanging van BubbleSort door Verzamel is de sub Keuze
     en alles wat daaronder hangt grondig gewijzigd
   Enkele Yathzee-utilities toegevoegd:
     SCRVIEW : Laat inhoud van Yathzee-Top-11 file zien
     SCRCONV : Converteert Yathzee-Top-1x files naar v2.20 formaat
     SCRMERGE: Voegt Yathzee-Top-11 files samen
   Windows icoon en PIF-file toegevoegd
   Aan het einde van Yathzee staat nu een 'Subs' gedeelte met veelgebruikte
     functies, die uitwisseling met andere SCR* programma's makkelijker maakt
   Als gevolg van de Subs is er veel in het programma en in het structuur-
     schema verandert
   In Einde-routine leesbaarheid programma verbeterd

Einde Yathzee-history

Programmastuctuurschema (boomdiagram)

 Verklaring gebruikte letters:
  S=Subroutine
  Z=Zelfde routine
  F=Wordt als Functie aangeroepen
  M=Routine die van verschillende plaatsen wordt aangeroepen
  N=Staat niet op deze plek in programma, subroutines hier niet genoemd

 Yathzee v2.20
 รฤฤ[Z]Hoofdprogramma
 ณ   รฤฤ[SF]Controleren schermgrootte
 ณ   รฤฤ[SF]Top11File
 ณ   ณ   รฤฤ[SFN]OpenFile
 ณ   ณ   รฤฤ[SFN]CloseFile
 ณ   ณ   ภฤฤ[SFN]GetFSize
 ณ   รฤฤ[S]Opening
 ณ   ณ   รฤฤ[Z]Openingsscherm afbeelden
 ณ   ณ   ณ   ภฤฤ[SFN]ReadQueue
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (aantal spelers)
 ณ   ณ   ณ   รฤฤ[SFN]Top11Zien
 ณ   ณ   ณ   ภฤฤ[SFN]UserInput
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (namen en initialen)
 ณ   ณ   ณ   ภฤฤ[SFN]UserInput
 ณ   ณ   ภฤฤ[Z]Variabelen voor puntentelling beginwaarden geven
 ณ   รฤฤ[S]SchermOpbouwen
 ณ   ณ   ภฤฤ[SFN]Stenen
 ณ   รฤฤ[S]Gooien
 ณ   ณ   รฤฤ[SFM]Stenen
 ณ   ณ   ภฤฤ[SFN]UserInput
 ณ   รฤฤ[S]Keuze
 ณ   ณ   รฤฤ[SF]Punten
 ณ   ณ   รฤฤ[SF]TotaalSc
 ณ   ณ   ณ   ภฤฤ[SFN]Yes
 ณ   ณ   ภฤฤ[SFN]UserInput
 ณ   รฤฤ[S]Einde
 ณ   ณ   รฤฤ[Z]Na(a)m(en) winnaar(s) afbeelden
 ณ   ณ   รฤฤ[Z]Yathzee-Top-11 bijwerken
 ณ   ณ   ณ   รฤฤ[SFN]OpenFile
 ณ   ณ   ณ   รฤฤ[SFN]CloseFile
 ณ   ณ   ณ   รฤฤ[SFN]SetFPos
 ณ   ณ   ณ   รฤฤ[SFN]ReadEntry
 ณ   ณ   ณ   ภฤฤ[SFN]WriteEntry
 ณ   ณ   ภฤฤ[Z]Nog een keer? & Tot ziens!
 ณ   ณ       ภฤฤ[SFN]Yes
 ณ   รฤฤ[ZFM]Top11Zien
 ณ   ณ   รฤฤ[SFN]OpenFile
 ณ   ณ   รฤฤ[SFN]CloseFile
 ณ   ณ   รฤฤ[SFN]SetFPos
 ณ   ณ   รฤฤ[SFN]ReadEntry
 ณ   ณ   รฤฤ[SFN]ReadQueue
 ณ   ณ   ภฤฤ[SFN]WaitForKey
 ณ   ภฤฤ[Z]Yathzee verlaten
 ภฤฤ[Z]Subs
     รฤฤ[SFM]OpenFile
     รฤฤ[SFM]CloseFile
     รฤฤ[SFM]GetFSize
     รฤฤ[SFM]SetFPos
     รฤฤ[SFM]ReadEntry
     รฤฤ[SF]WriteEntry
     รฤฤ[SFM]ReadQueue
     รฤฤ[SFM]UserInput
     รฤฤ[SFM]Yes
     ณ   ภฤฤ[SFN]UserInput
     ภฤฤ[SF]WaitForKey
         ภฤฤ[SFN]UserInput

Einde Programmastructuurschema
*/

/* Hoofdprogramma */
RxCrStat('off')
versie='2.20'; jaar='1996'
If ScrSiz(25,80) & Top11File(Arg(1)) /* set variables: scr */
  Then Do
    Do Until sp=-1
      Call Opening
      Call SchermOpbouwen
      Do 13 Until sp=-1
        Do sp=1 To splrs Until sp=-1
          Call Gooien
          Call Keuze
        End sp
      End
      Call Einde
    End
    Top11Zien(scr)
    RxCls()
  End

/* Yathzee verlaten */
RxCrStat('on')
Exit
/* Einde Hoofdprogramma */

/* Controleren schermgrootte */
ScrSiz: Procedure

Arg rows, cols
If RxScrSiz()<>rows' 'cols
  Then Do
    rc=0
    /*   0123456789012345678901234567890123456789  */
    Say 'Om Yathzee te draaien moet het scherm   '||,
        'in een 80x25-modus staan.'
  End
Else rc=1

Return rc
/* Einde ScrSiz */

/* Yathzee-Top-11 file initialisatie */
Top11File: Procedure Expose versie scr

/* naam */
Arg scr .
If scr=''
  Then Do
    Parse Source . . execfile
    scr=(SubStr(execfile,1,LastPos('\',execfile)))('YATHZEE.SCR')
  End

/* controle en evt. aanmaken nieuwe file */
ok=0
Select
  When OpenFile(scr,,5)<>'READY'
    Then Say 'Error bij openen 'scr'.'
  When \(CharIn(scr,1,5)<>'YT11F' & GetFSize(scr)=0 & GetFSize(scr)<>247,
       | CharIn(scr,1,5)='YT11F' & GetFSize(scr)<>0 & GetFSize(scr)=247)
    Then Say scr' is geen Yathzee-Top-11 file.'
  Otherwise
    ok=1
    If GetFSize(scr)=0
      Then Do
        rc=CharOut(scr,'YT11F')
        Do 11
          rc=CharOut(scr,Left('Yathzee v'versie,20))
          rc=CharOut(scr,D2C(0,2))
        End
      End
End
CloseFile(scr)

Return ok
/* Einde Top11File */

/* Opening */
Opening: Procedure Expose splrs naam. init. gemkeu scl. scr. scr versie jaar

/* Openingsscherm afbeelden */
Do Until splrs<>'T'
  Queue 'Û     Û  Û฿฿฿฿฿Û  ฿฿฿Û฿฿฿  Û     Û  ฿฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û฿฿฿฿฿฿'
  Queue 'Û     Û  Û     Û     Û     Û     Û        Û  Û        Û      '
  Queue '฿฿฿Û฿฿฿  Û฿฿฿฿฿Û     Û     Û฿฿฿฿฿Û   ÜÜ฿฿฿   Û฿฿฿฿฿   Û฿฿฿฿฿ '
  Queue '   Û     Û     Û     Û     Û     Û  Û        Û        Û      '
  Queue '   Û     Û     Û     Û     Û     Û  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ  ÛÜÜÜÜÜÜ'
  Queue ''
  Queue 'Û฿฿฿฿฿Û  Û฿฿฿฿฿฿  Û     Û  Û     Û'
  Queue 'Û     Û  Û         Û   Û    Û   Û '
  Queue 'Û฿฿฿Û฿฿  Û฿฿฿฿฿     ÛÛÛ      ÛÛÛ  '
  Queue 'Û    Û   Û         Û   Û    Û   Û '
  Queue 'Û     Û  ÛÜÜÜÜÜÜ  Û     Û  Û     Û'
  RxCls(16); Say; Say
  ReadQueue(11,'w')
  Do 11; Say; End
  rc=RxWrScr(Centre('Versie 'versie'  Hans van Kranenburg 'jaar'  IBM PC DOS',
    '7.0 REXX',80),23)
  If splrs<>'T' Then RxSleep(2)

  /* Informatie spelers opvragen (aantal spelers) */
  splrs=0
  RxSetPos(14,5)
  rc=RxWrScr("Aantal spelers [1-5] of 'T' voor Yathzee-Top-11 ?",23)
  RxCls(,14,55,14,55)
  Do Until splrs>=1 & splrs<=5 | splrs='T'
    RxSetPos(14,55); splrs=UserInput()
    RxCls(16,22,0,22,79)
    Select
      When splrs='T' Then Top11Zien(scr)
      When splrs>=1 & splrs<=5 Then Nop
      Otherwise rc=RxWrScr(Centre("Aantal spelers tussen 1 en 5 of 'T' voor",
        'Yathzee-Top-11',80),23)
    End
  End
End

/* Informatie spelers opvragen (namen en initialen) */
Do n=1 To splrs; v=15+n
  RxSetPos(v,5); rc=RxWrScr('Naam speler 'n':',23)
  RxCls(,v,20,v,39); naam.n=Left(UserInput('P'),20)
  RxCls(16,v,40,v,79);RxCls(16,v+1,0,v+1,66)
  RxSetPos(v,44); rc=RxWrScr('Initialen speler 'n':',23)
  RxCls(,v,64,v,67); init.n=Left(UserInput('P'),4)
  RxCls(16,v,68,v,79); RxCls(16,v+1,0,v+1,79); RxCls(16,v+2,0,v+2,30)
End n

/* Variabelen voor puntentelling beginwaarden geven */
gemkeu=Copies('0',splrs*13) /* gemaakte keuzes*/; scl.=0; scr.=0

Return
/* Einde Opening */

/* Scherm opbouwen */
SchermOpbouwen: Procedure Expose versie splrs init.

RxCls(16,24,0,24,79); RxCls(,0,0,23,79)
rc=RxWrScr(Right('YATHZEE Versie 'versie,49),23)
rc=RxWrScr(Right('Hans van Kranenburg',31),23); Say
rc=CharOut(,'ษอออออออออออออหออออัออออัออออัออออัออออหออออออออออออออหออออัอออ'||,
'อัออออัออออัออออปบEnen         บ    ณ    ณ    ณ    ณ    บDrie dezelfde บ   '||,
' ณ    ณ    ณ    ณ    บบTween       บ    ณ    ณ    ณ    ณ    บVier dezelfde'||,
' บ    ณ    ณ    ณ    ณ    บบDrien       บ    ณ    ณ    ณ    ณ    บVolle ba'||,
'k     บ    ณ    ณ    ณ    ณ    บบVieren       บ    ณ    ณ    ณ    ณ    บKle'||,
'ine straat บ    ณ    ณ    ณ    ณ    บบVijven       บ    ณ    ณ    ณ    ณ   '||,
' บGrote straat  บ    ณ    ณ    ณ    ณ    บบZessen       บ    ณ    ณ    ณ   '||,
' ณ    บYathzee       บ    ณ    ณ    ณ    ณ    บวฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤฤลฤฤฤ'||,
'ฤลฤฤฤฤลฤฤฤฤถVrije keuze   บ    ณ    ณ    ณ    ณ    บบTotaal puntenบ    ณ   '||,
' ณ    ณ    ณ    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤลฤฤฤฤถบExtra bonus  บ   '||,
' ณ    ณ    ณ    ณ    บTotaal rechts บ    ณ    ณ    ณ    ณ    บบTotaal links'||,
' บ    ณ    ณ    ณ    ณ    บTotaal links  บ    ณ    ณ    ณ    ณ    บศอออออออ'||,
'ออออออสออออฯออออฯออออฯออออฯออออนTotaal ฤฤฤฤฤฤ>บ    ณ    ณ    ณ    ณ    บ')
rc=RxWrScr('Speler',9)
rc=CharOut(,Right('ศออออออออออออออสออออฯออออฯออออฯออออฯออออผ',74))
v.=1; st.=' '; Stenen('los')
Do n=1 To splrs
  RxSetPos(1,5*(n+2)); rc=RxWrScr(init.n,7)
  RxSetPos(1,5*(n+10)); rc=RxWrScr(init.n,7)
End n
Do n=10 To 12; Do q=1 To splrs; RxSetPos(n,13+5*q); Say 0; End q; End n
Do n=11 To 13; Do q=1 To splrs; RxSetPos(n,53+5*q); Say 0; End q; End n

Return
/* Einde SchermOpbouwen */

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
  If worp<3
    Then Do
      RxCls(,15,0,19,79)
      Say 'Welke stenen moeten vastgehouden worden bij de volgende worp?'
      Say '  1. Steen 1    5. Steen 5'
      Say '  2. Steen 2    V. Alle stenen vasthouden'
      Say '  3. Steen 3    L. Alle stenen los'
      Say '  4. Steen 4    G. Volgende worp'
      Do Until n='G' | C2D(n)=13
        RxSetPos(15,62); n=UserInput()
        RxCls(16,24,6,24,79)
        Select
          When n>=1 & n<=5 Then
            If v.n Then Stenen('los',n,n)
            Else Stenen('vast',n,n)
          When n='V' Then Stenen('vast')
          When n='L' Then Stenen('los')
          When n='G' | C2D(n)=13 Then Nop
          Otherwise
            RxSetPos(24,6)
            rc=RxWrScr(Centre('Verkeerde keuze ฤฤ Toets 1, 2, 3, 4, 5, V, L of',
              'G',68),23)
        End
      End
    End
End worp
Stenen('los'); RxCls(16,24,0,24,5)

Return
/* Einde Gooien */

/* Bepaald aantal stenen los/vast                 ฺฤฤฤ default ฤฤฤฟ
   Parameters: ['los'/'vast'] en evt. [van steen (1)] [tot steen (5)] */
Stenen: Procedure Expose v. st.

Arg lv, st1, st2
If st2='' Then st2=5
If st1='' Then st1=1
If lv='LOS' Then Do; lv=0; kl=7; End
Else If lv='VAST' Then Do; lv=1; kl=10; End
Do n=st1 To st2
  If v.n<>lv
    Then Do
      v.n=lv
      RxSetPos(21,16+7*n); rc=RxWrScr('ษอออป',kl)
      RxSetPos(22,16+7*n); rc=RxWrScr('บ 'st.n' บ',kl)
      RxSetPos(23,16+7*n); rc=RxWrScr('ศอออผ',kl)
    End
End n

Return ''
/* Einde Stenen */

/* Keuze maken */
Keuze: Procedure Expose gemkeu sp scl.sp scr.sp st.

v.=0; v.1='NV'; v.2='NV'; v.3='' /* initialisatie Verzamel */
RxCls(,15,0,19,79)
Say 'Maak uw keuze:'
Say '  1. Enen     5. Vijven           9. Volle bak       13. Vrije keuze'
Say '  2. Tween   6. Zessen          10. Kleine straat   14. Einde spel'
Say '  3. Drien   7. Drie dezelfde   11. Grote straat'
Say '  4. Vieren   8. Vier dezelfde   12. Yathzee'
ok=0
Do Until k>=1 & k<=13 & ok=1 | k=14
  RxCls(,15,15,15,79); k=UserInput('L')
  RxCls(16,24,0,24,79)
  Select
    When k>=1 & k<=13 & DataType(k,'n')
      Then Do
        If \SubStr(gemkeu,13*(sp-1)+k,1)
          Then Do
            p=Punten(k)
            If TotaalSc(p)
              Then Do; gemkeu=Overlay(1,gemkeu,13*(sp-1)+k); ok=1; End
          End
        Else rc=RxWrScr(Centre('Deze keuze is al eerder gemaakt.',80),23)
      End
    When k=14 Then sp=-1
    Otherwise rc=RxWrScr(Centre('Verkeerde keuze gemaakt.',80),23)
  End
End

Return
/* Einde Keuze */

/* Punten voor gemaakte keuze vaststellen */
Punten: Procedure Expose st. v.

Arg k
/* hoeveel keer is een steen gegooid? (verzamel) */
If k<=12 & v.1='NV'
  Then Do
    v.1='VZ'
    Do n=1 To 5
      q=st.n
      v.1.q=v.1.q+1
    End n
  End

/* hoeveel keer is hoeveel keer een steen gegooid? (verzamel) */
If (k>=7 & k<=9 | k=12) & v.2='NV'
  Then Do
    v.2='VZ'
    Do n=1 To 6
      q=v.1.n
      v.2.q=v.2.q+1
    End n
  End

/* plak van steen >=1 keer gegooid */
If (k=10 | k=11) & v.3=''
  Then Do n=1 To 6
    If v.1.n>=1 Then v.3=(v.3)(1)
    Else v.3=(v.3)(0)
  End n

/* waarden van alle stenen optellen in v.4 */
If (k=7 | k=8 | k=13) & v.4=0
  Then Do n=1 To 5
    v.4=v.4+st.n
  End n

/* punten gemaakte keuze ophalen */
Select
  When k>=1 & k<=6 Then punten=k*v.1.k
  When k=7 & v.2.3=1 | (k=7 | k=8) & v.2.4=1 | (k=7 | k=8) & v.2.5=1 | k=13
    Then punten=v.4
  When k=9 & v.2.2=1 & v.2.3=1 Then punten=25
  When k=10 & (Left(v.3,4)='1111' | SubStr(v.3,2,4)='1111',
         | Right(v.3,4)='1111')
    Then punten=30
  When k=11 & (Left(v.3,5)='11111' | Right(v.3,5)='11111') Then punten=40
  When k=12 & v.2.5=1 Then punten=50
  Otherwise punten=0
End

Return punten
/* Einde Punten */

/* Punten afbeelden of evt. nieuwe keuze maken */
TotaalSc: Procedure Expose k sp scl.sp scr.sp

Arg punten
/* waarschuwen als er geen punten behaald worden */
ok=1
If punten=0
  Then Do
    RxSetPos(24,0)
    rc=RxWrScr(Centre('Deze keuze levert geen punten op! Doorgaan [J/N]',
      '?',80),23)
    If \Yes('J','N') Then ok=0
    RxCls(16,24,0,24,79)
  End

/* punten optellen en afbeelden */
If ok
  Then Do
    bonus=0
    If k<=6
      Then Do
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
/* Einde TotaalSc */

/* Einde */
Einde: Procedure Expose splrs sp scl. scr. naam. scr versie

/* Na(a)m(en) winnaar(s) afbeelden */
/* totaalscores spelers */
Do n=1 To splrs
  If scl.n>=63 Then scl.n=scl.n+35
  sct.n=scl.n+scr.n
End n

/* hoogste score */
sct=sct.1
If splrs>1
  Then Do n=2 To splrs
    If sct.n>sct Then sct=sct.n
  End n

/* namen van spelers met hoogste score (meerdere winnaars mogelijk) */
w=0
Do n=1 To splrs
  If sct.n=sct
    Then Do; w=w+1
      If naam.n='' Then naamx.w='Speler 'n
      Else naamx.w=Strip(naam.n)
    End
End n

/* namen winnaars afbeelden op scherm */
RxCls(,15,0,23,79)
If sct=1 Then n='punt'; Else n='punten'
If w=1
  Then Do
    Say; Say
    Say Centre(naamx.1' heeft gewonnen met 'sct' 'n'!',80)
  End
Else Do
  Say
  Say Centre('Deze spelers hebben gewonnen met 'sct' 'n':',80)
  Do n=1 To w
    rc=CharOut(,Centre(naamx.n,80))
  End n
End

/* Yathzee-Top-11 bijwerken */
/* totaalscores spelers + namen controleren */
Do n=splrs To 1 By -1
  If naam.n='' Then naam.n=Left('Yathzee v'versie,20)
  sc.n=(naam.n)(Right(sct.n,3,0))
End n

/* file openen + oude Yathzee-Top-11 inlezen */
OpenFile(scr,,0); SetFPos(scr,6)
Do n=11+splrs To splrs+1 By -1; sc.n=ReadEntry(scr); End n

n=n+1
If Right(sc.n,3)<sct
  Then Do
    /* alle scores sorteren m.b.v. Bubblesort */
    Do grens=splrs+11-1 To splrs By -1 Until stop; stop=0
      Do n=1 To grens Until ok; m=n+1; ok=0
        If Right(sc.n,3)>Right(sc.m,3)
          Then Do; h=sc.n; sc.n=sc.m; sc.m=h; End
        Else If n>splrs Then ok=1
        Else If n=splrs Then Do; ok=1; stop=1; End
      End n
    End grens

    /* nieuwe Yathzee-Top-11 wegschrijven */
    SetFPos(scr,6)
    Do n=11+splrs To splrs+1 By -1; WriteEntry(scr,sc.n); End n
  End

/* file sluiten */
CloseFile(scr)

/* Nog een keer? & Tot ziens! */
RxSetPos(24,0); rc=RxWrScr(Centre('Opnieuw beginnen [J/N] ?',80),23)
If Yes('J','N')
  Then sp=0 /* Bij keuze 14 dan sp wordt -1, bij nog een spelletje wordt
               afsluiten voorkomen door sp niet meer -1 te laten zijn */
Else  Do
  RxSetPos(24,0); rc=RxWrScr(Centre('Tot ziens!',80),23)
  sp=-1; RxSleep(2)
End

Return
/* Einde Einde */

/* Speler wil Yathzee-Top-11 zien */
Top11Zien: Procedure Expose versie

Arg scr
RxCls(); Say; Say
Say Centre('Yathzee-Top-11  YATHZEE Versie 'versie,80); Say
Queue 'ษออออออออออออออออออออออออออออออออออัอออออออออออออออออออป'
Queue 'บ Speler                           ณ Score             บ'
Queue 'วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ'
Queue 'ศออออออออออออออออออออออออออออออออออฯอออออออออออออออออออผ'
ReadQueue(3)
OpenFile(scr,'read',0)
SetFPos(scr,6)
Do n=8 To 18
  a=ReadEntry(scr)
  rc=CharOut(,Centre(('บ ')(Right(n-7,2,'0'))('. ')(Left(a,20))('         ')||,
  ('ณ ')(Right(a,3))('               บ'),80))
End
CloseFile(scr)
ReadQueue()
Say; Say; rc=Charout(,Centre('Druk op een toets om verder te gaan ...',80))
WaitForKey()

Return ''
/* Einde Top11Zien */

/* Subs */

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

ReadQueue: Procedure
Arg p, q, r
If r='' Then r=18
If q='' Then q='C'
If p='' Then p=1
Do p
  Parse Pull s
  Select
    When q='C' Then rc=CharOut(,Centre(s,80))
    When q='W' Then rc=RxWrScr(Centre(s,80),r)
  End
End
Return ''

UserInput: Procedure
Arg p, q, r, s
If s='' Then s=1
If r='' Then r='ECHO'
If q='' Then q='ON'
RxCrStat(q)
Select
  When p='K' | p='' Then Do; inp=RxGetKey(r); If s Then inp=Translate(inp); End
  When p='L' Then Parse Linein inp
  When p='P'  Then Parse Pull inp
End
If q='ON' Then RxCrStat('off')
Return inp

Yes: Procedure
Arg yes, no
Do Until n=yes | n=no
  n=UserInput(,'off','noecho')
  If n=yes Then rc=1
  If n=no Then rc=0
End
Return rc

WaitForKey: Procedure
Do Until Chars()=0; rc=UserInput(,'off','noecho',0); End
Return ''

/* Einde Subs */
/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ EOF YATHZEE Versie 2.20  Hans van Kranenburg 1995-1996  IBM PC DOS 7.0 REXX  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
