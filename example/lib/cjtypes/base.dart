import 'package:fm_baidu_map/fm_baidu_map.dart';
import '../bsmap_cj_controller.dart';

// 设备基类
abstract class BsDevMapInfo<T extends FmMapOverlays> {
  BsDevMapInfo(this.controller, {this.overlay, this.config});
  // 地图元素
  T overlay;
  // 内部数据
  Map config;
  // 地图操控
  BsMapCJLineController controller;
  // 获取设备点
  FmMapPoint getPoint() {
    return null;
  }
  // 绘制
  // Future draw({Map cfg});
}
