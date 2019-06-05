import 'package:flutter/material.dart';
import "../../lib/request.dart";
import 'package:toast/toast.dart';
class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List CollectionList=[];

  @override
  void initState() {
    super.initState();
    _getlist();
  }

  _getlist(){
    Request.post("/Api/User/getGoodsCollect").then((list){
      setState(() {
        CollectionList=list;
      });
    });
  }

  _cancelCollection(id){
    Request.post("/Api/User/cancelCollect",params: {"collect_id":id.toString()}).then((list){
      Toast.show("取消收藏成功",context,gravity: Toast.CENTER);
       _getlist();
    }).catchError((err){
      Toast.show(err,context,gravity: Toast.CENTER);
    });
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
        title:Text("收藏中心")
      ),
      body: CollectionList.length==0?Container(
        alignment: Alignment.center,
        height:45.0,width: MediaQuery.of(context).size.width,
        child: Text("暂无收藏"),
      ):SingleChildScrollView(
        child: Container(
            width:MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left:0,top:0,right:0,bottom: 0),
            alignment: Alignment.center,
            child:Container(
              alignment: Alignment.topLeft,
              width:percenWidth(90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left:0,top:15.0,right:0,bottom: 10.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        controller: new ScrollController(keepScrollOffset: false),//去掉回弹水波纹效果
                        childAspectRatio: 0.85,//这个主要控制高度显示
                        shrinkWrap: true, //这个不加会一直报错
                        children:CollectionList.map((item)=> Container(
                          padding: EdgeInsets.all(5.0),
                          decoration:BoxDecoration(
                              border:Border.all(color:Colors.black38)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.network("http://yehui188.com"+item["original_img"],height:105.0),
                              Container(width:percenWidth(80),height:5.0,color:Colors.white),
                              Text(item["goods_name"],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                              TextStyle(
                                  fontSize: 16.0,
                                  color:Color(0xFFE71F19)
                              )
                                ,),
                              FlatButton(
                                shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ) ,
                                color: Color(0xFFE71F19),
                                textColor: Colors.white,
                                child: new Text('取消收藏'),
                                onPressed: () {
                                  _cancelCollection(item["collect_id"]);
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
        ),
      )
    );
  }
}
