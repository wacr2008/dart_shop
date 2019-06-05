import 'package:flutter/material.dart';
import '../../lib/request.dart';
import 'package:toast/toast.dart';
class AllOrderPage extends StatefulWidget {
  @override
  _AllOrderPageState createState() => _AllOrderPageState();
}

class _AllOrderPageState extends State<AllOrderPage> {
  List<Map> tabList=[
    {"name":"全部","value":"","index":0},
    {"name":"待付款","value":"WAITPAY","index":1},
    {"name":"待发货","value":"WAITSEND","index":2},
    {"name":"待收货","value":"WAITRECEIVE","index":3},
    {"name":"待评价","value":"WAITCCOMMENT","index":4},
  ];
  int _index=0;
  int _page=1;
  List list=[];
  ScrollController _controller=ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _getList();
  }

  _getList(){
    Request.post("/Api/User/getOrderList",params: {
      "page":1,
      "rows":30,
      "type":tabList[_index]["value"]
    }).then((data){
      setState(() {
        list=data;
      });
    });
  }

  List<Widget> _setList(item,double width){
    List<Widget> li=[];
    item["goods_list"].forEach((row){
      li.add(
          Container(
            height: 80.0,
            padding: EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:BorderSide(
                        color:Color(0xFFc8c7cc),width: 0.5
                    )
                )
            ),
            child: Row(
              children: <Widget>[
                Image.network("http://www.yehui188.com"+row["original_img"],height: 60.0,),
                SizedBox(width:10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:10.0),
                      width:width,
                      height:40.0,
                      child: Text(row["goods_name"],maxLines: 2,style: TextStyle(
                          fontSize: 14.0
                      ),overflow: TextOverflow.ellipsis,),
                    ),
                    RichText(
                        text: TextSpan(
                            text:"￥${row["goods_price"]}",
                            style: TextStyle(
                                color: Color(0xFFE71F19),
                                fontSize: 16.0
                            ),
                            children: [
                              TextSpan(
                                  text:" x${row["goods_num"]}",
                                  style:TextStyle(
                                      color:Color(0xFF8f8f94)
                                  )
                              )
                            ]
                        )
                    )
                  ],
                )
              ],
            ),
          )
      );
    });
    return li;
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
        title:Text("全部订单")
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
          child:Column(
            children: <Widget>[
              Container(
                width: width,
                height:45.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:Color(0xFFc8c7cc),width:0.5
                        )
                    )
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: tabList.map((item)=>
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _index=item["index"];
                            _getList();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:item["index"]==_index?Color(0xFFe71f19):Colors.white,
                                      width:1
                                  )
                              )
                          ),
                          width:percenWidth(20),
                          alignment: Alignment.center,
                          child: Text(item["name"]),
                        ),
                      )
                  ).toList(),
                ),
              ),
              list.length==0
                  ?
                Container(
                  width: width,height:60.0,alignment: Alignment.center,
                  child: Text("暂无订单"),
                )
                :
              ListView(
                physics:ScrollPhysics(),
                shrinkWrap:true,
                children: list.map((item)=>
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: width,
                            height: 45.0,
                            padding: EdgeInsets.only(left: 15.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:BorderSide(
                                        color:Color(0xFFc8c7cc),width: 0.5
                                    )
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.home),
                                SizedBox(width:10.0),
                                Text("订单号:${item["order_sn"]}")
                              ],
                            ),
                          ),
                          Column(
                            children:_setList(item,percenWidth(72))
                          ),
                          Container(
                            height:40.0,alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:BorderSide(
                                        color:Color(0xFFc8c7cc),width: 0.5
                                    )
                                )
                            ),
                            child: RichText(
                                text:TextSpan(
                                    text:"共${item["goods_list"].length}件商品",
                                    style:TextStyle(
                                      color:Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:" ￥${item["total_amount"]}",
                                          style:TextStyle(
                                              color:  Color(0xFFE71F19),
                                              fontSize: 18.0
                                          )
                                      )
                                    ]
                                )
                            ),
                          ),
                          Container(
                            width: width,height:60.0,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                item["pay_status"]!=1&&item["order_status"]!=3
                                  ?
                                Container(
                                  margin: EdgeInsets.only(right:10.0),
                                  height:40.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      border: Border.all(
                                          color:Color(0xFFcccccc)
                                      )
                                  ),
                                  child: FlatButton(
                                      onPressed:(){
                                        Request.post("/Api/User/cancelOrder",params:{
                                          "order_id":item["order_id"]
                                        }).then((item){
                                          Toast.show("取消成功",context,gravity: Toast.CENTER);
                                          _getList();
                                        });
                                      },
                                      child: Text("取消订单")
                                  ),
                                )
                                  :
                                    Text(""),
                                Container(
                                  height:40.0,
                                  margin: EdgeInsets.only(right:10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      border: Border.all(
                                          color:Color(0xFFcccccc)
                                      )
                                  ),
                                  child: FlatButton(
                                      onPressed:(){

                                      },
                                      child: Text("订单详情")
                                  ),
                                ),
                                item["pay_status"]!=1&&item["order_status"]!=3
                                    ?Container(
                                  height:40.0,
                                  margin: EdgeInsets.only(right:10.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFff6600),
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: FlatButton(
                                      onPressed:(){

                                      },
                                      child: Text("立即支付",style: TextStyle(color:Colors.white),)
                                  ),
                                ):Text(""),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
