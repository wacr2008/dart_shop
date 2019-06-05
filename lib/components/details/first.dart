import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import "package:flutter_html/flutter_html.dart";
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/login.dart';

class FirstComponent extends StatefulWidget {
  var  model;
  FirstComponent({Key key,this.model}):super(key: key);
  @override
  _FirstComponentState createState() => _FirstComponentState();
}

class _FirstComponentState extends State<FirstComponent>{
  TextEditingController _controller=new TextEditingController();
  Map goods;
  List imageList=[];
  String kHtml='';


  @override
  void initState() {
    _controller.text=widget.model.num.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double percenWidth(double num){
      double percen=width/100;
      return percen*num;
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          //商品图片显示
          Container(
            width: width,
            padding: EdgeInsets.all(10.0),
            height: 300.0,
            child: widget.model.goodsImage.length>0?Swiper(
              itemBuilder:(BuildContext context, int index){
                return Image.network(widget.model.goodsImage[index]["image_url"],fit: BoxFit.fitHeight,);
              },
              itemCount: widget.model.goodsImage.length,
              pagination: new SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.black54,
                    activeColor: Colors.green,
                  )),
              scrollDirection: Axis.horizontal,
              autoplayDisableOnInteraction : true,
              autoplay: false,
              onTap: (index) => print('点击了第$index个'),
            ):Text("加载中")),

          //标题
          Container(
            alignment: Alignment.center,
            height: 50.0,
            width: width,
            color: Color(0xFFefeff4),
            child: Text(widget.model.goods != null?widget.model.goods["goods_name"]:"",maxLines:1,style: TextStyle(fontSize: 16.0),),
          ),

          //价格等信息
          Container(
            width:width,
            padding:EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("价格:"),
                        Text(widget.model.goods != null?'￥${widget.model.goods["shop_price"]}':"",style: TextStyle(color:Color(0xFFE71F19),fontSize: 20.0),)
                      ],
                    ),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      child:MaterialButton(
                        onPressed: (){
                          if(widget.model.login){
                            widget.model.Collection(context,widget.model.goods["goods_id"]);
                          }else{
                            widget.model.showLogin(context);
                          }
                        },
                        color: Color(0xFFff6600),
                        child:Row(
                          children: <Widget>[
                            Padding(padding:EdgeInsets.only(right:5.0),child: Icon(Icons.stars,color: Colors.white,),),
                            Text("收藏",style: TextStyle(color: Colors.white),)
                          ],
                        ) ,
                      ),
                    )

                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:10.0),child: Text("购买数量:"),),
                    GestureDetector(
                      onTap:(){
                        widget.model.redcus(_controller);
                      },
                      child: Icon(Icons.remove_circle,color: Color(0xFFE71F19),),
                    ),
                    Container(
                      width:60.0,
                      height:43.0,
                      child: TextField(
                        controller:_controller,
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (res){
                            widget.model.InputChanged(res,_controller);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.model.add(_controller);
                      },
                      child: Icon(Icons.add_circle,color: Color(0xFFE71F19),),
                    )
                  ],
                )
              ],
            ),
          ),

          //详情
          Container(
            margin:EdgeInsets.only(top:15.0) ,
            alignment: Alignment.center,
            child: Container(
              width: percenWidth(90),
              child: Column(
                children: <Widget>[
                  Container(
                    height:40.0,
                    margin: EdgeInsets.only(bottom: 15.0),
                    color:Color(0xFFefeff4),
                    alignment: Alignment.center,
                    child: Text("详情"),
                  ),
                  Html(
                    data:widget.model.goods!=null?widget.model.goods["goods_content"]:"",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
