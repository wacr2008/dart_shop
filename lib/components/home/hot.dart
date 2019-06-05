import "package:flutter/material.dart";
import "package:rxdart/rxdart.dart";
import "../../views/details.dart";
import "../../lib/request.dart";
class HomeHot extends StatefulWidget {
  @override
  __HomeHotState createState() => __HomeHotState();
}

class __HomeHotState extends State<HomeHot> with AutomaticKeepAliveClientMixin {
  List hotList=[];
  final PublishSubject Observable = new PublishSubject();

  @override
  bool get wantKeepAlive =>true;//开启页面切换不重新加载

  @override
  void initState() {
    Observable.listen(_objserableController);
    Observable.add({"type":"fetch"});
    super.initState();
  }

  void _objserableController(item) async {
    switch(item["type"]){
      case "fetch":
        Request.post("/Home/Index/HotComment",params:{"p":"14"}).then((list){
          setState(() {
            hotList=list;
          });
        });
        break;
    }
  }

  @override
  void dispose(){
    Observable.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }
    return Container(
        width:MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left:0,top:15.0,right:0,bottom: 0),
        alignment: Alignment.center,
        child:Container(
          alignment: Alignment.topLeft,
          width:percenWidth(80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("热门推荐",style:TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFb50900)
              )),
              Container(
                padding: EdgeInsets.only(left:0,top:15.0,right:0,bottom: 10.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  controller: new ScrollController(keepScrollOffset: false),//去掉回弹水波纹效果
                  childAspectRatio: 0.75,//这个主要控制高度显示
                  shrinkWrap: true, //这个不加会一直报错
                  children:hotList.map((item)=> Container(
                    padding: EdgeInsets.all(5.0),
                    decoration:BoxDecoration(
                        border:Border.all(color:Colors.black38)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network("http://yehui188.com"+item["original_img"],height:115.0),
                        Container(width:percenWidth(80),height:5.0,color:Colors.white),
                        Text(item["goods_name"],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                        TextStyle(
                            fontSize: 16.0,
                            color:Color(0xFF00a0e9)
                        )
                          ,),
                        FlatButton(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ) ,
                          color: Color(0xFF00a0e9),
                          textColor: Colors.white,
                          child: new Text('立即询问'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return DetailsPage(id: item["goods_id"]);
                            }));
                          },
                        )
                      ],
                    ),
                  )).toList()
                ),
              )
            ],
          ),
        )
    );
  }
}
