/* Op welke dag ben ik geboren? */

dag.0='vrijdag'
dag.1='zaterdag'
dag.2='zondag'
dag.3='maandag'
dag.4='dinsdag'
dag.5='woensdag'
dag.6='donderdag'
Do Forever
  Say; rc=CharOut(,'DD-MM-YYYY : '); Pull datum
  Parse Var datum dag '-' maand  '-' jaar
  maand=maand-2
  If maand<=0 Then Do; maand=maand+12; jaar=jaar-1; End
  resultaat=(jaar+dag+((maand*13-1)%5)+(jaar%4)-34)//7
  Say; Say datum 'is een 'dag.resultaat
End
