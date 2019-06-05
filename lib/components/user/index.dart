import 'package:flutter/material.dart';
import "./list.dart";
import '../../views/user/collection.dart';
import '../../views/user/address.dart';
import '../../views/user/allorders.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserCenter extends StatefulWidget {
  Function logout;
  UserCenter({this.logout});

  @override
  __UserCenterState createState() => __UserCenterState();
}

class __UserCenterState extends State<UserCenter> {
  String nickname="";
  @override
  void initState() {
    super.initState();
    _getUserCenter();
  }

  _getUserCenter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nickname=pref.getString("nickname");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFefeff4),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0,top:15.0,right:0,bottom: 0),
            alignment: Alignment.center,
            width:MediaQuery.of(context).size.width,
            height:180.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/userbg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                ClipOval(
                  child:Image.asset("images/head_logo.png",width: 100,) ,
                ),
                Container(width: MediaQuery.of(context).size.width,height:10.0,),
                Text("$nickname",style:TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ))
              ],
            ),
          ),
          Container(width: MediaQuery.of(context).size.width,height:10.0,color: Color(0xFFefeff4),),
          UserList(icon: Icons.insert_drive_file,height:46,text:"全部订单",color:Color(0xFF0662f1),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return AllOrderPage();
            }));
          },),
          UserList(icon: Icons.credit_card,height:45,text:"我的优惠券",color:Color(0xFFf1a006)),
          UserList(icon: Icons.insert_drive_file,height:45,text:"我的评价",color:Color(0xFF48bfbf)),
          UserList(icon: Icons.favorite,height:45,text:"我的收藏",color:Color(0xFFff0016),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return CollectionPage();
            }));
          },),
          Container(width: MediaQuery.of(context).size.width,height:10.0,color: Color(0xFFefeff4),),
          UserList(icon: Icons.location_on,height:46,text:"地址管理",color:Color(0xFFe265b5),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return AddressPage();
            }));
          },),
          UserList(icon: Icons.card_membership,height:45,text:"个人信息",color:Color(0xFF2fafc3)),
          Container(width: MediaQuery.of(context).size.width,height:10.0,color: Color(0xFFefeff4),),
          UserList(icon: Icons.autorenew,height:46,text:"注销登录",color:Color(0xFF10e20e),onTap:widget.logout,)
        ],
      ),
    );
  }
}
