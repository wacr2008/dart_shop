import 'package:flutter/material.dart';
import '../../lib/request.dart';
import './addCity.dart';
import 'package:toast/toast.dart';
class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List addressList=[];

  @override
  void initState() {
    super.initState();
    _getAddressList();
  }

  _getAddressList(){
    Request.post("/api/User/getAddressList/").then((item){
      setState(() {
        addressList=item;
      });
    });
  }

  _serDefaultAddress(int id){
    Request.post("/api/User/setDefaultAddress",params: {"address_id":id}).then((item){
      Toast.show("设置默认地址成功",context,gravity: Toast.CENTER);
      _getAddressList();
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
        title:Text("地址管理")
      ),
      body:ListView(
        children: addressList.length==0
            ?
        [Container(
          height:100.0,
          alignment: Alignment.center,
          width: width,
          child: Text("暂无地址信息"),
        )]
            :
        addressList.map((item)=>
            Container(
              width: width,
              height:100.0,
              decoration: BoxDecoration(
                  color: item["is_default"]==1?Colors.red:Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color:Color(0xFF666666),width:0.5
                      )
                  )
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width:45,
                    child: Radio(
                        activeColor: item["is_default"]==1?Colors.white:Colors.black,
                        value:item["address_id"].toString(),
                        groupValue:item["is_default"]==1?item["address_id"].toString():"",
                        onChanged:(item){}
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _serDefaultAddress(item["address_id"]);
                    },
                    child: Container(
                      color: item["is_default"]==1?Colors.red:Colors.white,
                      width:percenWidth(74),
                      height:80.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("收件人: ${item["consignee"]}",style: TextStyle(fontSize: 16.0,color: item["is_default"]==1?Colors.white:Colors.black),),
                              Text("手机号: ${item["mobile"]}",style: TextStyle(fontSize: 16.0,color: item["is_default"]==1?Colors.white:Colors.black),)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top:7.0),
                            child: Text("收货地址: ${item["province"]}${item["city"]}${item["district"]}${item["address"]}",maxLines: 2,style: TextStyle(fontSize: 16.0,color: item["is_default"]==1?Colors.white:Colors.black),),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width:40.0,
                    child: IconButton(
                        icon: Icon(Icons.delete,color: item["is_default"]==1?Colors.white:Colors.black,),
                        onPressed: (){
                          Request.post("/api/User/del_address",params: {"id":item["address_id"]}).then((data){
                              Toast.show("删除成功",context,gravity:Toast.CENTER);
                              _getAddressList();
                          });
                        }
                    ),
                  )
                ],
              ),
            )
        ).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return AddCityPage();
            })).then((item){
              _getAddressList();
            });
          },
          child: Container(
            width: width,
            height: 45.0,
            color:Color(0xFFE71F19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.location_on,color: Colors.white,),
                Text("添加新地址",style: TextStyle(
                    color:Colors.white,fontSize: 16.0
                ),)
              ],
            ),
          ),
        )
      ),
    );
  }
}
