import 'package:fm_baidu_map/fm_baidu_map.dart';
import 'package:fm_fit/fm_fit.dart';
import '../bsmap_cj_controller.dart';
import './base.dart';
import './line.dart';

// 杆元素
class BsDevMapInfoPole extends BsDevMapInfo<FmMapOverlaysMark> {
  BsDevMapInfoPole(
    BsMapCJLineController controller, {
    overlay,
    config,
    this.line,
  }) : super(controller, overlay: overlay, config: config);
  // 前导线
  BsDevMapInfoLine line;
  // 前杆
  BsDevMapInfoPole _before;
  // 后杆
  BsDevMapInfoPole _after;

  // 获取点
  @override
  FmMapPoint getPoint() {
    return overlay?.point;
  }

  // 选中
  Future select(bool sel) async {
    if (overlay == null) {
      return;
    }
    overlay.icon = sel ? "circle4.png" : "circle3.png";
    await overlay.update();
  }

  // 创建一个杆塔
  static Future<BsDevMapInfoPole> create(
    FmMapPoint point,
    BsMapCJLineController controller, {
    Map config,
  }) async {
    var overlay = await controller.drawer.addOverlay(FmMapOverlaysMark(
      point: controller.centerPoint,
      layer: "pole",
      icon: "circle3.png",
      text: config != null ? config["number"] : null,
      textSize: fit.t(54).ceil(),
      textColor: 0xFFFFFFFF,
      zIndex: 100,
    ));
    BsDevMapInfoPole item = BsDevMapInfoPole(
      controller,
      overlay: overlay,
      config: config,
    );
    return item;
  }

  // 杆与前杆进行关联
  Future linkBefore(BsDevMapInfoPole p1, {Map config, once: false}) async {
    // 处理导线
    if (line == null) {
      line = await BsDevMapInfoLine.create(
        [p1.getPoint(), getPoint()],
        controller,
        config: config,
      );
    } else {
      line.overlay.points[0] = p1.getPoint();
      await line.overlay.update();
    }
    if (_before != null && !once) {
      await p1.linkBefore(_before, once: true);
    }
    _before = p1;
    // 处理后杆
    if (p1._after != null && !once) {
      p1._after.linkBefore(this, once: true);
    }
    p1._after = this;
  }

  // 移杆
  Future move(FmMapPoint pt) async {
    overlay.point = pt;
    await overlay.update();
    // 线
    if (line != null) {
      line.overlay.points[1] = pt;
      await line.overlay.update();
    }
    // 处理后杆
    if (_after != null && _after.line != null) {
      _after.line.overlay.points[0] = pt;
      await _after.line.overlay.update();
    }
  }

  // 删除本杆
  Future remove() async {
    // 更新关系
    if (_before != null) {
      _before._after = null;
    }
    if (_after != null) {
      _after._before = null;
    }
    if (_after != null && _before != null) {
      await _after.linkBefore(_before);
    }
    // 删除标注
    if (overlay != null) {
      await overlay.remove();
      overlay = null;
    }
    // 删除线
    if (line != null) {
      await line.overlay.remove();
      line = null;
    }
  }
}
