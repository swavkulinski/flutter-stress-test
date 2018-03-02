# code_heavy_project_sample

This project uses generator.dart to create artificially big layout tree to see the extent to which flutter can scale.

cd to 'generator' folder and run

```
dart generator.dart 40
```

to create ~40 nested unique widgets from 40 different classes

when changing number of widgets to higher you have to use R not just hotreload r as hot reload will complain about new classes

Results show roughly the same time for R (full restart) ~650ms

test breaks + 250 unique widget classes per layout. At that point parser throws stackoverflow 

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
