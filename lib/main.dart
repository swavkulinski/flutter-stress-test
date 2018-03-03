import 'package:flutter/material.dart';
import 'router.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Router class is generated use 
    // dart generator.dart 5 10 in /generator package
    // to generate 10 package s with 5 nested widget classes each

    // IMPORTANT: Router only adds to navigation stack (there is no pop to begin anywhere)
    // you may cause stack overflow in your app if you navigate far enough (haven't tested it yet)
    return new Router();
  }
}
