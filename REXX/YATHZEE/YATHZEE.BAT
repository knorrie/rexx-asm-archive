/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ   YATHZEE Versie 2.40  Hans van Kranenburg 1995-1997  IBM PC DOS 7.0 REXX    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

Yathzee-history:

 Versie 1.00  In produktie gegaan: -

 Versie 2.00  In produktie gegaan: -
 Wijzigingen:
   Alles, het programma is totaal herschreven

 Versie 2.01  In produktie gegaan: -
 Wijzigingen:
   Bij verkeerde keuze is '--' in 'ฤฤ' veranderd
   Type-foutje bij 'Is scl.sp>63 Then bonus=35' verbeterd

 Versie 2.02  In produktie gegaan: -
 Wijzigingen:
   Gooien.stenen routine aangepast, nu ook voor stenen vasthouden
   Extra keuze bij gooien: Alle stenen vast
   Bonus-bug opgelost
   Veranderde manier opbouw openingsscherm; nu m.b.v. internal data queue
   Aanpassing routine scherm opbouwen, programmacode past nu op scherm

 Versie 2.10  In produktie gegaan: 20 april 1996
 Wijzigingen:
   Er wordt nu een Yathzee-Top-10 bijgehouden
   Veel kleine dingen aangepast

 Versie 2.11  In produktie gegaan: 03 mei 1996
 Wijzigingen:
   De Yathzee-Top-10 is een Yathzee-Top-11 geworden
   Invoer van toetsenbord ook met Linein, doskey wordt niet gebruikt,
     dus niet al de keuzes in doskey-history
   Kleine stroomlijn- en schoonheidsfoutjes verholpen

 Versie 2.12  In produktie gegaan: 03 juni 1996
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

 Versie 2.13  In produktie gegaan: -
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

 Versie 2.20  In produktie gegaan: 31 juli 1996
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

 Versie 2.30  In produktie gegaan: -
 Wijzigingen:
   gemkeu variabele is een array geworden
   Yathzee geeft nu advies voor keuze
   Eigen UserInput routine gemaakt om stomme Pull en Parse LineIn en RxGetKey
     te vervangen, buiten de vakjes typen is niet meer mogelijk!!!!!
   Sub ReadQueue verwijderd
   Subs uit pss verwijderd
   Swap variabelen in bubblesort(Einde) nu m.b.v. REXX internal queue
   In de sub Yes geldt enter ook als YES
   Yathzee geeft bij de laatste keuze (1 mogelijkheid over) advies voor keuze
   UsrInput is een externe sub geworden
   Doordat UsrInput bij v1.01 zelf cursor aan/uit regelt m.b.v. uitgebreide
     RxCrStat hoeft Yathzee dit niet meer te doen
   Het advies bij keuze wordt knipperend weergegeven

 Versie 2.40  In produktie gegaan: 31 januari 1997
 Wijzigingen:
   Door UserInput v2.01 zijn USRINPUT.BAT en RXCRSTAT.RX (uitgebreid) niet
     meer meegeleverd
   Vanwege UserInput v2.01 zijn de aanroepen van deze functie veranderd
   De dobbelstenen staan nu iets verder van elkaar af
   Lompe subs voor file in- en output en Yes enzo verwijderd
   Subs blijken dus bij nader inzien niet erg handig, het maakt Yathzee
     onnodig onoverzichtelijk en de scr* programma's veranderen toch niet
     zo drastisch, laat staan dat ik met subs heen en weer zou gaan zitten
     slepen. Maar ja, iedereen heeft wel eens iets geks in z'n kop dat er
     uit moet em wat later weer allemaal teruggedraaid moet worden, omdat het
     bij nader inzien maar lomp was. Amen. Einde preek. :-]
   De sub Yes is twee keer (aangepast) in het programma opgenomen
     Enter werkt hier niet meer als Ja-antwoord
   Subs ook uit SCR* verwijderd

Einde Yathzee-history

