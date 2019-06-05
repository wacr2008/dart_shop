import 'package:flutter/material.dart';
import '../lib/request.dart';
import './details.dart';

class SearchPage extends StatefulWidget {
  String text;
  SearchPage({this.text});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _scrollController = new ScrollController(keepScrollOffset: true);
  TextEditingController _TextController=TextEditingController();
  List _searchLisdt=[];
  int _page=1;
  String _text="";
  bool isTrue=true;
  @override
  void initState() {
    _text=widget.text;
    _TextController.text=_text;
    _initRequest();
    super.initState();
    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 50) {
        if(isTrue){
          _initRequest();
        }
      }
    });
  }

  _initRequest(){
    Request.post("/Api/Goods/search",params: {"kw":_text,"p":_page++}).then((item){
        setState(() {
          _searchLisdt.addAll(item["goods_list"]);
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
        title:Text("商品搜索")
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: percenWidth(10),right: percenWidth(10),bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  border: Border.all(
                    color: Colors.black38
                  )
                ),
                height:45.0,
                child:TextField(
                  keyboardType: TextInputType.text,
                  controller: _TextController,
                  onSubmitted: (text){
                      if(text==""){
                        return false;
                      }
                     setState(() {
                       _searchLisdt=[];
                       _text=text;
                       _page=1;
                       _initRequest();
                     });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),

              GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  controller: ScrollController(),
                  childAspectRatio:0.85,//这个主要控制高度显示
                  shrinkWrap: true, //这个不加会一直报错
                  children:_searchLisdt.map((item)=>
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
            ],
          ),
        ),
      ),
    );
  }
}
