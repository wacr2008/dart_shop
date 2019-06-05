import 'package:flutter/material.dart';
import '../lib/request.dart';
import "../views/details.dart";
class ClassPage extends StatefulWidget {
  String id;
  ClassPage({this.id});
  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  ScrollController _scrollController = new ScrollController(keepScrollOffset: true);
  var _productType;
  var _brandType;
  int _page=1;
  bool isTrue = true;
  List _classList=[];
  List _brandList=[];
  List _productList=[];

  @override
  void initState() {
    super.initState();
    _initRequest();
    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 50) {
        if(isTrue){
          _initRequest();
        }
      }
    });
  }

  void _initRequest() {
    setState(() {
      isTrue=false;
    });
    String url="/api/goods/goodsList?p=${_page++}";
    if(_productType!=null){
      url+="&id=${_productType}";
    }else{
      url+="&id=${widget.id}";
    }
    if(_brandType!=null){
      url+="&brand_id=${_brandType}";
    }
    Request.get(url).then((result){
      setState(() {
        if(result["goods_list"]!=null){
          _classList.addAll(result["goods_list"]);
        }
        if(_productList.length==0){
          _productList=result["SecCate"];
        }
        if(result["filter_brand"]!=null){
          _brandList=result["filter_brand"];
        }

        isTrue=true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("分类商品")
      ),
      body:SingleChildScrollView(
        controller: _scrollController,
        child:Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child:DropdownButton(
                          style:TextStyle(
                            decorationStyle:TextDecorationStyle.dashed,
                          ),
                          hint:Container(child: Text(_productList.length==0?"暂无类型":"全部类型"),alignment: Alignment.center,),
                          value:_productType,
                          isExpanded: true,
                          items:_productList.length>0?_productList.map((item)=>
                              DropdownMenuItem(
                                  child: Container(child: Text('${item["mobile_name"]}',style: TextStyle(color: Colors.black),),alignment: Alignment.center,),
                                  value:item["id"].toString()
                              )
                          ).toList():[],
                          onChanged: (item){
                            setState(() {
                              _productType=item;
                              _classList=[];
                              _brandType=null;
                              _page=1;
                              _initRequest();
                            });

                          }
                      )
                  ),
                  Container(width:1,color: Colors.black38,height:34),
                  Expanded(
                      child: DropdownButton(
                          style: TextStyle(
                            decorationStyle:TextDecorationStyle.dashed,
                          ),
                          hint:Container(child: Text(_brandList.length==0?"暂无品牌":"全部品牌"),alignment: Alignment.center,),
                          value:_brandType,
                          isExpanded: true,
                          items:_brandList.length>0?_brandList.map((item)=>
                              DropdownMenuItem(
                                  child: Container(child: Text('${item["name"]}',style: TextStyle(color: Colors.black),),alignment: Alignment.center,),
                                  value:item["hreg"]
                              )
                          ).toList():[],
                          onChanged: (item){
                            setState(() {
                              _brandType=item;
                              _classList=[];
                              _page=1;
                              _initRequest();
                            });
                          }
                      )
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    controller: ScrollController(),
                    childAspectRatio:0.85,//这个主要控制高度显示
                    shrinkWrap: true, //这个不加会一直报错
                    children:_classList.map((item)=>
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return DetailsPage(id: item["goods_id"]);
                            }));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFcccccc))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network("http://www.yehui188.com"+item["original_img"],height:100.0,fit: BoxFit.fitWidth,),
                                Container(width:MediaQuery.of(context).size.width,height:10.0),
                                Text(item["goods_name"],maxLines: 2,overflow: TextOverflow.ellipsis,style:                             TextStyle(
                                    fontSize: 16.0
                                ),),
                                Text('￥${item["shop_price"]}',style: TextStyle(
                                    color: Color(0xFFff6600),
                                    fontSize: 24
                                ),)
                              ],
                            ),
                          ),
                        )
                    ).toList()
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
