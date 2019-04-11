import 'package:flutter/material.dart';

import 'package:fm_baidu_location/fm_baidu_location.dart';

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  final FmBaiduLocation _location = FmBaiduLocation();
  Map _info={};
  @override
  void initState() {
    super.initState();
    _location.init(onLocation:(event){
      print(event.toString());
      setState(() {
        _info = event;
      });
    });
  }

  @override
  void dispose() {
    print("dispose");
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("定位测试"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("开始"),
            onPressed: () {
              _location.start();
            },
          ),
          FlatButton(
            child: Text("停止"),
            onPressed: () {
              _location.stop();
            },
          ),
          FlatButton(
            child: Text("多界面"),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => MapTest()),
              );
            },
          ),
          Text("经度：${_info['longitude']??''}，纬度：${_info['latitude']??''}")
        ],
      ),
    );
  }
}
