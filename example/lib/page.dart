import 'package:flutter/material.dart';
import 'package:fm_baidu_map/fm_baidu_map.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'dart:math';

class PageTest extends StatefulWidget {
  @override
  _PageTestState createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  final FmBaiduMap _map = FmBaiduMap();
  final FmBaiduLocation _location = FmBaiduLocation();
  final List _poles = [];
  Map _centerPoint;
  Map _currentLine;
  Map _currentPoint;
  // final FmBaiduMap _map2 = FmBaiduMap();
  @override
  void initState() {
    super.initState();
    _map.init((name, arg) {
      if (name == "onMapStatusChange") {
        _centerPoint = arg;
        if (_poles.length > 0) {
          if (_currentLine == null) {
            _currentLine = {
              "id": "_currentpoint_",
              "type": "line",
              "layer": "tmpline",
              "dottedLine": true,
              "color": 0xFF0000FF,
              "width": 3,
              "points": [_poles[_poles.length - 1], _centerPoint],
            };
            _map.addOverlays(objects: [_currentLine]);
          } else {
            _currentLine["points"][1] = _centerPoint;
            _map.update(object: _currentLine);
          }
        }
      }
      // print(name + arg.toString());
    });
    _location.init(onLocation: (Map event) {
      // print(event.toString());
      if (event["latitude"] < 1 ||
          event["latitude"] > 1000 ||
          event["longitude"] < 1 ||
          event["longitude"] > 1000) {
        return;
      }
      if (_currentPoint == null) {
        _map.setCenter(
            latitude: event["latitude"], longitude: event["longitude"]);
      }
      _currentPoint = event;
      _map.setCurrentPoint(
          latitude: event["latitude"], longitude: event["longitude"]);
    }).then((v) {
      _location.start();
    });
    // _map2.init((name, arg) {
    //   print(name + arg.toString());
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _location.dispose();
  }

  void _addLine(
      {Map p1,
      Map p2,
      dottedLine = false,
      String layer = "line",
      zIndex,
      color}) {
    _map.addLine(
        layer: layer,
        dottedLine: dottedLine,
        points: [p1, p2],
        zIndex: zIndex,
        color: color);
  }

  // 绘制一个杆
  void _addPole(Map obj) {
    //  "type": "mark",
    //   "layer": "pole",
    //   "latitude": 39.141593,
    //   "longitude": 117.208856,
    //   "icon": "circle.png",
    //   "anchorX": 0.5,
    //   "anchorY": 0.5,
    String id = _map.addMark(
      layer: "pole",
      latitude: obj["latitude"],
      longitude: obj["longitude"],
      icon: "circle.png",
      scale: 0.5,
      zIndex: 10,
      textColor: 0xFFFFFFFF,
      text: (_poles.length + 1).toString(),
    );
    _poles.add({
      "rid": id,
      "latitude": obj["latitude"],
      "longitude": obj["longitude"],
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
            Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  OutlineButton(
                      child: Text("单个绘制"),
                      onPressed: () async {
                        _addPole(_centerPoint);
                        if (_poles.length > 1) {
                          var p1 = _poles[_poles.length - 2];
                          var p2 = _poles[_poles.length - 1];
                          _addLine(
                            p1: p1,
                            p2: p2,
                            color: 0xAAFF0000,
                          );
                          // 计算距离
                          double distance = await FmBaiduMap.getDistance(
                            p1["latitude"],
                            p1["longitude"],
                            p2["latitude"],
                            p2["longitude"],
                          );
                          var tan = (p2["latitude"] - p1["latitude"]) /
                              (p2["longitude"] - p1["longitude"]);
                              tan = atan(tan);
                          var angle = tan * 180 / pi;
                          // Vector2 v1 = Vector2(p1["latitude"], p1["longitude"]);
                          // // Vector2 v2 = Vector2(p2["latitude"], p2["longitude"]);
                          // Vector2 v3 = Vector2((p1["latitude"] + p2["latitude"]) / 2.0, (p1["longitude"] + p2["longitude"]) / 2.0);
                          // Matrix2 m = Matrix2.columns(v3,v1);
                          // m.setRotation(pi/2.0);
                          // Vector2 x = m.row1+v3;
                          // v3.setValues(v3.x, y_);
                          _map.addText(
                            fontSize: 20,
                            // bgColor: 0xAAFF0000,
                            layer: "line_text",
                            latitude: (p1["latitude"] + p2["latitude"]) / 2.0,
                            longitude:
                                (p1["longitude"] + p2["longitude"]) / 2.0,
                            text: distance.toStringAsFixed(2),
                            rotate: angle,
                            fontColor: 0xFF0000F0,
                          );
                        }
                        if (_currentLine != null) {
                          _currentLine["points"][0] = _poles[_poles.length - 1];
                          _map.update(object: _currentLine);
                        }
                      }),
                  OutlineButton(
                    child: Text("绘制"),
                    onPressed: () {
                      List list = [
                        {
                          "type": "line",
                          "layer": "line",
                          "color": 0xAAFF0000,
                          "dottedLine": true,
                          "points": [
                            {
                              "latitude": 39.141593,
                              "longitude": 117.208856,
                            },
                            {
                              "latitude": 39.141593,
                              "longitude": 117.218856,
                            },
                            {
                              "latitude": 39.151593,
                              "longitude": 117.248856,
                            },
                          ],
                        },
                        {
                          "type": "mark",
                          "layer": "pole",
                          "latitude": 39.141593,
                          "longitude": 117.208856,
                          "icon": "circle.png",
                          "anchorX": 0.5,
                          "anchorY": 0.5,
                          "title": "3"
                        },
                        {
                          "type": "mark",
                          "layer": "pole",
                          "latitude": 39.141593,
                          "longitude": 117.218856,
                          "icon": "circle.png",
                          "anchorX": 0.5,
                          "anchorY": 0.5,
                          "scale": 0.5,
                        },
                        {
                          "type": "mark",
                          "layer": "pole",
                          "latitude": 39.151593,
                          "longitude": 117.248856,
                          "icon": "circle.png",
                          "anchorX": 0.5,
                          "anchorY": 0.5,
                        }
                      ];
                      _map.addOverlays(objects: list);
                      // _map.addLine(
                      //   color: 0xAAFF0000,
                      //   points: [
                      //     {
                      //       "latitude": 39.141593,
                      //       "longitude": 117.208856,
                      //     },
                      //     {
                      //       "latitude": 39.141593,
                      //       "longitude": 117.218856,
                      //     },
                      //     {
                      //       "latitude": 39.151593,
                      //       "longitude": 117.248856,
                      //     },
                      //   ],
                      // );
                      // _map.addMark(
                      //     latitude: 39.141593,
                      //     longitude: 117.208856,
                      //     icon: "circle.png");
                    },
                  ),
                  OutlineButton(
                    child: Text("多页面"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => PageTest()),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    _map.map,
                    Center(
                      child: Text(
                        "+",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue),
                      ),
                    ),
                    Positioned(
                      bottom: 60.0,
                      left: 15.0,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          height: 30,
                          width: 30,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 22,
                          ),
                        ),
                        onTap: () {
                          if (_currentPoint == null) {
                            return;
                          }
                          _map.setCenter(
                              latitude: _currentPoint["latitude"],
                              longitude: _currentPoint["longitude"]);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: _map2.map,
            // )
          ],
        ));
  }
}
