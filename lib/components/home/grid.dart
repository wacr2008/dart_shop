import "package:flutter/material.dart";
import '../../views/classList.dart';
import '../../views/search.dart';

class HomeGrid extends StatefulWidget {
  @override
  _homeGridComponentState createState() => _homeGridComponentState();
}

class _homeGridComponentState extends State<HomeGrid> with AutomaticKeepAliveClientMixin {
  String search='';
  List lists=[
    {"name":"DJ器材","url":"images/dj.png","id":"9"},
    {"name":"调音台","url":"images/yinyue.png","id":"3"},
    {"name":"演出话筒","url":"images/huatong.png","id":"143"},
    {"name":"数码处理器","url":"images/yingdie.png","id":"2"},
    {"name":"周边器材","url":"images/zhoubian.png","id":"139"},
    {"name":"专业功放","url":"images/gongfang.png","id":"142"},
    {"name":"专业音响","url":"images/yinxiang.png","id":"10"},
    {"name":"家庭影院","url":"images/yingyuan.png","id":"13"},
  ];

  @override
  bool get wantKeepAlive =>true;//开启页面切换不重新加载

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(width: MediaQuery.of(context).size.width,height:20.0,color: Colors.white,),
                Container(
                  alignment: Alignment.topLeft,
                  width:percenWidth(75),
                  height:45.0,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.black54,width: 0.5),
                    borderRadius: BorderRadius.circular((6.0)),
                  ),
                  child:TextField(
                    keyboardType: TextInputType.text,
                    onSubmitted: (res){
                      if(res==""){
                        return false;
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return SearchPage(text:res);
                      }));
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(width: MediaQuery.of(context).size.width,height:10.0,color: Colors.white,),

                Container(
                  width:percenWidth(85),
                  child:GridView.count(
                    crossAxisCount: 4,
                    controller: new ScrollController(keepScrollOffset: false),//去掉回弹水波纹效果
                    childAspectRatio: 0.95,//这个主要控制高度显示
                    shrinkWrap: true, //这个不加会一直报错
                    children: lists.map((item)=> GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return  ClassPage(id:item["id"]);
                          }));

                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(item["url"]),
                            Container(width: MediaQuery.of(context).size.width,height:5.0,color: Colors.white,),
                            Text(item["name"])
                          ],
                        ),
                      )
                    ).toList(),
                  )
                )
              ],
            )
          ],
        ),
    );
  }
}
