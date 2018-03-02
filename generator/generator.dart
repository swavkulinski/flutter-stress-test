import 'dart:io';


main(List<String> args) async {
  new Generator(int.parse(args.first)).run();
}

class Generator {

  int count;
  Generator(this.count);

  static const  PATH = 'lib';
  static const FILENAME_TEMPLATE = 'generated_widget';
  static const CLASS_NAME_TEMPLATE = 'GeneratedWidget';

  static const IMPORT =  'import \'package:flutter/material.dart\';';

  static const WIDGET_TEMPLATE = '''
  class __CLASS_NAME__ extends StatelessWidget {
  
  final Widget child;

  __CLASS_NAME__({this.child});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding( 
        padding: new EdgeInsets.all(2.0),
        child: child,
       )
    );
  }
}



  ''';

  static const MAIN_LAYOUT = '''
  
  class MainLayout extends StatelessWidget {
    

    @override
    Widget build(BuildContext context) {
      return __GENERATED_WIDGET__;
    }
  }


''';

static const NEW_WIDGET = "new __CLASS_NAME__ (\nchild: __CHILD__,\n)";

  


 run() async {
   var currentDirectory = Directory.current.path;
   var file = await new File('$currentDirectory/../$PATH/$FILENAME_TEMPLATE.dart').create();
   file.writeAsString(_genertedLayout(count));
  }

  

  String _genertedLayout (int max) {
    var result = "$IMPORT\n";

    result += _mainLayout(max,'test of $max');

    result += '\n';

    result += _generatedWidgetClasses(max);

    return result;
  }

  String _mainLayout(int max, String text) {

    var inner = NEW_WIDGET.replaceAll('__CLASS_NAME__','GeneratedWidget0').replaceAll('__CHILD__', 'new Text("$text")\n');
   
    for(var i = 0; i < max ; i++) {
         inner = NEW_WIDGET.replaceAll("__CLASS_NAME__", _className(i)).replaceAll("__CHILD__", '$inner\n');
    }

    inner = MAIN_LAYOUT.replaceAll("__GENERATED_WIDGET__", inner);
    return inner;

  }

  String _generatedWidgetClasses(int max) {
      var result = '\n';

      for(var i = 0; i < max; i++) {
          result += WIDGET_TEMPLATE.replaceAll("__CLASS_NAME__", "${_className(i)}");
          result += "\n";
      }
      return result;
  } 

  String _className(int i) {
    return "$CLASS_NAME_TEMPLATE$i";
  }

}