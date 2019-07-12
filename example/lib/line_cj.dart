import 'package:flutter/material.dart';
import 'package:fm_baidu_map/fm_baidu_map.dart';
import 'package:fm_fit/fm_fit.dart';
import './bsmap_cj_controller.dart';

/// 地图线状采集
class BsMapCJLine extends StatefulWidget {
  BsMapCJLine({
    Key key,
    this.data,
    this.controller,
  }) : super(key: key);
  final List data;
  final BsMapCJLineController controller;
  @override
  _BsMapCJLineState createState() => _BsMapCJLineState();
}

class _BsMapCJLineState extends State<BsMapCJLine> {
  // 地图组件
  final FmBaiduMap _map = FmBaiduMap();
  // 定位组件
  final FmBaiduLocation _location = FmBaiduLocation();
  // 当前定位点
  FmMapPoint _locationPoint;
  // 当前屏幕中心点
  FmMapPoint _centerPoint;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.drawer.map = _map;
    }
    // 地图
    _map.init(
      onMessage: (String method, Object config) {
        if (widget.controller != null && widget.controller.onMessage != null) {
          widget.controller.onMessage(method, config);
        }
      },
      onMapStatusChange: widget.controller?.onMapStatusChange,
      onMapStatusChangeStart: (FmMapStatusInfo info) {
        if (widget.controller != null) {
          widget.controller.onMapStatusChangeStartPro(info);
        }
        if (widget.controller != null &&
            widget.controller.onMapStatusChangeStart != null) {
          widget.controller.onMapStatusChangeStart(info);
        }
      },
      // 坐标及状态变化
      onMapStatusChangeFinish: (FmMapStatusInfo info) {
        if (!info.point.isValid()) {
          return;
        }
        // 记录当前屏幕中心点
        _centerPoint = info.point;
        if (widget.controller != null) {
          widget.controller.centerPoint = _centerPoint;
          print(_centerPoint.latitude.toString());
        }
        if (widget.controller != null) {
          widget.controller.onMapStatusChangeFinishPro(info);
        }
        if (widget.controller != null &&
            widget.controller.onMapStatusChangeFinish != null) {
          widget.controller.onMapStatusChangeFinish(info);
        }
      },
    );
    // 定位
    _location.init(onLocation: (FmBaiduLocationInfo event) {
      if (!event.point.isValid()) {
        return;
      }
      // 记录当前定位点
      if (_locationPoint == null) {
        // 定位到当前
        _map.setCenter(event.point);
      }
      _locationPoint = event.point;
      if (widget.controller != null) {
        widget.controller.locationPoint = _locationPoint;
      }
      // 设备地图定位点
      _map.setCurrentPoint(_locationPoint);
    }).then((v) {
      _location.start();
    });
  }

  @override
  void dispose() {
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          _map.view,
          Center(
            child: Text(
              "+",
              style: TextStyle(
                fontSize: fit.t(80),
                fontWeight: FontWeight.w300,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: fit.t(100.0),
            left: fit.t(20.0),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(fit.t(4))),
                ),
                height: fit.t(60),
                width: fit.t(60),
                child: Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: fit.t(40),
                ),
              ),
              onTap: () {
                // _map.setMapType(3);
                // _map.addPolygonByName(
                //   "中国",
                //   showPolygon: false,
                //   showLine: true,
                //   linewidth: 5,
                //   lineColor: 0xAA00FF88,
                //   fitScreen: true,
                //   fillColor: 0xAA00FF00,
                // );
                // _map.addPolygonByName(
                //   "北京",
                //   showPolygon: false,
                //   showLine: true,
                //   linewidth: 5,
                //   lineColor: 0xAA00FF88,
                //   fillColor: 0xAA00FF00,
                // );
                // _map.addPolygonByName("上海",
                //     showPolygon: false,
                //     showLine: true,
                //     linewidth: 5,
                //     lineColor: 0xAA00FF88,
                //     fillColor: 0xAA00FF00);
                // _map.addPolygonByName("西安",
                //     showPolygon: false,
                //     showLine: true,
                //     linewidth: 5,
                //     lineColor: 0xAA00FF88,
                //     fillColor: 0xAA00FF00);
                // _map.addPolygonByName("河南",
                //     showPolygon: false,
                //     showLine: true,
                //     linewidth: 5,
                //     lineColor: 0xAA00FF88,
                //     fillColor: 0xAA00FF00);
                // _map.addPolygonByName("河北",
                //     showPolygon: false,
                //     showLine: true,
                //     linewidth: 5,
                //     lineColor: 0xAA00FF88,
                //     fillColor: 0xAA00FF00);
               if (_locationPoint == null || !_locationPoint.isValid()) {
                 return;
               }
               _map.setCenter(_locationPoint);
              },
            ),
          )
        ],
      ),
    );
  }
}
