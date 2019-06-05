import "package:flutter/material.dart";
import "../components/home/swiper.dart";
import "../components/home/grid.dart";
import "../components/home/rush.dart";
import "../components/home/hot.dart";
import "../components/home/love.dart";
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HomeWidget();
  }
}

class _HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<_HomeWidget> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive =>true;//开启页面切换不重新加载

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.home), onPressed: (){

        }),
        title:Text("小谢商城"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: (){

          })
        ],
      ),
      body:SingleChildScrollView(
        child:Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HomeSwiper(),//轮播图
              Container(width: MediaQuery.of(context).size.width,height:10.0,color: Color(0xFFefeff4),),//灰色上边距
              HomeGrid(),//搜索和九宫格组件
              Container(width: MediaQuery.of(context).size.width,height:20.0,color: Colors.white),//
              HomeRush(),// 边距
              HomeHot(),//热门推荐
              HomeLove()
            ],
          ),
        ),
      )
    );
  }
}

