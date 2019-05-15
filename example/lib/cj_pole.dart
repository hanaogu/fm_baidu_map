import 'package:fm_baidu_map/fm_baidu_map.dart';
import './cj_base.dart';
import './bsmap_cj_controller.dart';
import './cjtypes/pole.dart';

class BsCJPole extends BsCJBase {
  BsCJPole(this.controller);
  // 操控地图
  BsMapCJLineController controller;
  // 已绘制的杆
  List<BsDevMapInfoPole> _poles = [];
  // 插入方向
  BsCJBaseInsertDirect _direct = BsCJBaseInsertDirect.none;

  // 当前选中的
  int _selected = -1;
  int _currentIndex = -1;
  Future setCurrent(int i) async {
    _currentIndex = i;
    if (i == -1) {
      await controller.stopShirr();
      return;
    }
    // 正常插
    if (_direct == BsCJBaseInsertDirect.none) {
      if ((i - 1) < 0 || (i + 1) > _poles.length - 1) {
        if (!controller.isShirr()) {
          await controller.startShirr(_poles[i].overlay.point);
        } else {
          await controller.updateShirr(p1: _poles[i].overlay.point);
        }
        return;
      }
      // 更新2杆之间
      await controller.updateShirr(
        p1: _poles[i - 1].overlay.point,
        p3: _poles[i + 1].overlay.point,
      );
      return;
    }
    // 前插
    if (_direct == BsCJBaseInsertDirect.before) {
      if ((i - 1) < 0) {
        await controller.updateShirr(p1: _poles[i].overlay.point);
        return;
      }
      // 更新2杆之间
      await controller.updateShirr(
        p1: _poles[i - 1].overlay.point,
        p3: _poles[i].overlay.point,
      );
      return;
    }
    // 后插
    if (_direct == BsCJBaseInsertDirect.after) {
      if ((i + 1) > _poles.length - 1) {
        await controller.updateShirr(p1: _poles[i].overlay.point);
        return;
      }
      // 更新2杆之间
      await controller.updateShirr(
        p1: _poles[i].overlay.point,
        p3: _poles[i + 1].overlay.point,
      );
      return;
    }
  }

  // 设置当前插入方向
  @override
  Future setInstertDirect(BsCJBaseInsertDirect direct) async {
    _direct = direct;
    await setCurrent(_currentIndex);
  }

  @override
  Future remove(int index) async {
    if (index == -1) {
      return;
    }
    // 当前选中的不选了
    if (_selected != index && _selected != -1) {
      await unselect();
    }
    _selected = -1;
    await _poles[index].remove();
    _poles.removeAt(index);
    _direct = BsCJBaseInsertDirect.none;
    await setCurrent(_poles.length - 1);
  }

  @override
  void onClick(Map config) async {
    if (config["type"] == "line") {
      return;
    }
    int i = _poles.indexWhere((it) {
      return it.overlay.id == config["id"];
    });
    if (i == -1) {
      return;
    }
    await unselect();
    await select(i);
  }

  // 定位第几个标注
  @override
  Future location(int index) async {
    if (index < 0 ||
        index >= _poles.length ||
        _poles[index].overlay == null ||
        !_poles[index].overlay.point.isValid()) {
      return;
    }
    await controller.drawer.setCenter(_poles[index].overlay.point);
  }

  // 不选择
  Future unselect() async {
    // 先取消选择
    if (_selected != -1) {
      await _poles[_selected].select(false);
    }
    _selected = -1;
  }

  // 选中第几个标注
  @override
  Future select(int index) async {
    if (index < 0 || index >= _poles.length) {
      return;
    }
    // 再设置选择
    _selected = index;
    await _poles[index].select(true);
    // 处理橡皮线
    setCurrent(index);
  }

  // 修改某个
  @override
  Future modify(int index, {FmMapPoint pt, Map config}) async {
    if (index < 0 || index >= _poles.length) {
      return;
    }
    if (pt != null) {
      await _poles[index].move(pt);
      if (index == 0 || index == _poles.length - 1) {
        await controller.updateShirr(p1: pt);
      }
    }
    if (config != null) {
      if (_poles[index].config == null) {
        _poles[index].config = config;
      } else {
        _poles[index].config.addAll(config);
      }
    }
  }

  @override
  int selectedIndex() {
    return _selected;
  }

  // 获取数量
  @override
  int count() {
    return _poles.length;
  }

  @override
  Future sure({Map config}) async {
    // 如果没有选择，则绘制
    if (_selected == -1) {
      await draw(controller.centerPoint, config: config);
      return;
    }
    if (_direct == BsCJBaseInsertDirect.none) {
      await modify(selectedIndex(), pt: controller.centerPoint);
    } else {
      await draw(controller.centerPoint,
          config: config ?? {"number": nextNumber()});
    }
  }

  BsDevMapInfoPole getAt(int index) {
    return _poles[index];
  }

  // 获取一个新编号
  String nextNumber() {
    return "${_poles.length + 1}";
  }

  // 取消选择
  @override
  Future cancelSelect() async {
    if (_selected != -1) {
      _poles[_selected].select(false);
    }
    _direct = BsCJBaseInsertDirect.none;
    _selected = -1;
    setCurrent(_poles.length - 1);
  }

  // 绘制一个点状物
  @override
  Future<int> draw(FmMapPoint pt, {Map config}) async {
    // 创建一个杆
    var item = await BsDevMapInfoPole.create(pt, controller, config: config);
    // 正常插
    if (_direct == BsCJBaseInsertDirect.none || _poles.length < 1) {
      if (_poles.length != 0) {
        item.linkBefore(_poles.last);
      }
      _poles.add(item);
      await unselect();
      await setCurrent(_poles.length - 1);
      return _poles.length - 1;
    }
    int currentSelected = _selected;
    await unselect();
    int index = 0;
    if (_direct == BsCJBaseInsertDirect.before) {
      // 前插
      await _poles[currentSelected].linkBefore(item);
      _poles.insert(currentSelected, item);
      index = currentSelected;
    } else {
      // 后插
      await item.linkBefore(_poles[currentSelected]);
      _poles.insert(currentSelected + 1, item);
      index = currentSelected + 1;
    }
    // 设置当前插的杆选中
    await select(index);
    await setCurrent(index);
    return index;
  }
}
