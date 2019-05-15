#include "FmToolsBase.h"
@implementation FmToolsBase{
    NSObject<FlutterPluginRegistrar>* _registrar;
    FlutterMethodChannel* _channel;
    NSString* _name;
    id _imp;
}

-(id)initWithRegist:(NSObject<FlutterPluginRegistrar>*)registrar name:(NSString*)name imp:(id)imp;{
    _registrar = registrar;
    _name = name;
    _imp = imp;
    _channel = [FlutterMethodChannel methodChannelWithName:name binaryMessenger:[_registrar messenger]];
    
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ( [FmToolsBase onMethodCall:_imp method:call.method arg:call.arguments result:result] == YES){
//             result(@true);
             return;
         }
         result(FlutterMethodNotImplemented);
     }];
    return self;
}

// 反射方法
+(BOOL) onMethodCall:(id)imp method:(NSString*)method arg:(NSObject*)arg result:(FlutterResult)result{
    @try {
        if(arg != nil){
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:result:",method]);
            if (![imp respondsToSelector:selector] ){
                NSLog(@"runMethod no this method: %@",method);
                return NO;
            }
            [imp performSelector:selector withObject:arg withObject:result];
        }else{
            SEL selector = NSSelectorFromString(method);
            if (![imp respondsToSelector:selector] ){
                NSLog(@"runMethod no this method: %@",method);
                return NO;
            }
            NSObject* r = [imp performSelector:selector];
            if(r != nil){
                result(r);
            }
        }
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return NO;
    }
}
-(void) invokeMethod:(NSString*) method arg:(NSObject*)arg{
    [_channel invokeMethod:method arguments:arg];
}
-(void)dispose{
    if ( _channel != nil ) {
        [_channel setMethodCallHandler: nil];
        _channel = nil;
    }
}
@end
