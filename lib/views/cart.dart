import "package:flutter/material.dart";
import '../lib/request.dart';
import 'package:toast/toast.dart';
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CartWidget();
  }
}

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  List goodsList=[];
  int count=0;
  double countMoney=0;
  @override
  void initState() {
    super.initState();
    _getList();
  }

  _getList(){
    Request.post("/index.php?m=api&c=Cart&a=cartList").then((result){
        List add=[];
        for(int i=0;i<result["cartList"].length;i++){
          result["cartList"][i]["value"]=false;
          result["cartList"][i]["count"]=double.parse(result["cartList"][i]["goods_price"])*result["cartList"][i]["goods_num"];
          add.add(result["cartList"][i]);
        }
        setState(() {
          goodsList=add;
          _Calculation();
        });
    });
  }

  _Calculation(){
    double countMoneys=0;
    int counts=0;
    for(int i=0;i<goodsList.length;i++){
        if(goodsList[i]["value"]){
          counts+=1;
          countMoneys+=goodsList[i]["count"];
        }
    }
    setState(() {
      count=counts;
      countMoney=countMoneys;
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
        title:Text("购物车")
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          decoration: BoxDecoration(
              border: Border(
                  top:BorderSide(
                      color: Colors.black38,
                      width: 0.5
                  )
              )
          ),
          padding: EdgeInsets.only(left:30.0,top:0,right:0,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("总共"),
                  Text(" $count ",style:TextStyle(
                      color:Color(0xFFe71f19),
                      fontSize: 18
                  )),
                  Text("件"),
                ],
              ),
              Text("￥$countMoney",style: TextStyle(
                  color:Color(0xFFe71f19),
                  fontSize: 18
              ),),
              Container(
                width:100,
                height:45,
                alignment: Alignment.center,
                color:Color(0xFFe71f19),
                child: FlatButton(
                    onPressed: (){
                        if(count<=0){
                          Toast.show("请选择商品",context,gravity: Toast.CENTER);
                          return false;
                        }
                    },
                    child: Text("去结算",style:TextStyle(
                        color:Colors.white,
                        fontSize: 18
                    ))
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        width:MediaQuery.of(context).size.width,
        child: ListView(
          children: goodsList.length>0
              ?
          goodsList.map((row)=>
              Container(
                width: MediaQuery.of(context).size.width,
                height:110.0,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:  Color(0xFFcccccc)
                        )
                    )
                ),
                child: Row(
                    children: <Widget>[
                      Container(
                        height:100.0,
                        width:50.0,
                        child: Checkbox(
                            activeColor: Colors.red,
                            value: row["value"],
                            onChanged: (item){
                              row["value"]=item;
                              setState(() {});
                              _Calculation();
                            }
                        ),
                      ),
                      Image.network("http://yehui188.com"+row["original_img"],width: percenWidth(25),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height:40.0,
                            margin: EdgeInsets.only(left: 10.0),
                            width:percenWidth(55),
                            child: Text(row["goods_name"],maxLines: 2,),
                          ),
                          Container(
                            width:percenWidth(55),
                            height:45.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                    left:10.0,
                                    top:4,
                                    child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(color: Colors.red,fontSize: 16.0),
                                            text:"￥${row["goods_price"]}",
                                            children: [
                                              TextSpan(
                                                text:" x${row["goods_num"]}",
                                                style: TextStyle(color: Colors.black,fontSize: 12.0),
                                              )
                                            ]
                                        )
                                    )
                                ),
                                Positioned(
                                    left:10.0,
                                    top:25.0,
                                    child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(color: Colors.black),
                                            text:"小计:",
                                            children: [
                                              TextSpan(
                                                text:" ￥${row["count"]}",
                                                style: TextStyle(color: Color(0xFFff6804),fontSize: 16.0),
                                              )
                                            ]
                                        )
                                    )
                                ),
                                Positioned(
                                    right:-10,
                                    bottom: -10,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: (){
                                            Request.post("/Home/Cart/ajaxDelCart.html",params: {
                                              "ids":row["id"]
                                            }).then((item){
                                              Toast.show("删除成功",context,gravity: Toast.CENTER);
                                              _getList();
                                            });
                                        }
                                    )
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ]),
              )
          ).toList()
              :
          [
            Container(
              height: 100.0,alignment: Alignment.center,
              child: Text("购物车暂无商品"),
            )
          ],
        ),
      ),
    );
  }
}



