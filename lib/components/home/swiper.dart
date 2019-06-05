import "package:flutter/material.dart";
import "package:flutter_swiper/flutter_swiper.dart";
import "package:rxdart/rxdart.dart";
import "../../lib/request.dart";

class HomeSwiper extends StatefulWidget {
  @override
  _homeSwiperComponentState createState() => _homeSwiperComponentState();
}

class _homeSwiperComponentState extends State<HomeSwiper>  with AutomaticKeepAliveClientMixin{
  final PublishSubject Observable = new PublishSubject();
  List bannerList=[];
  int _index=0;

  @override
  bool get wantKeepAlive =>true;//开启页面切换不重新加载

  @override
  void initState() {
    Observable.listen(_objserableController);
    Observable.add({"type":"fetch"});
    super.initState();
  }

  @override
  void dispose(){
    Observable.close();
    super.dispose();
  }

  void _objserableController(item) async {
    switch(item["type"]){
      case "fetch":
        Request.post("/api/index/banner").then((data)=>{
            setState(() {
              bannerList.addAll(data);
            })
        });
        break;
    }
  }

  //渲染轮播图
  Widget _swiperList(){
    if(bannerList.length==0){
      return Center(
        child: new Text('正在加载中，莫着急哦~'),
      );
    }else{
      return Swiper(
        itemBuilder:(BuildContext context, int index)=>Image.network(bannerList[index]["ad_code"],fit: BoxFit.fill,),
        itemCount: bannerList.length,
        autoplayDelay: 4000,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.black54,
              activeColor: Colors.white,
            )),
        scrollDirection: Axis.horizontal,
        autoplayDisableOnInteraction : true,
        autoplay: true,
        onTap: (index) => print('点击了第$index个'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height:200.0,
        child: _swiperList()
    );
  }
}
