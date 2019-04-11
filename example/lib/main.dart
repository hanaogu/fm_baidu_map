import 'package:flutter/material.dart';
import './map.dart';
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
        title: Text('百度地图定位测试'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          OutlineButton(
            child: Text("进入"),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => MapTest()),
              );
            },
          ),
          Text("经度：${_info['longitude']??''}，纬度：${_info['latitude']??''}")
        ],
      )),
    );
  }
}
