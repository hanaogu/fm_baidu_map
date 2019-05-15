#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
@interface FmBaiduMapViewFactory : NSObject
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
-(void)remove:(NSString*) name;
@end
