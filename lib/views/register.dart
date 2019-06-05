import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../lib/loading.dart';
import '../lib/request.dart';
import 'dart:async';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _phone;
  String _password;
  String _passwords;
  void _Submit(){
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      if(_password!=_passwords){
        Toast.show("两次密码不一致",context,gravity: Toast.CENTER);
      }else{
        Tips.loading(context,"注册中...");
        Request.post("/Api/User/reg",params: {
          "username":_phone,
          "password":_password,
          "password2":_password
        }).then((json){
          Navigator.pop(context);
          Toast.show("注册成功",context,gravity: Toast.CENTER);
          Timer(Duration(seconds:1),(){
            Navigator.pop(context);
          });
        }).catchError((err){
          Navigator.pop(context);
          Toast.show(err,context,gravity: Toast.CENTER);
        });
      }
    }
  }

  String _isPhone(val){
    if(val==""||val==null||val.isEmpty){
      return "手机号不能为空";
    }
    if(!new RegExp("^1[23456789]\\d{9}\$").hasMatch(val)){
      return "手机号格式不正确";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }

    return Scaffold(
      appBar: AppBar(
        title:Text("注册"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
            child: Container(
              width: percenWidth(80),
              padding: EdgeInsets.only(top:25.0),
              child: Form(
                  key: _formKey,
                  child:Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.centerRight,
                              width: 70.0,
                              child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                        color: Color(0xFFe71f19),
                                      ),
                                      text:"*",
                                      children: [
                                        new TextSpan(
                                            text: ' 手机号',
                                            style: TextStyle(
                                                color: Colors.black
                                            )
                                        ),
                                      ]
                                  )
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0),
                            padding: EdgeInsets.only(left: 10.0),
                            width: percenWidth(55),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:Colors.black38
                                    )
                                )
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: _isPhone,
                              onSaved: (item)=>this._phone=item,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            width: 70.0,
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Color(0xFFe71f19),
                                    ),
                                    text:"*",
                                    children: [
                                      new TextSpan(
                                          text: ' 密码',
                                          style: TextStyle(
                                              color: Colors.black
                                          )
                                      ),
                                    ]
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0),
                            padding: EdgeInsets.only(left: 10.0),
                            width: percenWidth(55),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:Colors.black38
                                    )
                                )
                            ),
                            child: TextFormField(
                              obscureText: true,
                              validator: (val)=>(val == null || val=="") ? "密码不能为空": null,
                              onSaved: (item)=>_password=item,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            width: 70.0,
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Color(0xFFe71f19),
                                    ),
                                    text:"*",
                                    children: [
                                      new TextSpan(
                                          text: ' 确认密码',
                                          style: TextStyle(
                                              color: Colors.black
                                          )
                                      ),
                                    ]
                                )
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0),
                            padding: EdgeInsets.only(left: 10.0),
                            width: percenWidth(55),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:Colors.black38
                                    )
                                )
                            ),
                            child: TextFormField(
                              obscureText: true,
                              validator: (val)=>(val == null || val=="") ? "密码不能为空": null,
                              onSaved: (item)=>this._passwords=item,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: _Submit,
                        child: Container(
                          width:percenWidth(60),
                          margin: EdgeInsets.only(top:45.0),
                          height:45.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFFe71f19),
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Text("注册",style: TextStyle(
                              color: Colors.white
                          ),),
                        ),
                      )
                    ],
                  )
              ),
            )
        ),
      )
    );
  }
}