Programmastuctuurschema (boomdiagram)

 Verklaring gebruikte letters:
  S=Subroutine
  Z=Zelfde routine
  F=Wordt als Functie aangeroepen
  M=Routine die van verschillende plaatsen wordt aangeroepen
  N=Staat niet op deze plek in programma, subroutines hier niet genoemd
  E=Externe routine

  Subs worden niet aangegeven

 Yathzee v2.40
 รฤฤ[Z]Hoofdprogramma
 ณ   รฤฤ[SF]Controleren schermgrootte
 ณ   รฤฤ[SF]Top11File
 ณ   รฤฤ[S]Opening
 ณ   ณ   รฤฤ[Z]Openingsscherm afbeelden
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (aantal spelers)
 ณ   ณ   ณ   ภฤฤ[SFN]Top11Zien
 ณ   ณ   รฤฤ[Z]Informatie spelers opvragen (namen en initialen)
 ณ   ณ   ภฤฤ[Z]Variabelen voor puntentelling beginwaarden geven
 ณ   รฤฤ[S]SchermOpbouwen
 ณ   ณ   ภฤฤ[SFN]Stenen
 ณ   รฤฤ[S]Gooien
 ณ   ณ   ภฤฤ[SFM]Stenen
 ณ   รฤฤ[S]Keuze
 ณ   ณ   รฤฤ[S]Verzamel
 ณ   ณ   รฤฤ[SF]Advies
 ณ   ณ   ณ   ภฤฤ[SFN]Punten
 ณ   ณ   รฤฤ[SFM]Punten
 ณ   ณ   ภฤฤ[SF]TotaalSc
 ณ   รฤฤ[S]Einde
 ณ   ณ   รฤฤ[Z]Na(a)m(en) winnaar(s) afbeelden
 ณ   ณ   รฤฤ[Z]Yathzee-Top-11 bijwerken
 ณ   ณ   ภฤฤ[Z]Nog een keer? & Tot ziens!
 ณ   รฤฤ[ZFM]Top11Zien
 ณ   ภฤฤ[Z]Yathzee verlaten
 ภฤฤ[FME]UsrInput

Einde Programmastructuurschema
*/

