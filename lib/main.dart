import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_newocr_demo/handsignature.dart';
import 'package:flutter_newocr_demo/service_helpers.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_newocr_demo/web_view_component.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
//文件下载路径相关
import 'package:path_provider/path_provider.dart';

//办公文件预览
import 'package:flutter_file_preview/flutter_file_preview.dart';

void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


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
        home: _HomePage(),
        navigatorKey: navigatorKey,
    );
  }

}

class _HomePage extends StatelessWidget{

  static const MethodChannel _methodChannel = MethodChannel('flutter_native_ios');

  ProgressDialog pr;

  List _iosResultsList = [
    {'title' : '电子签名','desc' : '拍照、相册图片选择、手写'},
    {'title' : '图片自动巡边裁剪','desc' : '裁剪框8点手势支持不规则裁剪'},
    {'title' : '图片转Pdf','desc' : '单图、多图情况'},
    {'title' : '水印添加','desc' : '文档添加水印'},
    {'title' : '表格扫描转为excel','desc' : '对转换的exsl可以进行修改'}];

  Future<void> _pushExcelView(BuildContext context) async {
    final String base64Str = await _methodChannel
        .invokeMethod("flutter_push_to_ExslView", {"url": ""});
    if (base64Str.length > 0) {
      print("转换成功的数据是：$base64Str");
      if (pr == null) {
        _initProgressDialog(context);
      }
      pr.show();
      var ocrEntity = await ServiceApi.getOrcExcel(base64Str);
      if (ocrEntity.result_data.length > 0 && ocrEntity.ret_code == 3) {
        pr.hide();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => WebViewComponent(ocrEntity.result_data)
        //   ),
        // );

        //下载到本地
        //_doDownloadOperation(context,ocrEntity.result_data);

        //直接网络加载
        _methodChannel
            .invokeMethod("flutter_push_to_WebView", {"url": ocrEntity.result_data});

      } else {
        pr.hide();
        print("调取百度接口没有转换成功");

      }
    } else {
      print("没有转换成功");
    }
  }

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

          }else if(value["title"] == "表格扫描转为excel"){

            _pushExcelView(context);

            //自己写的网络加载
            // _methodChannel
            //     .invokeMethod("flutter_push_to_WebView", {"url": "http://bj.bcebos.com/v1/ai-edgecloud/3C4DCEB30D964D7C880F2E74771C9349.xls?authorization=bce-auth-v1%2Ff86a2044998643b5abc89b59158bad6d%2F2021-01-21T06%3A29%3A21Z%2F172800%2F%2Fe6200f579492d7c0f1b166e878a5c97800f8b8f1be7c0cd332315fd230523241"});

            //网络加载
            // FlutterFilePreview.openFile(
            //     "http://bj.bcebos.com/v1/ai-edgecloud/3C4DCEB30D964D7C880F2E74771C9349.xls?authorization=bce-auth-v1%2Ff86a2044998643b5abc89b59158bad6d%2F2021-01-21T06%3A29%3A21Z%2F172800%2F%2Fe6200f579492d7c0f1b166e878a5c97800f8b8f1be7c0cd332315fd230523241",
            //     title: 'Online Xls');

            //本地加载
            //FlutterFilePreview.openFile("/var/mobile/Containers/Data/Application/A5C17D4D-27E4-455D-9924-60CCC6E548F0/Library/Application Support/Download/temp.Xls", title: 'Temp Xls');

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => WebViewComponent("https://kdocs.cn/l/snR9ao6f6g1N")
            //   ),
            // );
          }
        },
      );
    });
    return list.toList();
  }

  _initProgressDialog(BuildContext context) {
    pr = new ProgressDialog(context);
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

  // 执行下载文件的操作
  _doDownloadOperation(BuildContext context,downloadUrl) async {
    /**
     * 下载文件的步骤：
     * 1. 获取权限：网络权限、存储权限
     * 2. 获取下载路径
     * 3. 设置下载回调
     */

    // 获取权限
    var isPermissionReady = await _checkPermission(context);
    if (isPermissionReady) {
      // 获取存储路径
      var _localPath = (await _findLocalPath(context)) + '/Download';

      final savedDir = Directory(_localPath);
      // 判断下载路径是否存在
      bool hasExisted = await savedDir.exists();
      // 不存在就新建路径
      if (!hasExisted) {
        savedDir.create();
      }
      // 下载
      _downloadFile(downloadUrl, _localPath);
    } else {
      print("您还没有获取权限");
    }
  }

  // 申请权限
  Future<bool> _checkPermission(BuildContext context) async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  // 获取存储路径
  Future<String> _findLocalPath(BuildContext context) async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }

  // 根据 downloadUrl 和 savePath 下载文件
  _downloadFile(downloadUrl, savePath) async {

    String newsavePath = savePath + "/temp.Xls";
    print("开始下载文件downloadUrl：$downloadUrl  savePath: $newsavePath");

    //使用 dio 下载文件
    await Dio().download(downloadUrl, newsavePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          // 4、连接资源成功开始下载后更新状态
          double progress = (receivedBytes / totalBytes);
          print("下载进度:$progress");
          if(progress>=1){
            FlutterFilePreview.openFile(newsavePath, title: 'Temp Xls');
          }
        });

  }

  // 根据taskId打开下载文件
  Future<bool> _openDownloadedFile(taskId) {
    //return FlutterDownloader.open(taskId: taskId);
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


