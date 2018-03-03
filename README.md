# code_heavy_project_sample

This started as a question asked during one of Flutter meetups.


*How hot reload scales on large project?*

This project uses generator.dart to create artificially big layout tree to see the extent to which flutter can scale.

go to 'generator' folder and run

```
dart generator.dart 40 5
```

to create **5 packages** of **~40** nested unique widgets from 40 different classes

go to main project and run it

```
flutter run
```

when changing number of widgets to higher you have to use R not just hotreload r as hot reload will complain about new classes

App draws thin blue box of each widget displayed. Text in the middle acts as navigation forward.

_NOTE 1_

App doesn't have navigation back, tapping text in the middle will push new screen each time. It may cause stack overflow on device as it is looped.

_NOTE 2_

When you start the app with small package number and small widget count Flutter may complain about hot reload when you increase numbers. Good test to see how reload is to:

1) Generate enough packages e.g. 250 with 80 Widgets
2) Change generator to modify one of values e.g. padding to 1.7
3) Generate packages again 
4) Attempt hot reload by pressing 'r'

Results
===

Results show roughly the same time for R (full restart) ~650ms

I couldn't get anything longer until I've started building apps with around 100 packages each containing 80 uniquie widgets

At 250 packages and 80 nested Widgets classes per package hot reload jumped to only 1300ms. Pretty impressive.
