import "package:flutter/material.dart";
import "../components/user/index.dart";
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserWidget();
  }
}

class UserWidget extends StatefulWidget {
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool login=false;

  @override
  void initState() {
    _getLogin();
    super.initState();
  }

  _getLogin() async {//获取储存的数据，判断是否登录
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getBool("login")!=null){
      setState(() {
        login=true;
      });
    }
  }
  _setUser(Map map) async {//设置登录后的数据，储存起来
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("user_id",map["user_id"]);
    pref.setString("level_name", map["level_name"]);
    pref.setInt("level", map["level"]);
    pref.setString("mobile", map["mobile"]);
    pref.setString("token", map["token"]);
    pref.setString("distribut_money", map["distribut_money"]);
    pref.setString("discount", map["discount"]);
    pref.setString("nickname", map["nickname"]);
    pref.setString("user_money", map["user_money"]);
    pref.setString("total_amount", map["total_amount"]);
    pref.setBool("login", true);
    setState(() {
      login=true;
    });
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (_) =>AlertDialog(
            title: Text("温馨提示"),
            content: Text("是否退出登录?"),
            actions:<Widget>[
              FlatButton(child:Text("否"), onPressed: (){
                Navigator.of(context).pop();
              },),
              FlatButton(child:Text("退出"), onPressed: (){
                pref.remove("login");
                setState(() {
                  login=false;
                });
                Navigator.of(context).pop();
              },)
            ]
        ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("个人中心")
      ),
      body: login?UserCenter(logout:logout):Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("您还未登录"),
            SizedBox(height: 10,),
            MaterialButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return LoginPage();
                })).then((item){
                  if(item==null){
                    return false;
                  }
                  _setUser(item);
                });
              },
              color: Color(0xFFe71f19),
              textColor: Colors.white,
              child: Text("去登陆"),
            )
          ],
        ),
      )
    );
  }
}

