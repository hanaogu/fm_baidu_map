#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@protocol FmOverlayItemBase<NSObject>

// 配置
@property(strong,nonatomic) NSDictionary* config;
// 唯一值，id
@property(strong,nonatomic) NSString* name;
// 图层
@property(strong,nonatomic) NSString* layer;

@property (nonatomic, strong) BMKMapView * mapView;

@property (nonatomic, strong) NSObject<FlutterPluginRegistrar>*registrar;

// 获取视图
-(UIView*)view;
// 删除
-(void)remove;
// 设置隐藏
-(void)setVisible:(BOOL)visible;

@end

// 线段
@interface FmPolyline : BMKPolyline<FmOverlayItemBase>
// 获取视图
-(UIView*)view;

@end

// 标注
@interface FmMarkerAnnotation : BMKPointAnnotation<FmOverlayItemBase>
// 获取视图
-(UIView*)view;
-(void)remove;

@end

// 文字
@interface FmTextAnnotation : BMKPointAnnotation<FmOverlayItemBase>
// 获取视图
-(UIView*)view;
-(void)remove;
 
@end

@interface FmOverlayManager : NSObject
-(id) add:(NSString*)name overlay:(NSObject<FmOverlayItemBase>*) overlay;
-(BOOL)remove:(NSString*)name;
-(void)removeAll;
-(BOOL)setVisible:(NSString*)name visible:(BOOL)visible;
-(void)setVisibleAll:(BOOL)visible;
@end
