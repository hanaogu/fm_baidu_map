#import <Flutter/Flutter.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#include "FmBaiduMapPluginImp.h"
#include "FmBaiduLocationImpClientBaidu.h"
#include "FmBaiduMapViewFactory.h"

@interface FmBaiduMapPluginImp() <BMKLocationAuthDelegate>
@end
@implementation FmBaiduMapPluginImp{
    NSObject<FlutterPluginRegistrar>* _registrar;
    NSMutableDictionary<NSString*,FmBaiduLocationImpClient*>* _locations;
    // MapView
}
-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar{
    _registrar = registrar;
    _locations = [[NSMutableDictionary alloc] init];
    [FmBaiduMapViewFactory registerWithRegistrar:registrar];
    return self;
}

- (void)newInstanceLocation:(NSMutableDictionary *)arg result:(FlutterResult)result{
    NSString* name = [arg  valueForKey:@"name"];
//    BOOL isBaidu = [arg  valueForKey:@"isBaidu"];
    FmBaiduLocationImpClientBaidu* client = [[FmBaiduLocationImpClientBaidu alloc] initWithRegist:_registrar name:name];
    [client initInstance];
    [_locations setValue:client forKey:name];
    result(name);
}
/**
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if ( iError == BMKLocationAuthErrorSuccess ){
        NSLog(@"success=======");
    }else{
        NSLog(@"ffffff--------");
    }
}
+ (void)initSDK {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"" authDelegate:self];
}

@end
