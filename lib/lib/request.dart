import "dart:async";
import "dart:convert";
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
class Request{

  static String timeFormat(date){
    return "${date.year}-${date.month}-${date.day} ${date.hour+6}:${date.minute}:${date.second}";
  }

  static Future get(String url,{Map params}) async {
    Future future = new Future(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      Dio dio=new Dio(new BaseOptions(
        baseUrl: "http://yehui188.com",
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
      ));
      Map<String, dynamic> body={
        "sign":"3db1ad6287faa5e1ebdc8000f6e58752",
        "time":new DateTime.now().millisecondsSinceEpoch
      };
      if(pref.getBool("login")!=null){
        body["token"]=pref.getString("token");
      }
      Response response=await dio.get(url,queryParameters: body);
      Map jsons=json.decode(response.data);
      if(response.data is String){
        Map jsons=json.decode(response.data);
        if(jsons["status"]>0){
          return jsons["result"]!=null?jsons["result"]:[];
        }else{
          return jsons["msg"];
        }
      }else{
        Map jsons=response.data;
        if(jsons["status"]>0){
          return jsons["result"]!=null?jsons["result"]:[];
        }else{
          return jsons["msg"];
        }
      }
    });
    return future;
  }

  static Future post(String url,{Map params}) {
    Future future = new Future(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      Dio dio=new Dio(new BaseOptions(
        baseUrl: "http://yehui188.com",
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
      ));
      Map<String, dynamic> body={
        "sign":"3db1ad6287faa5e1ebdc8000f6e58752",
        "time":new DateTime.now().millisecondsSinceEpoch
      };
      if(pref.getBool("login")!=null){
        body["token"]=pref.getString("token");
      }
      if(params != null){
        params.forEach((key,val)=>{
            body[key]=val
        });
      }
      Response response=await dio.post(url,data:body);
      if(response.data is String){
        Map jsons=json.decode(response.data);
        if(jsons["status"]>0){
          return jsons["result"]!=null?jsons["result"]:[];
        }else{
          return jsons["msg"];
        }
      }else{
        Map jsons=response.data;
        if(jsons["status"]>0){
          return jsons["result"]!=null?jsons["result"]:[];
        }else{
          return jsons["msg"];
        }
      }
    });
    return future;
  }
}