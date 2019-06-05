import 'package:flutter/material.dart';
import '../lib/request.dart';
import "../views/details.dart";
class BrandCenterpage extends StatefulWidget {
  int id;
  BrandCenterpage({this.id});

  @override
  _BrandCenterpageState createState() => _BrandCenterpageState();
}

class _BrandCenterpageState extends State<BrandCenterpage> {
  ScrollController _scrollController = new ScrollController(keepScrollOffset: false);
  int _page=1;
  bool isTrue = true;
  List brandList=[];
  @override
  void initState() {
    super.initState();
    _getlist();
    _scrollController.addListener(() {
      var position = _scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50) {
        if(isTrue){
          _getlist();
        }

      }
    });
  }

  _getlist(){
    setState(() {
      isTrue=false;
    });
    Request.get("/api/Brand/goodsList?brand_id=${widget.id}&p=${_page++}").then((item){
      setState(() {
        if(item["goods_list"]!=null){
          if(item["goods_list"].length>9){
            isTrue=true;
          }
          brandList.addAll(item["goods_list"]);
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("品牌商品"),
      ),
      body:Container(
        padding: EdgeInsets.only(left:20.0,right:20.0,top:10.0,bottom: 10.0),
        child: GridView.count(

            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            controller: _scrollController,
            childAspectRatio:0.8,//这个主要控制高度显示
            shrinkWrap: true, //这个不加会一直报错
            children:brandList.map((item)=>
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
    );
  }
}
