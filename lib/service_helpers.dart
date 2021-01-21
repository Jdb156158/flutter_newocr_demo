import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_newocr_demo/constans.dart';
import 'package:flutter_newocr_demo/ocr_excel_entity.dart';



class ServiceApi {
  static int ok = 0;

  static String serviceUrl = "https://ocr.adesk.com";

  static String ocrUrl =
      "https://aip.baidubce.com/rest/2.0/solution/v1/form_ocr/request";

  //通用ORC识别接口
  static Future<OcrExcelEntity> getOrcExcel(String imageBase64) async {
    var dio = new Dio(new BaseOptions(
        contentType: "application/x-www-form-urlencoded"));

    FormData formData = new FormData.fromMap({
      "image": imageBase64,
      "is_sync": "true",
      "request_type": "excel",
    });

    var auth = await getAuth(ak: Constants.ocr_key, sk: Constants.ocr_secret);
    if (auth != "") {
      var request = ocrUrl + "?access_token=" + auth;
      print("识别Url=" + request);
      Response response = await dio.post(request, data: formData);
      Map<String, dynamic> jsonMap = json.decode(response.toString());

      print("=========获取百度转换后的数据1：$jsonMap");

      var ocrEntity = OcrExcelEntity.fromJson(jsonMap);

      print("=========获取百度转换后的数据2：${ocrEntity.result_data}");
      return ocrEntity;
    }else{
      return null;
    }
  }

  //ORC识别接口刷新token接口
  static Future<String> getAuth(
      {@required String ak, @required String sk, String bb}) async {
    var dio = new Dio();
    String authHost = "https://aip.baidubce.com/oauth/2.0/token?";
    String getAccessTokenUrl = authHost
        // 1. grant_type为固定参数
        +
        "grant_type=client_credentials"
        // 2. 官网获取的 API Key
        +
        "&client_id=" +
        ak
        // 3. 官网获取的 Secret Key
        +
        "&client_secret=" +
        sk;
    Response response = await dio.get(getAccessTokenUrl);
    var data = response.data;
    print(data);
    var replaceAll = data.toString().replaceAll("{", "").replaceAll("}", "");
    var split = replaceAll.split(",");
    for (int i = 0; i < split.length; i++) {
      var result = split[i].split(":");
      if (result[0].contains("access_token")) {
        print("containskey");
        return result[1];
      }
    }
    return "";
  }


}