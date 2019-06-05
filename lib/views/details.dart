import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../components/details/first.dart';
import '../components/details/second.dart';
import '../components/details/third.dart';
import '../models/detail.dart';
import './index.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
class DetailsPage extends StatefulWidget {
  final int id;
  DetailsPage({Key key,this.id}):super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class Lists{
  Map list;
  Lists(this.list);
}

class _DetailsPageState extends State<DetailsPage> {
  int num=0;
  DetailsModel detailsModel=DetailsModel();
  @override
  void initState() {
    detailsModel.fetch({"type":"fetch","good_id":widget.id});
    super.initState();
    detailsModel.isLogin();
  }

  @override
  void dispose(){
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }

    return ScopedModel<DetailsModel>(
      model: detailsModel,
      child: ScopedModelDescendant<DetailsModel>(
        builder: (context,child,model){
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title:Text("商品详情"),
                bottom:TabBar(
                  indicatorColor:Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text:"基本信息"),
                    Tab(text:"商品详情"),
                    Tab(text:"(${detailsModel.goods!=null?detailsModel.goods['comment_count']:'0'})评价"),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  FirstComponent(model:model),
                  SecondComponent(model:model),
                  ThirdComponent(model:model,baseModel: detailsModel,),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                  child: Container(
                    height:50.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: percenWidth(20),
                            child: FlatButton(
                              onPressed: (){
                                //清除所有页面，跳转到首页
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_){
                                  return IndexPage();
                                }), (Route<dynamic> route) => false);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.home,color:Color(0xFF666666)),
                                  Text("主页",style: TextStyle(color: Color(0xFF666666)),)
                                ],
                              ),
                            )
                        ),
                        GestureDetector(
                          onTap: () async {
                            String url;
                            if(Platform.isAndroid){
                              url = 'mqqwpa://im/chat?chat_type=wpa&uin=18820004532';
                            }else{
                              url = 'mqq://im/chat?chat_type=wpa&uin=18820004532';
                            }
// 确认一下url是否可启动
                            if(await canLaunch(url)){
                              await launch(url); // 启动QQ
                            }else{
                              Toast.show("请确认是否安装QQ",context,gravity: Toast.CENTER);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF94469c),
                            width: percenWidth(24),
                            child: Text("最低询价",style:TextStyle(color: Colors.white,fontSize: 16.0)),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(model.login){
                              model.buyNow(context);
                            }else{
                              model.showLogin(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFFE71F19),
                            width: percenWidth(28),
                            child: Text("立即购买",style:TextStyle(color: Colors.white,fontSize: 16.0)),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                              if(model.login){
                                model.addCart(context);
                              }else {
                                model.showLogin(context);
                              }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFFff6600),
                            width: percenWidth(28),
                            child: Text("加入购物车",style:TextStyle(color: Colors.white,fontSize: 16.0)),
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );

  }
}
