/* Greets the user, says the day of the week, the date and the time. */
Say
Select
  When Time('H') < 12 Then Say "Good morning!!"
  When Time('H') < 18 Then Say "Good afternoon!!"
  Otherwise Say "Good evening!!"
End
Say "Today is "Date('W')', 'Date('L')
Say "The time is: "Time()
Exit
