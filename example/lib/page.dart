import 'package:flutter/material.dart';
import 'package:fm_baidu_map/fm_baidu_map.dart';
import 'package:fm_baidu_map/fm_baidu_map.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'dart:math';
import './bsmap_cj_controller.dart';
import './line_cj.dart';
import './cj_base.dart';
import './cj_pole.dart';
import 'dart:convert';

class PageTest extends StatefulWidget {
  @override
  _PageTestState createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  BsMapCJLineController _controller;
  BsCJBase _cj;
  @override
  void initState() {
    super.initState();
    _controller = BsMapCJLineController(onMessage: (method, config) {
      if (method == "click_overlay") {
        _cj.onClick(json.decode(config));
      }
    });
    _cj = BsCJPole(_controller);
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
            Expanded(child: BsMapCJLine(controller: _controller)),
            Container(
              height: 100,
              child: Wrap(
                children: <Widget>[
                  OutlineButton(
                      child: Text("绘"),
                      onPressed: () async {
                        if (_controller.centerPoint == null) {
                          return;
                        }
                        await _cj.sure(config: {
                          "number": _cj.nextNumber(),
                        });
                        // FmMapOverlaysMark item = await _controller.drawer
                        //     .addOverlay(FmMapOverlaysMark(
                        //         point: _controller.centerPoint,
                        //         icon: "circle.png",
                        //         text: 1.toString(),
                        //         zIndex: 10));
                        // _controller.startShirr(_controller.centerPoint);
                        // _addPole(_centerPoint);
                        // if (_poles.length > 1) {
                        //   var p1 = _poles[_poles.length - 2];
                        //   var p2 = _poles[_poles.length - 1];
                        //   _addLine(
                        //     p1: p1,
                        //     p2: p2,
                        //     color: 0xAAFF0000,
                        //   );
                        //   // 计算距离
                        //   double distance = await FmBaiduMap.getDistance(
                        //     p1["latitude"],
                        //     p1["longitude"],
                        //     p2["latitude"],
                        //     p2["longitude"],
                        //   );
                        //   var tan = (p2["latitude"] - p1["latitude"]) /
                        //       (p2["longitude"] - p1["longitude"]);
                        //       tan = atan(tan);
                        //   var angle = tan * 180 / pi;
                        //   // Vector2 v1 = Vector2(p1["latitude"], p1["longitude"]);
                        //   // // Vector2 v2 = Vector2(p2["latitude"], p2["longitude"]);
                        //   // Vector2 v3 = Vector2((p1["latitude"] + p2["latitude"]) / 2.0, (p1["longitude"] + p2["longitude"]) / 2.0);
                        //   // Matrix2 m = Matrix2.columns(v3,v1);
                        //   // m.setRotation(pi/2.0);
                        //   // Vector2 x = m.row1+v3;
                        //   // v3.setValues(v3.x, y_);
                        //   _map.addText(
                        //     fontSize: 20,
                        //     // bgColor: 0xAAFF0000,
                        //     layer: "line_text",
                        //     latitude: (p1["latitude"] + p2["latitude"]) / 2.0,
                        //     longitude:
                        //         (p1["longitude"] + p2["longitude"]) / 2.0,
                        //     text: distance.toStringAsFixed(2),
                        //     rotate: angle,
                        //     fontColor: 0xFF0000F0,
                        //   );
                        // }
                        // if (_currentLine != null) {
                        //   _currentLine["points"][0] = _poles[_poles.length - 1];
                        //   _map.update(object: _currentLine);
                        // }
                      }),
                  OutlineButton(
                    child: Text("删"),
                    onPressed: () {
                      _cj.remove(_cj.selectedIndex());
                    },
                  ),
                  OutlineButton(
                    child: Text("前"),
                    onPressed: () {
                      _cj.setInstertDirect(BsCJBaseInsertDirect.before);
                    },
                  ),
                  OutlineButton(
                    child: Text("后"),
                    onPressed: () {
                      _cj.setInstertDirect(BsCJBaseInsertDirect.after);
                    },
                  ),
                  OutlineButton(
                    child: Text("不选"),
                    onPressed: () {
                      _cj.cancelSelect();
                    },
                  ),
                  OutlineButton(
                    child: Text("确定"),
                    onPressed: () {
                      _cj.sure();
                    },
                  ),
                  // OutlineButton(
                  //   child: Text("多页面"),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       new MaterialPageRoute(builder: (context) => PageTest()),
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
            // Expanded(
            //   child: _map2.map,
            // )
          ],
        ));
  }
}