/* Hoofdprogramma */
RxCrStat('off')
versie='2.40'; jaar='1997'
If ScrSiz(25,80) & Top11File(Arg(1)) /* set variables: scr */
  Then Do
    Do Until kt=14
      Call Opening
      Call SchermOpbouwen
      Do kt=1 to 13 /* keuze teller */
        Do sp=1 To splrs Until kt=13
          Call Gooien
          Call Keuze
        End sp
      End kt
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
    scr=(Left(execfile,LastPos('\',execfile)))('YATHZEE.SCR')
  End
Else If Pos('.',scr)=0 Then scr=scr||'.SCR'

/* controle en evt. aanmaken nieuwe file */
ok=0
Select
  When Stream(scr,'c','open')<>'READY'
    Then Say 'Error bij openen 'scr'.'
  When \(CharIn(scr,1,5)<>'YT11F' & Stream(scr,'c','query size')=0,
       & Stream(scr,'c','query size')<>247 | CharIn(scr,1,5)='YT11F',
       & Stream(scr,'c','query size')<>0 & Stream(scr,'c','query size')=247)
    Then Say scr' is geen Yathzee-Top-11 file.'
  Otherwise
    ok=1
    If Stream(scr,'c','query size')=0
      Then Do
        rc=CharOut(scr,'YT11F')
        Do 11
          rc=CharOut(scr,Left('Yathzee v'versie,20))
          rc=CharOut(scr,D2C(0,2))
        End
      End
End
rc=Stream(scr,'c','close')

Return ok
/* Einde Top11File */

/* Opening */
Opening: Procedure Expose splrs naam. init. gemkeu. scl. scr. scr versie jaar

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
  Do 11; Parse Pull q; rc=RxWrScr(Centre(q,80),18); End
  Do 11; Say; End
  rc=RxWrScr(Centre('YATHZEE Versie 'versie'  Hans van Kranenburg 'jaar'  IBM',
  'PC DOS 7.0 REXX',80),23)
  If splrs<>'T' Then RxSleep(2)

  /* Informatie spelers opvragen (aantal spelers) */
  splrs=0
  RxSetPos(14,5)
  rc=RxWrScr("Aantal spelers [1-5] of 'T' voor Yathzee-Top-11 ?",23)
  RxCls(16,14,55,14,55)
  Do Until splrs>=1 & splrs<=5 | splrs='T'
    splrs=UsrInput('014717200E37'x)
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
  RxSetPos(v,44); rc=RxWrScr('Initialen speler 'n':',23)
End n
Do n=1 To splrs; v=15+n
  RxSetPos(v,20); naam.n=Left(UsrInput('141B172E'x),20)
  rc=RxWrScr(naam.n,23)
  RxSetPos(v,64); init.n=Left(UsrInput('041B172E'x),4)
  rc=RxWrScr(init.n,23)
End n

/* Variabelen voor puntentelling beginwaarden geven */
gemkeu.=0 /* gemaakte keuzes*/; scl.=0; scr.=0

Return ''
/* Einde Opening */

/* Scherm opbouwen */
SchermOpbouwen: Procedure Expose versie splrs init.

RxCls(16,24,0,24,79); RxCls(,0,0,23,79)
rc=RxWrScr(Centre('YATHZEE Versie 'versie,80),23); Say
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

Return ''
/* Einde SchermOpbouwen */

/* Gooien */
Gooien: Procedure Expose sp naam.sp st.

v.=0 /* steen vast */
RxCls(,14,20,14,38)
RxSetPos(14,7); rc=RxWrScr(sp,9)
RxSetPos(14,19); rc=RxWrScr(naam.sp,9)
RxSetPos(24,0); rc=RxWrScr('Worp',23)
RxCls(,15,0,19,79)
Say 'Welke stenen moeten vastgehouden worden bij de volgende worp?    ( )'
Say '  1. Steen 1    5. Steen 5'
Say '  2. Steen 2    V. Alle stenen vasthouden'
Say '  3. Steen 3    L. Alle stenen los'
Say '  4. Steen 4    G. Volgende worp'
Do worp=1 To 3
  RxSetPos(24,5); rc=RxWrScr(worp,23)
  Do n=1 To 5
    If \v.n Then Do; st.n=Random(1,6); RxSetPos(22,n*8+16); Say st.n; End
  End n; n=''
  If worp<3
    Then Do Until n='G' | n=''
      n=UsrInput('014507200F3E'x)
      RxSetPos(15,66)
      Say n
      RxCls(16,24,6,24,79)
      Select
        When n>=1 & n<=5 Then
          If v.n Then Stenen('los',n,n)
          Else Stenen('vast',n,n)
        When n='V' Then Stenen('vast')
        When n='L' Then Stenen('los')
        When n='G' | n='' | n=0 Then Nop
        Otherwise
          RxSetPos(24,6)
          rc=RxWrScr(Centre('Verkeerde keuze ฤฤ Toets 1, 2, 3, 4, 5, V, L of',
            'G',68),23)
      End
    End
End worp
Stenen('los')
/* RxCls(16,24,0,24,5) : wel/niet 'Worp 3' afbeelden */

Return ''
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
      RxSetPos(21,14+8*n); rc=RxWrScr('ษอออป',kl)
      RxSetPos(22,14+8*n); rc=RxWrScr('บ 'st.n' บ',kl)
      RxSetPos(23,14+8*n); rc=RxWrScr('ศอออผ',kl)
    End
End n

Return ''
/* Einde Stenen */

/* Keuze maken */
Keuze: Procedure Expose sp gemkeu. scl.sp scr.sp st. kt

Call Verzamel
Parse Value Advies() With adv_n '|' adv_str '|' laatste
RxCls(,15,0,19,79)
Say 'Maak uw keuze:'
Say '  1. Enen     5. Vijven           9. Volle bak       13. Vrije keuze'
Say '  2. Tween   6. Zessen          10. Kleine straat   14. Einde spel'
Say '  3. Drien   7. Drie dezelfde   11. Grote straat'
rc=CharOut(,'  4. Vieren   8. Vier dezelfde   12. Yathzee         ')
If adv_n<>''
  Then Do
    Say 'Enter: 'adv_str
    If \laatste
      Then Do
        RxSetPos(0,1)
        rc=RxWrScr('ฏ 'adv_str' ฎ',151)
      End
  End
ok=0
Do Until k>=1 & k<=13 & ok=1 | k=14
  k=UsrInput('027707200F0F'x,adv_n)
  RxCls(16,24,0,24,79)
  Select
    When k>=1 & k<=13 & DataType(k,'n')
      Then Do
        If \gemkeu.sp.k
          Then Do
            p=Punten(k)
            If TotaalSc(p); Then Do; gemkeu.sp.k=1; ok=1; End
          End
        Else rc=RxWrScr(Centre('Deze keuze is al eerder gemaakt.',80),23)
      End
    When k=14 Then kt=13
    Otherwise rc=RxWrScr(Centre('Verkeerde keuze gemaakt.',80),23)
  End
End
If adv_n<>'' Then RxCls(16,0,1,0,21)

Return ''
/* Einde Keuze */

/* Verzamelen van stenen */
Verzamel: Procedure Expose st. v.

/* initialisatie */
v.=0; v.3=''

/* hoeveel keer is een steen gegooid? (verzamelen st.{1-5}) */
Do n=1 To 5; q=st.n; v.1.q=v.1.q+1; End n

/* hoeveel keer is hoeveel keer een steen gegooid? (verzamelen v.1.{1-6}) */
Do n=1 To 6; q=v.1.n; v.2.q=v.2.q+1; End n

/* plak van steen >=1 keer gegooid */
Do n=1 To 6; If v.1.n>=1 Then v.3=(v.3)(1); Else v.3=(v.3)(0); End n

/* waarden van alle stenen optellen in v.4 */
Do n=1 To 5; v.4=v.4+st.n; End n

Return ''
/* Einde Verzamel */

/* Kiesadvies: er wordt bekeken of een van de keuzes tussen 12 en 7 punten
   zou opleveren, ook bij laatste keuze maken geeft advies, de enige over-
   geblevene, return is nummer keuze en tekst */
Advies: Procedure Expose v. sp gemkeu. kt

adv=''
k.1='1|Enen'
k.2='2|Tween'
k.3='3|Drien'
k.4='4|Vieren'
k.5='5|Vijven'
k.6='6|Zessen'
k.7='7|Drie dezelfde'
k.8='8|Vier dezelfde'
k.9='9|Volle bak'
k.10='10|Kleine straat'
k.11='11|Grote straat'
k.12='12|Yathzee'
k.13='13|Vrije keuze'
If kt<>13
  Then Do n=7 to 12
    If Punten(n)<>0 & \gemkeu.sp.n Then adv=k.n||'|0'
  End n
Else Do n=1 to 13 Until adv<>''
  If \gemkeu.sp.n Then adv=k.n||'|1'
End

Return adv
/* Einde Advies */

/* Punten voor gemaakte keuze vaststellen */
Punten: Procedure Expose  v.

Arg k
Select
  When k>=1 & k<=6 Then punten=k*v.1.k
  When k=7 & v.2.3=1 |,
      (k=7 | k=8) & v.2.4=1 |,
      (k=7 | k=8) & v.2.5=1 |,
       k=13 Then punten=v.4
  When k=9 & v.2.2=1 & v.2.3=1 Then punten=25
  When k=10 & Pos('1111',v.3)<>0 Then punten=30
  When k=11 & Pos('11111',v.3)<>0 Then punten=40
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
If punten=0 & kt<>13
  Then Do
    RxSetPos(24,0)
    rc=RxWrScr(Centre('Deze keuze levert geen punten op! Doorgaan [J/N]',
      '?',80),23)
    RxSetPos(24,0)
    Do Until n='J' | n='N'
      n=UsrInput('01040020'x)
      Select
        When n='J' Then ok=1
        When n='N' Then ok=0
        Otherwise Nop
      End
    End
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
Einde: Procedure Expose splrs sp scl. scr. naam. scr versie kt

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
rc=Stream(scr,'c','open'); rc=Stream(scr,'c','seek =6')
Do n=11+splrs To splrs+1 By -1
  sc.n=(CharIn(scr,,20))(Right(C2D(CharIn(scr,,2)),3,0))
End n

n=n+1
If Right(sc.n,3)<sct
  Then Do
    /* alle scores sorteren m.b.v. Bubblesort */
    Do grens=splrs+11-1 To splrs By -1 Until stop; stop=0
      Do n=1 To grens Until ok; m=n+1; ok=0
        If Right(sc.n,3)>Right(sc.m,3)
          Then Do
            Push sc.n; Push sc.m
            Parse Pull sc.n; Parse Pull sc.m
          End
        Else If n>splrs Then ok=1
        Else If n=splrs Then Do; ok=1; stop=1; End
      End n
    End grens

    /* nieuwe Yathzee-Top-11 wegschrijven */
    rc=Stream(scr,'c','seek =6')
    Do n=11+splrs To splrs+1 By -1
      rc=CharOut(scr,(Left(sc.n,20))(D2C(Right(sc.n,3),2)))
    End n
  End

/* file sluiten */
rc=Stream(scr,'c','close')

/* Nog een keer? & Tot ziens! */
RxSetPos(24,0); rc=RxWrScr(Centre('Opnieuw beginnen [J/N] ?',80),23)
Do Until n='J' | n='N'
  n=UsrInput('01040020'x)
  Select
    When n='J' Then kt=15
             /* Bij keuze 14 dan kt wordt 14 bij beeindgen kt-loop in
                hoofdprogramma, bij nog een spelletje wordt
                afsluiten voorkomen door kt niet meer 14 te laten zijn.
                (Waarde die hier aan kt wordt toegekend moet groter als 14
                zijn.) */
    When n='N'
      Then Do
        RxSetPos(24,0); rc=RxWrScr(Centre('Tot ziens!',80),23)
        RxSleep(2)
      End
    Otherwise Nop
  End
End

Return ''
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
Say; Say; rc=Charout(,Centre('Druk op een toets om verder te gaan ...',80))
Do Until Chars()=0; rc=RxGetKey('noecho'); End
Return ''
/* Einde Top11Zien */

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ EOF YATHZEE Versie 2.40  Hans van Kranenburg 1995-1996  IBM PC DOS 7.0 REXX  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
