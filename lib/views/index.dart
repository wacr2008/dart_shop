import "package:flutter/material.dart";
import "./home.dart";
import "./cart.dart";
import "./brand.dart";
import "./user.dart";

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IndexWidget();
  }
}

class IndexWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _IndexState();
  }
}
class _IndexState extends State {
  int _currentIndex=0;
  List pageList = [HomePage(),CartPage(),BrandPage(),UserPage()];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:Color(0xFFe71f19) ,//设置选中颜色
        unselectedItemColor: Colors.black54,//没选中颜色
        type:BottomNavigationBarType.fixed,//底部栏类型
        showUnselectedLabels: true,//显示文字
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: new Text( '首页')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: new Text( '购物车')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              title: new Text( '品牌')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: new Text( '个人中心')
          ),
        ],
        currentIndex:_currentIndex,

      ),
    );
  }
}