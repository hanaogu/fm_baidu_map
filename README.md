# fm_baidu_location

## now, android only

```
import 'package:flutter/material.dart';
import 'package:fm_baidu_location/fm_baidu_location.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          Text("经度：${_info['longitude']??''}，纬度：${_info['latitude']??''}")
        ],
      ),
    );
  }
}
```