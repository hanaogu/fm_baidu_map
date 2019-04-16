import 'package:fm_baidu_map/fm_baidu_map.dart';
import '../bsmap_cj_controller.dart';
import './base.dart';

class BsDevMapInfoLine extends BsDevMapInfo<FmMapOverlaysLine> {
  BsDevMapInfoLine(
    BsMapCJLineController controller, {
    overlay,
    config,
  }) : super(controller, overlay: overlay, config: config);

  // 创建一条线
  static Future<BsDevMapInfoLine> create(
    List<FmMapPoint> points,
    BsMapCJLineController controller, {
    Map config,
  }) async {
    var overlay = await controller.drawer.addOverlay(
      FmMapOverlaysLine(
        layer: "line",
        zIndex: 2,
        color: 0xFFFF0000,
        points: points,
      ),
    );
    BsDevMapInfoLine item = BsDevMapInfoLine(
      controller,
      overlay: overlay,
      config: config,
    );
    return item;
  }
}
