import 'package:flutter/material.dart';
import '../lib/request.dart';
import '../views/user/address.dart';
class ConfirmOrderPage extends StatefulWidget {
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  Map address;
  List goodsList=[];
  Map count;
  @override
  void initState() {
    super.initState();
    _getDetails();
  }
  
  _getDetails(){
    Request.post("/Api/Cart/cart2").then((result){
      setState(() {
        address=result["addressList"];
        goodsList=result["cartList"];
        count=result["totalPrice"];
      });
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
          title:Text("确认订单")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //地址选择
            GestureDetector(
              onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return AddressPage();
                  })).then((item){
                    _getDetails();
                  });
              },
              child: Container(
                height:90.0,
                padding: EdgeInsets.all(10.0),
                width: width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:Color(0xFFc8c7cc),width: 0.5
                        )
                    )
                ),
                child: address!=null&&address["address"]!=null?Row(
                  children: <Widget>[
                    Icon(Icons.location_on,color:Color(0xFF666666),),
                    SizedBox(width:15.0,),
                    Column(
                      children: <Widget>[
                        Container(
                          width:percenWidth(76),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("收货人:${address["consignee"]}"),
                              Text(address["mobile"])
                            ],
                          ),
                        ),
                        Container(
                          width:percenWidth(76),
                          child: Text("收货地址:${address["province"]}${address["city"]}${address["district"]}${address["address"]}",maxLines: 2),
                        )
                      ],
                    ),
                    SizedBox(width:10.0,),
                    Icon(Icons.keyboard_arrow_right,color:Color(0xFF666666),)
                  ],
                ):Container(
                  alignment: Alignment.center,
                  child: Text("请选择地址"),
                ),
              ),
            ),

            //商品展示
            Container(width: width,height:10.0,color: Color(0xFFf5f5f5),),
            Container(
              width:width,
              height:35.0,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color:Color(0xFFc8c7cc),width: 0.5
                      )
                  )
              ),
              alignment: Alignment.center,
              child: Text("购买商品列表",style: TextStyle(color: Color(0xFFff6600)),),
            ),
            Column(
              children: goodsList.length>0?goodsList.map((item)=>
                  Container(
                    height: 90.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:Color(0xFFc8c7cc),width: 0.3
                            )
                        )
                    ),
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.network("http://www.yehui188.com"+item["original_img"],height: 70.0,),
                        SizedBox(width: 15.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:EdgeInsets.only(top:6.0),
                              height:58.0,
                              width:percenWidth(68),
                              child: Text(item["goods_name"],maxLines: 2,style: TextStyle(fontSize: 16.0),),
                            ),
                            RichText(
                                text: TextSpan(
                                    text:"￥${item["goods_price"]}",
                                    style: TextStyle(color:Color(0xFFff6600),fontSize: 16.0),
                                    children: [
                                      TextSpan(
                                        text:" x${item["goods_num"]}",
                                        style: TextStyle(color:Colors.black,fontSize: 14.0),
                                      )
                                    ]
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
              ).toList():[],
            ),

            //结算部分
            Container(width: width,height:10.0,color: Color(0xFFf5f5f5),),
            Container(
              width: width,
              height:170.0,
              padding: EdgeInsets.only(left:25.0,right:25.0,top:15.0,bottom: 15.0),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          RichText(
                              text: TextSpan(
                                text:"商品金额:",
                                style: TextStyle(color:Color(0xFF666666)),
                                children: [
                                  TextSpan(
                                    text:count!=null?" ￥${count['total_fee']}":" ￥0",
                                    style: TextStyle(color:Color(0xFFff2233),fontSize: 18.0),
                                  )
                                ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  text:"使用优惠券:",
                                  style: TextStyle(color:Color(0xFF666666)),
                                  children: [
                                    TextSpan(
                                      text:" -￥0",
                                      style: TextStyle(color:Color(0xFFff2233),fontSize: 18.0),
                                    )
                                  ]
                              )
                          )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(
                                text:"使用积分:",
                                style: TextStyle(color:Color(0xFF666666)),
                                children: [
                                  TextSpan(
                                    text:" -￥0",
                                    style: TextStyle(color:Color(0xFFff2233),fontSize: 18.0),
                                  )
                                ]
                            )
                        ),
                        RichText(
                            text: TextSpan(
                                text:"应付金额:",
                                style: TextStyle(color:Color(0xFF666666)),
                                children: [
                                  TextSpan(
                                    text:count!=null?" ￥${count['total_fee']}":" ￥0",
                                    style: TextStyle(color:Color(0xFFff2233),fontSize: 18.0),
                                  )
                                ]
                            )
                        )
                      ],
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top:20.0),
                        width: percenWidth(65),
                        height:45,
                        decoration: BoxDecoration(
                            color: Color(0xFFff6600),
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),

                        alignment: Alignment.center,
                        child: Text("提交订单",style: TextStyle(color:Colors.white,fontSize: 16.0),),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
