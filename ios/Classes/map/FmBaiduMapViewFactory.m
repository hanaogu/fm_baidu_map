
#include "FmBaiduMapViewFactory.h"
#include "FmBaiduMapView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface FmBaiduMapViewFactory()<FlutterPlatformViewFactory,BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类
@end
@implementation FmBaiduMapViewFactory {
    NSObject<FlutterPluginRegistrar>* _registrar;
//    FlutterMethodChannel* _channel;
    NSMutableDictionary<NSString*,FmBaiduMapView*>* _list;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FmBaiduMapViewFactory* mapFactory = [[FmBaiduMapViewFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:mapFactory withId:@"FmBaiduMapView"];
}
//- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//    self = [super init];
//    if (self) {
//        _registrar = registrar;
//    }
//    return self;
//}
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    _list = [[NSMutableDictionary alloc] init];
    _mapManager = [[BMKMapManager alloc] init];
    NSString* appKey = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"BaiduAppKey"];
    BOOL result = [_mapManager start:appKey generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }else{
        NSLog(@"启动成功！！！！");
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

-(FmBaiduMapView*) createView:(NSString*) name{
    FmBaiduMapView* view = [_list objectForKey:name];
    if ( !view ){
        view = [[[FmBaiduMapView alloc] init] initWithRegistrar:_registrar name:name factory:self];
        [_list setObject:view forKey:name];
    }
    return  view;
}
-(void)remove:(NSString*) name{
    FmBaiduMapView* view = [_list objectForKey:name];
    if ( view == nil ){
        NSLog(@"dispose view empty:%@",name);
        return;
    }
    [view dispose];
    [_list removeObjectForKey:name];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [self createView:args[@"name"]];
}
@end
