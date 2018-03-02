# code_heavy_project_sample

This started as a question asked during one of Flutter meetups.


*How hot reload scales on large project?*

This project uses generator.dart to create artificially big layout tree to see the extent to which flutter can scale.

go to 'generator' folder and run

```
dart generator.dart 40
```

to create ~40 nested unique widgets from 40 different classes

go to main project and run it

```
flutter run
```

when changing number of widgets to higher you have to use R not just hotreload r as hot reload will complain about new classes

Results
===

Results show roughly the same time for R (full restart) ~650ms

test breaks + 250 unique nested widgets per layout. At that point parser throws stackoverflow 

Next steps
===

I will try to generate multiple views but keep the nesting below 250 levels and try to register any degradation in compile time