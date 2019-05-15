#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface FmBaiduMapPluginImp: NSObject

-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar;

-(void)newInstanceLocation:(NSMutableDictionary*)arg result:(FlutterResult)result;
+(void)initSDK;
@end
