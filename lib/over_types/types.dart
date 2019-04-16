// 坐标点
class FmMapPoint {
  FmMapPoint({this.latitude, this.longitude});
  // 经度
  double latitude;
  // 纬度
  double longitude;
  // 是否有效
  bool isValid() {
    if (latitude == null || longitude == null) {
      return false;
    }
    if (latitude < 1 || latitude > 1000 || longitude < 1 || longitude > 1000) {
      return false;
    }
    return true;
  }

  // 数组转Map
  static List<Map> toList(List<FmMapPoint> list) {
    List<Map> m = [];
    list.forEach((it) {
      m.add({"latitude": it.latitude, "longitude": it.longitude});
    });
    return m;
  }
}

// 定位信息
class FmBaiduLocationInfo {
  // Baidu
  String coordType;
  int time;
  // 速度
  double speed;
  // 海拔
  double altitude;
  // 经纬度
  FmMapPoint point;
  // 方向
  double bearing;

  /// 从map初始化
  void fronMap(Map m) {
    coordType = m["coordType"];
    time = m["time"];
    speed = m["speed"];
    point = FmMapPoint();
    // 经度
    point.latitude = m["latitude"];
    // 纬度
    point.longitude = m["longitude"];
    // 海拔
    altitude = m["altitude"];
    bearing = m["bearing"];
  }

  /// 从map创建
  static FmBaiduLocationInfo create(Map m) {
    return FmBaiduLocationInfo()..fronMap(m);
  }
}

// 地图状态信息
class FmMapStatusInfo {
  // 坐标点
  FmMapPoint point;
  // 缩放
  double zoom;
  // 俯瞰
  double overlook;
  // 转角
  double rotate;
  // 屏幕坐标
  int screenX;
  int screenY;

  // 从map初始化
  void fromMap(Map m) {
    // 坐标点
    point = FmMapPoint();
    // 经度
    point.latitude = m["latitude"];
    // 纬度
    point.longitude = m["longitude"];
    zoom = m["zoom"];
    overlook = m["overlook"];
    rotate = m["rotate"];
    // 屏幕坐标
    screenX = m["screenX"];
    screenY = m["screenY"];
  }

  // 创建地图状态信息
  static FmMapStatusInfo create(Map m) {
    return FmMapStatusInfo()..fromMap(m);
  }
}
