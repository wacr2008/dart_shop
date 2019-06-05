import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../lib/request.dart';
import "dart:convert";
import 'package:city_pickers/city_pickers.dart';
import 'package:toast/toast.dart';
class AddCityPage extends StatefulWidget {
  @override
  _AddCityPageState createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _name;
  String _address;
  String _mobile;
  String _city;
  String _province;
  String _district;
  String _isPhone(val){
    if(val==""||val==null||val.isEmpty){
      return "手机号不能为空";
    }
    if(!new RegExp("^1[23456789]\\d{9}\$").hasMatch(val)){
      return "手机号格式不正确";
    }
  }

  void _onSubmit() {

    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      Request.post("/Api/User/addAddress",params: {
        "consignee": _name,
        "province": _province,
        "city": _city,
        "district": _district,
        "address": _address,
        "mobile": _mobile
      }).then((jsons){
        Toast.show("添加成功",context,gravity: Toast.CENTER);
        Navigator.pop(context);
      }).catchError((err){
        Toast.show(err,context,gravity: Toast.CENTER);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:Text("新增地址"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
              width:width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:Color(0xFF666666),width:0.5
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:110,
                    height:50.0,
                    alignment: Alignment.centerRight,
                    child: Text("收货人:"),
                  ),
                  Container(
                    width: 280.0,
                    height:40.0,
                    margin: EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (val)=>(val == null || val.isEmpty) ? "收货人不能为空": null,
                      onSaved: (val)=> this._name = val,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50.0,
              width:width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color:Color(0xFF666666),width:0.5
                      )
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:110,
                    height:50.0,
                    alignment: Alignment.centerRight,
                    child: Text("选择地址:"),
                  ),
                  Container(
                    width: 280.0,
                    height:40.0,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed:() async {
                              Result result = await CityPickers.showCityPicker(
                                  context: context
                              );
                              if(result!=null){
                                Map jsons=json.decode(result.toString());
                                print(result);
                                setState(() {
                                  _province=jsons["provinceName"];
                                  _city=jsons["cityName"];
                                  _district=jsons["areaName"];
                                });
                              }

                            },
                            color: Color(0xFFe71f19),
                            textColor: Colors.white,
                            child: Text("地址")
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15.0),
                          child: Text(_province!=null?_province+_city+_district:""),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
            Container(
              height: 50.0,
              width:width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color:Color(0xFF666666),width:0.5
                      )
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:110,
                    height:50.0,
                    alignment: Alignment.centerRight,
                    child: Text("详细地址:"),
                  ),
                  Container(
                    width: 280.0,
                    height:40.0,
                    margin: EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (val)=>(val == null || val.isEmpty) ? "详细地址不能为空": null,
                      onSaved: (val)=> this._address = val,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50.0,
              width:width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color:Color(0xFF666666),width:0.5
                      )
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width:110,
                    height:50.0,
                    alignment: Alignment.centerRight,
                    child: Text("手机号:"),
                  ),
                  Container(
                    width: 280.0,
                    height:40.0,
                    margin: EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: _isPhone,
                      onSaved: (val)=> this._mobile = val,
                    ),
                  )
                ],
              ),
            ),

            GestureDetector(
              onTap:_onSubmit,
              child: Container(
                  margin: EdgeInsets.only(top:35.0),
                  alignment: Alignment.center,
                  width:260.0,
                  height:40.0,
                  color: Color(0xFFe71f19),
                  child:  Text("新增",style: TextStyle(color: Colors.white))
              ),
            )
          ],
        ),
      ),
    );
  }
}
