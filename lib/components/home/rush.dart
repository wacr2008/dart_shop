import "package:flutter/material.dart";
import "../../lib/request.dart";
class HomeRush extends StatefulWidget {
  @override
  __HomeRushToBuyState createState() => __HomeRushToBuyState();
}

class __HomeRushToBuyState extends State<HomeRush> with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive =>true;//开启页面切换不重新加载

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState(){
    Request.post("/api/Index/promoteList").then((list){

    });
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: percenWidth(80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/qianggou.png"),
                Text("限时抢购")
              ],
            ),
          ),
          Container(width:percenWidth(80),height:20.0,color: Colors.white),
          Container(
            width: percenWidth(80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: (){

                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset("images/jiexiao.png",width:percenWidth(25),),
                      Container(width:percenWidth(25),height:10.0,color: Colors.white),
                      Text("￥0",style:TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFb50900)
                      )),
                      Text("￥0",style:TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.dashed
                      ))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset("images/jiexiao.png",width:percenWidth(25),),
                      Container(width:percenWidth(25),height:10.0,color: Colors.white),
                      Text("￥0",style:TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFb50900)
                      )),
                      Text("￥0",style:TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.dashed
                      ))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset("images/jiexiao.png",width:percenWidth(25),),
                      Container(width:percenWidth(25),height:10.0,color: Colors.white),
                      Text("￥0",style:TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFFb50900),
                      )),
                      Text("￥0",style:TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.dashed
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(width:percenWidth(80),height:20.0,color: Colors.white),
          Container(width: MediaQuery.of(context).size.width,height:10.0,color: Color(0xFFefeff4),),//灰色上边距
        ],
      ),
    );
  }
}
