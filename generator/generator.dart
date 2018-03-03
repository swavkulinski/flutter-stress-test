import 'dart:io';


main(List<String> args) async {
  new Generator(int.parse(args.first),int.parse(args[1])).run();
}

class Generator {

  int count;
  int packageCount;
  Generator(this.count,this.packageCount);

  static const  PATH = 'lib';
  static const FILENAME_TEMPLATE = 'generated_widget';
  static const ROUTER_FILENAME = 'router.dart';
  static const CLASS_NAME_TEMPLATE = 'GeneratedWidget';
  static const PACKAGE_TEMPLATE = 'package_';
  static const PACKAGE_CLASS_PREFIX = "Package";

  static const IMPORT =  'import \'package:flutter/material.dart\';';

  static const WIDGET_TEMPLATE = '''
  class __CLASS_NAME__ extends StatelessWidget {
  
  final Widget child;

  __CLASS_NAME__({this.child});

  Widget build(BuildContext context) {
    return new Center(
      child: new DecoratedBox(
        decoration: new BoxDecoration(border: new Border(
          top: const BorderSide(color: Colors.blue,width: 0.5,style: BorderStyle.solid),
           bottom: const BorderSide(color: Colors.blue,width: 0.5,style: BorderStyle.solid),
           left: const BorderSide(color: Colors.blue,width: 0.5,style: BorderStyle.solid),
           right: const BorderSide(color: Colors.blue,width: 0.5,style: BorderStyle.solid),
          )),
          child: new Padding( 
        padding: new EdgeInsets.all(1.5),
        child: child,
       )
      ) 
    );
  }
}

''';


static const ROUTER_WIDGET = '''
class Router extends StatelessWidget {

  @override build(BuildContext context) {

  return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes : {
        __ROUTES__
      },
    );
  }
}
''';

  static const MAIN_LAYOUT = '''
  
  class __PACKAGE__MainLayout extends StatelessWidget {
    
    final VoidCallback onTapHandler;

    __PACKAGE__MainLayout({this.onTapHandler});

    @override
    Widget build(BuildContext context) {
      return new Material( child: __GENERATED_WIDGET__,);
    }
  }


''';

static const NEW_WIDGET = "new __CLASS_NAME__ (\nchild: __CHILD__,)";

static const ROUTE_TEMPLATE = "__PATH__ : (context) => __WIDGET__";


 run() async {
   var currentDirectory = Directory.current.path;

  var routerFile = await new File('$currentDirectory/../$PATH/$ROUTER_FILENAME').create(recursive: true);
  routerFile.writeAsString(_routerContent(packageCount));

   for(var packageIndex = 0; packageIndex < packageCount ; packageIndex++) {
      var generatedWidgetsFile = await new File('$currentDirectory/../$PATH/$PACKAGE_TEMPLATE$packageIndex/$FILENAME_TEMPLATE.dart').create(recursive: true);
      generatedWidgetsFile.writeAsString(_generatedLayout(count,packageIndex));
   }
  }

  String _routerContent(int packageCount) {
    var result = IMPORT;
    result += '\n';
    for(int index = 0; index < packageCount; index++) {
      result += "import '$PACKAGE_TEMPLATE${index}/generated_widget.dart';";
      result += "\n";
    }
    
    var routes = "";
    for(int index = 0; index < packageCount; index++) {
      routes += ROUTE_TEMPLATE.replaceAll("__PATH__",_getRouteForPackage(index)).replaceAll("__WIDGET__","new Package${index}MainLayout(onTapHandler:()=>Navigator.of(context).pushNamed(${_getRouteToForPackage(index, packageCount)})),");
      routes += '\n';
    }    
    result += ROUTER_WIDGET.replaceAll('__ROUTES__', routes);
    return result;
  }

  String _getRouteToForPackage(int package, int packageCount) {
      if(package < packageCount -1) {
        return "\'/route_${(package+1)}\'";
      } 
      return "\'/\'";

  }

  String _getRouteForPackage(int package) {
    return package == 0 ? "'/'" : "'/route_$package'";
  }

  String _generatedLayout (int max, int packageIndex) {
    var result = "$IMPORT\n";

    result += _mainLayout(max,'test of package $packageIndex  with $max items', packageIndex);

    result += '\n';

    result += _generatedWidgetClasses(max,packageIndex);

    return result;
  }

  String _mainLayout(int max, String text, int packageIndex) {

    var inner = NEW_WIDGET.replaceAll('__CLASS_NAME__','$PACKAGE_CLASS_PREFIX${packageIndex}GeneratedWidget0').replaceAll('__CHILD__', 'new GestureDetector(child: new Text(\'$text\',style: Theme.of(context).textTheme.body1,),onTap: onTapHandler)');
   
    for(var i = 0; i < max ; i++) {
         inner = NEW_WIDGET.replaceAll("__CLASS_NAME__", _className(i,packageIndex)).replaceAll("__CHILD__", '$inner\n');
    }

    inner = MAIN_LAYOUT.replaceAll("__GENERATED_WIDGET__", inner).replaceAll('__PACKAGE__', '$PACKAGE_CLASS_PREFIX$packageIndex');
    return inner;

  }

  String _generatedWidgetClasses(int max, int packageIndex) {
      var result = '\n';

      for(var i = 0; i < max; i++) {
          result += WIDGET_TEMPLATE.replaceAll("__CLASS_NAME__", "${_className(i,packageIndex)}");
          result += "\n";
      }
      return result;
  } 

  String _className(int i,int packageIndex) {
    return "$PACKAGE_CLASS_PREFIX$packageIndex$CLASS_NAME_TEMPLATE$i";
  }

}