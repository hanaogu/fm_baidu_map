import 'package:fm_baidu_map/fm_baidu_map.dart';

// 插入方向
enum BsCJBaseInsertDirect { none, before, after }

abstract class BsCJBase {
  // 绘制一个点状物
  Future<int> draw(FmMapPoint pt, {Map config});

  // 修改某个
  Future modify(int index, {FmMapPoint pt, Map config});

  // 点击标记事件
  void onClick(Map config);

  // 删除指定标注
  Future remove(int index);

  // 定位第几个标注
  Future location(int index);

  // 选中第几个标注
  Future select(int index);

  // 取消选择
  Future cancelSelect();

  // 获取选中序号
  int selectedIndex();

  // 获取数量
  int count();

  // 设置当前插入方向
  Future setInstertDirect(BsCJBaseInsertDirect direct);

  // 修改，前插、后插等确定
  Future sure({Map config});

  // 获取一个新编号
  String nextNumber();
}
