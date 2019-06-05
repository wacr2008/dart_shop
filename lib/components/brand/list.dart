import "package:flutter/material.dart";
import "package:rxdart/rxdart.dart";
import "../../lib/request.dart";
import '../../views/brandCenter.dart';
class BrandList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BrandList();
  }
}


class _BrandList extends StatefulWidget {
  @override
  __BrandListState createState() => __BrandListState();
}

class __BrandListState extends State<_BrandList>  with AutomaticKeepAliveClientMixin{
  List brandList=[];
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
        Request.post("/Home/Index/BrandStreet").then((list){
          setState(() {
            brandList=list;
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(15.0),
          childAspectRatio: 1.3,//这个主要控制高度显示
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: brandList.map((item)=>
             GestureDetector(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                   return BrandCenterpage(id: item["id"]);
                 }));
               },
               child:  Container(
                 padding: EdgeInsets.all(5.0),
                 decoration: BoxDecoration(
                     border: Border.all(color: Colors.black45)
                 ),
                 alignment: Alignment.center,
                 child: item["logo"]!=''?Image.network("http://yehui188.com"+item["logo"],fit: BoxFit.cover,):Text(""),
               ),
             )
          ).toList(),
      ),
    );
  }
}
