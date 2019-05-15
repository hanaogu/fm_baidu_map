#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "FmToolsBase.h"
@interface FmBaiduLocationImpClient : NSObject

-(void) start:(NSMutableDictionary*)arg result:(FlutterResult)result;
-(void) stop:(NSMutableDictionary*)arg result:(FlutterResult)result;
-(BOOL) isStarted:(NSMutableDictionary*)arg result:(FlutterResult)result;

@end
