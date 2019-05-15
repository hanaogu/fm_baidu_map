#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "FmBaiduMapViewFactory.h"
@interface FmBaiduMapView : UIViewController<FlutterPlatformView>
-(id)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar name:(NSString*)name factory:(FmBaiduMapViewFactory*)factory;
-(NSObject*)dispose;
@end
