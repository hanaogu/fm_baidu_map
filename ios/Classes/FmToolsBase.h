#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
@interface FmToolsBase: NSObject

-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar name:(NSString*)name imp:(id)imp;

+(BOOL) onMethodCall:(id)imp method:(NSString*)method arg:(NSObject*)arg result:(FlutterResult)result;

-(void) invokeMethod:(NSString*) method arg:(NSObject*)arg;

-(void)dispose;
                     
@end
