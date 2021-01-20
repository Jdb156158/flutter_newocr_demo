import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_newocr_demo/handsignature.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  // 主方法
  @override
  Widget build(BuildContext context) {
    print(context.findRootAncestorStateOfType());
    return MaterialApp(
        home: _HomePage()
    );
  }

}

class _HomePage extends StatelessWidget{

  static const MethodChannel _methodChannel = MethodChannel('flutter_native_ios');

  List _iosResultsList = [
    {'title' : '电子签名','desc' : '拍照、相册图片选择、手写'},
    {'title' : '图片自动巡边裁剪','desc' : '裁剪框8点手势支持不规则裁剪'},
    {'title' : '图片转Pdf','desc' : '单图、多图情况'},
    {'title' : '水印添加','desc' : '文档添加水印'},
    {'title' : '表格扫描转为exsl','desc' : '对转换的exsl可以进行修改'}];

  List<Widget> _infoListView(BuildContext context) {
    var list = _iosResultsList.map((value) {
      return ListTile(
        title: Text(value["title"]),
        subtitle: Text(value["desc"]),
        trailing: Icon(Icons.arrow_forward_ios),
        leading: Icon(Icons.account_balance_wallet_outlined),
        onTap: () {
          if (value["title"] == "电子签名"){
            _showActionSheet(context);
          }else if(value["title"] == "图片自动巡边裁剪"){
            _methodChannel
                .invokeMethod("flutter_push_to_CropView", {"url": ""});
          }else if(value["title"] == "图片转Pdf"){

          }else if(value["title"] == "水印添加"){

          }else if(value["title"] == "表格扫描转为exsl"){

          }
        },
      );
    });
    return list.toList();
  }

  _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            '提示',
            style: TextStyle(fontSize: 22),
          ), //标题
          //message: Text('麻烦抽出几分钟对该软件进行评价，谢谢!'), //提示内容
          actions: <Widget>[
            //操作按钮集合
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);

                _methodChannel
                    .invokeMethod("flutter_push_to_CSJIDScanView", {"url": ""});
              },
              child: Text('拍照'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);

                _methodChannel
                    .invokeMethod("flutter_push_to_ios", {"url": ""});
              },
              child: Text('相册选择'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HandSignature(),
                  ),
                );
              },
              child: Text('手写签名'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            //取消按钮
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FlutterOcr最新功能调研')),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(child: ListView(
              children: this._infoListView(context),
            )),
          ],
        ),
      ),
    );
  }
}


