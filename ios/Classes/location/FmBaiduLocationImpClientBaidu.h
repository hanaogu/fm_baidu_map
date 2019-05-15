#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "FmBaiduLocationImpClient.h"
@interface FmBaiduLocationImpClientBaidu: NSObject
-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar name:(NSString*)name;

-(NSObject*) start;

-(NSObject*) stop;

-(NSObject*) isStarted;

-(void) initInstance;

-(NSObject*)dispose;

+(void)initSDK:(NSString*)sdk;
@end
