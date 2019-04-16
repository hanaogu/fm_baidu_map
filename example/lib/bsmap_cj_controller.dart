import 'package:fm_baidu_map/fm_baidu_map.dart';

// 地图操作
class BsMapCJLineController {
  BsMapCJLineController({
    this.onMapStatusChange,
    this.onMessage,
  });
  final FmBaiduMapController drawer = FmBaiduMapController();
  // 当前定位点
  FmMapPoint locationPoint;
  // 当前屏幕中心点
  FmMapPoint centerPoint;
  // 坐标状态改变时
  FmBaiduMapStatusChange onMapStatusChange;
  // 消息
  FmBaiduMessage onMessage;

  // 橡皮线
  FmMapOverlaysLine _shirr;

  // 坐标状态改变时
  void onMapStatusChangePro(FmMapStatusInfo info) {
    if (onMapStatusChange != null) {
      onMapStatusChange(info);
    }
    if (_shirr != null) {
      _shirr.points[1] = info.point;
      _shirr.update();
    }
  }

  // 开始一个橡皮线
  Future startShirr(
    FmMapPoint start, {
    FmMapPoint end,
    color = 0xFF00FF00,
    width = 4,
  }) async {
    if (_shirr != null) {
      await _shirr.remove();
    }
    _shirr = await drawer.addOverlay(FmMapOverlaysLine(
      points: [start, end ?? centerPoint],
      dottedLine: true,
      color: color,
      width: width,
    ));
  }

  bool isShirr() {
    return _shirr != null;
  }

  // 更新橡皮线
  Future updateShirr({p1, p2, p3}) async {
    if (_shirr == null) {
      return;
    }
    if (p1 != null) {
      _shirr.points[0] = p1;
    }
    if (p2 != null) {
      _shirr.points[1] = p2;
    }
    if (p3 == null) {
      if (_shirr.points.length > 2) {
        _shirr.points.removeAt(2);
      }
    } else {
      if (_shirr.points.length > 2) {
        _shirr.points[2] = p3;
      } else {
        _shirr.points.add(p3);
      }
    }
    await _shirr.update();
  }

  Future stopShirr() async {
    if (_shirr != null) {
      await _shirr.remove();
      _shirr = null;
    }
  }
}
