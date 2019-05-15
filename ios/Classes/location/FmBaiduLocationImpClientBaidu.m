#include "FmBaiduLocationImpClientBaidu.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>
@interface FmBaiduLocationImpClientBaidu()<CLLocationManagerDelegate,BMKLocationManagerDelegate>
@end
@implementation FmBaiduLocationImpClientBaidu{
    BMKLocationManager *_locationManager;
    CLLocationManager* locationManagerPer;
    FmToolsBase* _invoker;
}

-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar name:(NSString*)name{
    _invoker = [[FmToolsBase alloc] initWithRegist:registrar name:name imp:self];
    return self;
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error:%@", [error localizedDescription]);
    if(error.code == 0)
        return;
    
    int stat = [CLLocationManager authorizationStatus];
    if(stat == kCLAuthorizationStatusNotDetermined || stat == kCLAuthorizationStatusRestricted || stat == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启或受限"
                                                        message:@"可在系统设置中开启定位服务\n(设置>隐身>定位服务)"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
//        [alert release];
    }else{
//        emit FmMapView_M::g_mapLocation->receiveLoctionError(QString::fromNSString([error localizedDescription]));
    }
}
- (NSObject*)start{
    if([CLLocationManager locationServicesEnabled]){
        locationManagerPer = [[CLLocationManager alloc] init];
        
        locationManagerPer.pausesLocationUpdatesAutomatically = NO ;
        //ios8以后需要添加如下授权，以前的可直接start（显示要使用定位的警告框,提示你是否允许使用定位）
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
            //[locationManager requestWhenInUseAuthorization]; //使用时授权(只用这个的话后台时不能定位)
            [locationManagerPer requestWhenInUseAuthorization]; // 永久授权（前台后台都能定位）
        }
    }
    [_locationManager startUpdatingLocation];
    return @(true);
}
- (NSObject*)stop{
    [_locationManager stopUpdatingLocation];
    return @(true);
}
-(NSObject*)isStarted{
    BOOL isStartes = [self locating];
    return @(isStartes);
}
- (BOOL)locating{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        return true;
    }
    return false;
}
- (void)initInstance {
    _locationManager = [[BMKLocationManager alloc] init];
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    _locationManager.delegate = self;
}
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    NSLog(@"serial loc error = %@", error);
}


- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(location.location.coordinate.latitude),@"latitude",
                          @(location.location.coordinate.longitude),@"longitude",
                          nil];
//    [dict setValue:location.location.coordinate.latitude forKey:@"latitude"];
//    [dict setValue:location.location.coordinate.longitude forKey:@"longitude"];
    //    HashMap<String, Object> jsonObject = new HashMap();
//    jsonObject.put("coordType", "Baidu");
//    jsonObject.put("time", System.currentTimeMillis());
//    jsonObject.put("speed", bdLocation.getSpeed());
//    jsonObject.put("altitude", bdLocation.getAltitude());
//    jsonObject.put("latitude", bdLocation.getLatitude());
//    jsonObject.put("longitude", bdLocation.getLongitude());
//    jsonObject.put("bearing", bdLocation.getDirection());
    [_invoker invokeMethod:@"onLocation" arg:dict];
}

+ (void)initSDK :(NSString*)sdk{
    //    R8lzapOh0YZDfE5x6OAtIzdGWpUS9nBx
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:sdk authDelegate:self];
}

-(NSObject*)dispose{
    [_locationManager stopUpdatingLocation];
    [_invoker dispose];
    _invoker = nil;
    _locationManager = nil;
    return nil;
}

@end
