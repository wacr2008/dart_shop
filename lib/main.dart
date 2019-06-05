import "package:flutter/material.dart";
import "./views/index.dart";
void main() => runApp(App());
class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:IndexPage() ,
      theme: ThemeData(
        primaryColor: Color(0xFFe71f19),
      ),
    );
  }
}


