/* An introduction to REXX */
SAY "Hello! I am REXX"
SAY "What is your name?"
PARSE PULL who
 IF who = " "
  THEN
  SAY "Hello stranger"
 ELSE
  SAY "hello" who
EXIT