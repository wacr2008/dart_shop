import 'package:flutter/material.dart';


class ThirdComponent extends StatefulWidget {
  var model;
  var baseModel;
  ThirdComponent({Key key,this.model,this.baseModel}):super(key: key);

  @override
  _ThirdComponentState createState() => _ThirdComponentState();
}

class _ThirdComponentState extends State<ThirdComponent> {
  double width;
  double height;
  List<Map> list=[
    {"name":"全部","index":1},
    {"name":"好评","index":2},
    {"name":"中评","index":3},
    {"name":"差评","index":4}
  ];
  int _index=1;

  @override
  void initState() {
    widget.baseModel.fetch({"type":"comment","params":{
      "goods_id": widget.model.goods["goods_id"],
      "commentType": 1
    }});

    super.initState();
  }

  List<Widget> _reply(index){
    if(widget.model.goodsComment[index]["reply"]!=null){
      return [
        RichText(
            textAlign: TextAlign.left,
            text: TextSpan(

                style: TextStyle(

                    color:Colors.black
                ),
                text:"评论: ",
                children: <TextSpan>[
                  TextSpan(
                      text:widget.model.goodsComment[index]["content"]
                  )
                ]
            )),
        RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
                style: TextStyle(
                    color:Colors.black
                ),
                text:"店主回复: ",
                children: <TextSpan>[
                  TextSpan(
                      text:widget.model.goodsComment[index]["reply"]["content"]
                  )
                ]
            ))
      ];
    }else{
      return [
        RichText(
            textAlign: TextAlign.left,
            text: TextSpan(

                style: TextStyle(

                    color:Colors.black
                ),
                text:"评论: ",
                children: <TextSpan>[
                  TextSpan(
                      text:widget.model.goodsComment[index]["content"]
                  )
                ]
            )),
      ];
    }
  }

  Widget _listView(){
    if(widget.model.goodsComment.length>0){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.model.goodsComment.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFc8c7cc)
                            )
                        )
                    ),
                    padding:EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: ClipOval(
                                child: Image.network("http://yehui188.com"+widget.model.goodsComment[index]["head_pic"],width: 40,height:40.0,fit: BoxFit.cover,),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(widget.model.goodsComment[index]["username"]),
                                Text("发表于: ${widget.model.goodsComment[index]["timers"]}")
                              ],
                            ),
                          ],
                        ),
                        Text(['好评','中评','差评'][widget.model.goodsComment[index]["comment_type"]],style:TextStyle(
                          color: [Colors.green,Color(0xFFff6600),Colors.red][widget.model.goodsComment[index]["comment_type"]]
                        ))
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10.0,top:5.0,right:10.0,bottom:5.0),
                      alignment: Alignment.centerLeft,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _reply(index),
                      )
                  )
                ],
              ),
            );
          });
    }else{
      return Container(
        height: 70.0,
        alignment: Alignment.center,
        child: Text("暂无评论"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }
    return SingleChildScrollView(
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              width:width,
              color: Colors.white,
              height:45.0,
              child: Row(
                  children: list.map((val)=>
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _index=val["index"];
                            widget.baseModel.fetch({"type":"comment","params":{
                              "goods_id": widget.model.goods["goods_id"],
                              "commentType": val["index"]
                            }});
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: percenWidth(25),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color:val["index"]==_index?Color(0xFFE71F19):Colors.white)
                                )
                            ),
                            child:Text(val["name"],style: TextStyle(color: val["index"]==_index?Color(0xFFE71F19):Colors.black)                 ,)),
                      )
                  ).toList()
              ),
            ),

            //评论列表开始
            _listView()
          ],
        )
      ),
    );
  }
}
