import 'package:flutter/material.dart';

class Tips{
  static loading(context,msg,{width,height}){
    showDialog(
        context: context,
        barrierDismissible:false,
        builder: (context){
          return Center(
              child:Container(
                width:width!=null?width:100.0,
                height:height!=null?height:100.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Image.asset("images/loading.gif",width: 50,),
                    Text(msg!=null?msg:"加载中...",style: TextStyle(
                      fontSize: 14,color:Colors.black,
                      decoration: TextDecoration.none,
                    ),)
                  ],
                ),
              )
          );
        }
    );
  }
}