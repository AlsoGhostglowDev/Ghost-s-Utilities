## GhostUtil C / FFI Context List

###  Message Forms

- `cpp.OK`	= The default, displays only an "Ok" button (returns '1' when clicked).
- `cpp.ABORTRETRYIGNORE` = Displays a "Abort", "Retry", and "Ignore" button ("abort" returns '3', "retry" returns '4', "ignore" returns '5').
- `cpp.CANCELTRYCONTINUE` = Displays a "Cancel", "Try Again", and "Continue" button ("cancel" returns '2', "try" returns '10', "continue" returns '11').
- `cpp.HELP` = Displays only an "Help" button (returns nothing, will only act as if you pressed F1, where it sends you to a help page).
- `cpp.OKCANCEL` = Displays an "Ok" button along with a "Cancel" button ("ok" returns '1', "cancel" returns '2').
- `cpp.RETRYCANCEL` = Displays a "Retry" and "Cancel" button ("retry" returns '4', "cancel" returns '2').
- `cpp.YESNO` = Displays a "Yes" and "No" button, one of the most useful ("yes" returns '6', "no" returns "7").
- `cpp.YESNOCANCEL` = Displays a "Yes", "No", and "Cancel" button ("yes" returns '6', "no" returns "7", "cancel" returns '2').

### Message Icons

- `cpp.INFORMATION` = Most common and the default, displays a circle with an "i" symbol.
- `cpp.WARNING` = Displays a yellow triangle with a "!" symbol.
- `cpp.QUESTION` = Similar to "information", only it displays a "?" in the circle.
- `cpp.ERROR` = Shows a red circle with an "X" in the middle.

### Message Answers (return values)

- `cpp.messageAnswer.ABORT` = Abort button pressed (3).
- `cpp.messageAnswer.CANCEL` = Cancel button pressed (2).
- `cpp.messageAnswer.CONTINUE` = Continue button pressed (11).
- `cpp.messageAnswer.IGNORE` = Ignore button pressed (5).
- `cpp.messageAnswer.OK` = OK button pressed (1).
- `cpp.messageAnswer.YES` = Yes button pressed (6).
- `cpp.messageAnswer.NO` = No button pressed (7).
- `cpp.messageAnswer.RETRY` = Retry button pressed (4).
- `cpp.messageAnswer.TRYAGAIN` = Try Again button pressed (10).