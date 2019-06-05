import 'package:flutter/material.dart';
import "./register.dart";
import 'dart:async';
import "dart:convert";
import '../lib/loading.dart';
import '../lib/request.dart';
import 'package:toast/toast.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _phone;
  String _password;
  @override
  void initState() {
    super.initState();
  }

  String _isPhone(val){
    if(val==""||val==null||val.isEmpty){
      return "手机号不能为空";
    }
    if(!new RegExp("^1[23456789]\\d{9}\$").hasMatch(val)){
      return "手机号格式不正确";
    }
  }

  void _onSubmit() {

    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      Tips.loading(context,"登录中...");
      Request.post("/Api/User/login",params: {
        "username":_phone,
        "password":_password,
      }).then((jsons){
        Navigator.pop(context);
        Toast.show("登录成功",context,gravity: Toast.CENTER);
        Timer(Duration(seconds:1),(){
          Navigator.pop(context,jsons);
        });
      }).catchError((err){
        Navigator.pop(context);
        Toast.show(err,context,gravity: Toast.CENTER);
      });
      //Toast.show("验证通过",context,gravity: Toast.CENTER);
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
        centerTitle: true,
        title:Text("登陆")
      ),
      body:Container(
        alignment: Alignment.center,
        child: Container(
          width: percenWidth(80),
          child: Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top:15.0),
                        height:45.0,
                        width: percenWidth(80),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: _isPhone,
                          onSaved: (val)=> this._phone = val,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:25.0),
                        height:45.0,
                        width: percenWidth(80),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                        child: TextFormField(
                          obscureText: true,
                          onSaved: (val)=> this._password = val,
                          validator: (val)=>(val == null || val.isEmpty) ? "密码不能为空": null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0,),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50.0))
                          ),
                          minWidth:percenWidth(70) ,
                          height: 45.0,
                          color: Color(0xFFe71f19),
                          child: Text("登录",style: TextStyle(
                              color: Colors.white,fontSize: 18
                          ),),
                          onPressed:_onSubmit
                      ),
                    ],
                  )
              ),
              GestureDetector(
                onTap: (){

                },
                child: GestureDetector(
                  onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return RegisterPage();
                      }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text("没有账号?速度注册"),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
