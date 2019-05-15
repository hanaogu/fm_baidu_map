#import "FmBaiduMapPlugin.h"
#import "./imp/FmBaiduMapPluginImp.h"
#import "FmToolsBase.h"
@implementation FmBaiduMapPlugin{
}

static FmBaiduMapPluginImp* _imp;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fm_baidu_map"
            binaryMessenger:[registrar messenger]];
  FmBaiduMapPlugin* instance = [[FmBaiduMapPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  _imp = [[FmBaiduMapPluginImp alloc] initWithRegist:registrar];
    [FmBaiduMapPluginImp initSDK];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ( [FmToolsBase onMethodCall:_imp method:call.method arg:call.arguments result:result]){
        return;
    }
    result(FlutterMethodNotImplemented);
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
}

@end
