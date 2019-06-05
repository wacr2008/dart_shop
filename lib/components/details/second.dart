import 'package:flutter/material.dart';
import "package:flutter_html/flutter_html.dart";
class SecondComponent extends StatefulWidget {
  var model;
  SecondComponent({Key key,this.model}):super(key: key);
  @override
  _SecondComponentState createState() => _SecondComponentState();
}

class _SecondComponentState extends State<SecondComponent> {
  double width;

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Container(
          width: percenWidth(90),
          child: Html(
            data:widget.model.goods!=null?widget.model.goods["goods_content"]:"",
          ),
        ),
      ),
    );
  }
}
