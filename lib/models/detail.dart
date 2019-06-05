import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import '../lib/request.dart';
import '../views/login.dart';
import '../views/confirmOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class DetailsModel extends Model{
  Map _goods; //商品详情信息
  int _num=1;
  bool _login=false;
  List _goodsImage=[];  //商品展示图片
  List _goodsComment=[]; //商品评价列表
  get goods => _goods;
  get goodsImage => _goodsImage;
  get goodsComment => _goodsComment;
  get login => _login;
  get num=>_num;

  void addCart(context){
    Request.post("/index.php?m=api&c=Cart&a=addCart",params:{
      "goods_id":_goods["goods_id"],
      "goods_num":_num
    }).then((result){
      Toast.show("加入购物车成功",context,gravity: Toast.CENTER);
    });
  }

  void buyNow(context){//立即购买
    Request.post("/Api/Cart/buy",params:{
      "goods_id":_goods["goods_id"],
      "goods_num":_num
    }).then((result){
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return ConfirmOrderPage();
        }));
    }).catchError((msg){
      Toast.show(msg,context,gravity: Toast.CENTER);
    });
  }

  //点击减少数量
  redcus(TextEditingController controllers){
    if(_num>1){
      _num=_num-1;
      controllers.text=_num.toString();
      notifyListeners();
    }
  }

  //输入框输入数量
  void InputChanged(String num,TextEditingController controllers){
    _num=int.parse(num);
    controllers.text=num;
    notifyListeners();
  }

  //点击增加数量
  void add(TextEditingController controllers){
    _num=_num+1;
    controllers.text=_num.toString();
    notifyListeners();
  }

  void fetch(Map obj) async {
    switch(obj["type"]){
      case "fetch":
        Request.post("/api/goods/goodsInfo",params: {"id":obj["good_id"]}).then((result){
          _goods=result["goods"];
          _goodsImage=result["gallery"];
          notifyListeners();
        });
      break;
      case "comment":
        Request.post("/Api/Goods/getGoodsComment",params: obj["params"]).then((result){
          List list=[];
          for(int i=0;i<result.length;i++){
            result[i]["timers"]=Request.timeFormat(DateTime.fromMillisecondsSinceEpoch( result[i]["add_time"]*1000));
            list.add(result[i]);
          }
          _goodsComment=list;
          notifyListeners();
        });
        break;
    }
  }

  void Collection(context,goods_id){
    Request.post("/api/goods/collectgoods",params: {"goods_id":goods_id}).then((result){
      print(result);
      Toast.show("收藏成功",context,gravity: Toast.CENTER);
    });
  }

  void isLogin() async{ //判断是否登录
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getBool("login")!=null){
      _login=true;
      notifyListeners();
    }
  }
  void _setUser(Map map) async {//设置登录后的数据，储存起来
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("user_id",map["user_id"]);
    pref.setString("level_name", map["level_name"]);
    pref.setString("level", map["level"]);
    pref.setString("mobile", map["mobile"]);
    pref.setString("token", map["token"]);
    pref.setString("distribut_money", map["distribut_money"]);
    pref.setString("discount", map["discount"]);
    pref.setString("nickname", map["nickname"]);
    pref.setString("user_money", map["user_money"]);
    pref.setString("total_amount", map["total_amount"]);
    pref.setBool("login", true);
    _login=true;
    notifyListeners();
  }

  void showLogin(context){ //提示是否去登录
    showDialog(
        context: context,
        builder: (_) =>AlertDialog(
            title: Text("您还未登陆"),
            content: Text("是否去登陆?"),
            actions:<Widget>[
              FlatButton(child:Text("不去"), onPressed: (){
                Navigator.of(context).pop();
              },),
              FlatButton(child:Text("去登陆"), onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return LoginPage();
                })).then((item){
                  if(item==null){
                    return false;
                  }
                 _setUser(item);
                });
              },)
            ]

        ));
  }

  DetailsModel of(context) => ScopedModel.of<DetailsModel>(context);
}