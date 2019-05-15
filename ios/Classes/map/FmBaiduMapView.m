#include "FmBaiduMapView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#include "FmToolsBase.h"
#include "FmOverlay.h"
@interface FmBaiduMapView()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView * mapView;
@end

@implementation FmBaiduMapView{
    NSObject<FlutterPluginRegistrar> * _registrar;
    FmBaiduMapViewFactory* _factory;
    NSString* _name;
    FmToolsBase* _invoker;
    NSMutableDictionary<NSString*,FmOverlayManager*>* _overlays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
//    [_mapView sizeToFit];
    
    [_mapView setShowsUserLocation:YES];

    //设置mapView的代理
    _mapView.delegate = self;
    //将mapView添加到当前视图中
    [self setView: _mapView];
//    [super.view addSubview:_mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void) onMapStatus:(BMKMapView *)mapView name:(NSString*)name{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(mapView.centerCoordinate.latitude),@"latitude",
                          @(mapView.centerCoordinate.longitude),@"longitude",
                          @(mapView.zoomLevel),@"zoom",
                          @(mapView.overlooking+0.0),@"overlook",
                          @(mapView.rotation+0.0),@"rotate",
                          nil];
    [_invoker invokeMethod:name arg:dict];
}
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [ self onMapStatus:mapView name:@"onMapStatusChangeStart" ];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [ self onMapStatus:mapView name:@"onMapStatusChangeFinish" ];
}
-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    [ self onMapStatus:mapView name:@"onMapStatusChange" ];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    [_factory remove: _name];
    _invoker = nil;
    _mapView = nil;
    _overlays = nil;
    _factory = nil;
}

- (id)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar name:(NSString*)name factory:(FmBaiduMapViewFactory*)factory {
    _registrar = registrar;
    _factory = factory;
    _name = name;
//    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
//    //设置mapView的代理
//    _mapView.delegate = self;
//    [super.view addSubview:_mapView];
    _invoker = [[[FmToolsBase alloc] init] initWithRegist:registrar name:name imp:self];
    _overlays = [[NSMutableDictionary alloc] init];
    return  self;
}
-(BOOL)setStatus:(CLLocationCoordinate2D)latlng andOverlook:(float)overlook andRotate:(float)rotate andZoom:(float)zoom andPoint:(CGPoint)point{
    if (!_mapView) {return NO;}
    BMKMapStatus* status = [[BMKMapStatus alloc] init];
    if (latlng.latitude >= -90 && latlng.latitude <= 90 && latlng.longitude >= -180 && latlng.longitude <= 180) {
        status.targetGeoPt = latlng;
    }
    if (overlook >= -45 && overlook <= 0) {
        status.fOverlooking = overlook;
    }
    if (rotate >= -180 && rotate <= 180) {
        status.fRotation = rotate;
    }
    if (zoom >= 1 && zoom <= 21) {
        status.fLevel = zoom;
    }
    if (point.x >= 0 && point.y >= 0) {
        status.targetScreenPt = point;
    }
    [_mapView setMapStatus:status withAnimation:YES];
    return  YES;
}
-(void)setCurrentPoint:(NSMutableDictionary *)arg result:(FlutterResult)result{
    BMKUserLocation* userLocation = [[BMKUserLocation alloc]init];
    BMKMapStatus* status = [_mapView getMapStatus];
    double latitude = [[arg valueForKey:@"latitude"] doubleValue];
    double longitude = [[arg valueForKey:@"longitude"] doubleValue];
    double direction = [[arg valueForKey:@"dicrecton"] doubleValue];
    double radius = [[arg valueForKey:@"radius"] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation* currentLocation = [[CLLocation alloc]initWithCoordinate:coordinate altitude:0 horizontalAccuracy:radius verticalAccuracy:0 course:direction speed:0 timestamp:[NSDate date]];
    [userLocation setValue:currentLocation forKey:@"location"];
    [_mapView updateLocationData:userLocation];
}
-(void)setCenter:(NSMutableDictionary *)arg result:(FlutterResult)result{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
           [[arg valueForKey:@"latitude"] doubleValue],
           [[arg valueForKey:@"longitude"] doubleValue]
    );
    CGPoint point;
    point.x = -1;
    [self setStatus:coordinate
        andOverlook:[[arg valueForKey:@"overlook"] floatValue]
        andRotate:[[arg valueForKey:@"rotate"] floatValue]
        andZoom:[[arg valueForKey:@"zoom"] floatValue]
        andPoint:point
     ];
    result(@"");
}
-(void)addOverlays:(NSMutableDictionary *)arg result:(FlutterResult)result{
    NSMutableArray* arr = [arg objectForKey:@"objects"];
    for(NSMutableDictionary* item in arr ){
        [self createOptions:item];
    }
    result(@(true));
}
///**
// * 创建一个标记配置
// * @param obj
// * @param addToMap 是否同时加到地图
// * @return
// */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay conformsToProtocol:@protocol(FmOverlayItemBase)]) {
        NSObject<FmOverlayItemBase>* obj = overlay;
        return (BMKAnnotationView*) [obj view];
    }

//    if ([overlay isKindOfClass:[BMKCircle class]]){
//        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
////        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
////        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
////        circleView.lineWidth = 10.0;
//
//        return circleView;
//    }
    return nil;
}
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation conformsToProtocol:@protocol(FmOverlayItemBase)]) {
        NSObject<FmOverlayItemBase>* obj = annotation;
        return (BMKAnnotationView*) [obj view];
    }
    return  nil;
}

-(void)createOptions:(NSMutableDictionary *)arg{
    NSString* type = [arg objectForKey:@"type"];
    NSString* layer = [arg objectForKey:@"layer"];
    layer = layer?layer:@"0";
    FmOverlayManager* mg = [_overlays objectForKey:layer];
    if ( !mg ){
        mg =[ [FmOverlayManager alloc] init];
        [_overlays setObject:mg forKey:layer];
    }
    
    if ( [type isEqualToString:@"circle"] ){
//        CLLocationCoordinate2D coor;
//        coor.latitude = [[arg objectForKey:@"latitude"] doubleValue];
//        coor.longitude = [[arg objectForKey:@"longitude"] doubleValue];
//        view = [BMKCircle circleWithCenterCoordinate:coor radius:[[arg objectForKey:@"radius"] intValue]];
    }else if ( [type isEqualToString:@"line"] ){
        NSMutableArray* points = [arg objectForKey:@"points"];
        NSUInteger size = [points count];
        CLLocationCoordinate2D coor[size];
        for( NSUInteger i=0; i<size; ++i ){
            NSMutableDictionary* item = [points objectAtIndex:i];
            coor[i].latitude = [[item objectForKey:@"latitude"] doubleValue];
            coor[i].longitude = [[item objectForKey:@"longitude"] doubleValue];
        }
        FmPolyline* item = [[FmPolyline alloc] init];
        [item setPolylineWithCoordinates:coor count:size];
        item.registrar = _registrar;
        item.config = arg;
        item.name = [arg objectForKey:@"name"];
        item.layer = [arg objectForKey:@"layer"];
        item.mapView = _mapView;
        [mg add:[arg objectForKey:@"id"] overlay:item];
        [_mapView addOverlay:item];
    }else if ( [type isEqualToString:@"mark"] ){
        FmMarkerAnnotation* item = [[FmMarkerAnnotation alloc]init];
        item.coordinate = CLLocationCoordinate2DMake([[arg objectForKey:@"latitude"] doubleValue], [[arg objectForKey:@"longitude"] doubleValue]);
        if ([arg objectForKey:@"title"]) {
            item.title = [[arg objectForKey:@"title"] stringValue];
        }
        item.registrar = _registrar;
        item.config = arg;
        item.name = [arg objectForKey:@"name"];
        item.layer = [arg objectForKey:@"layer"];
        item.mapView = _mapView;
        [mg add:[arg objectForKey:@"id"] overlay:item];
        [_mapView addAnnotation:item];
    }
}

-(void)updateOverlays:(NSMutableDictionary *)arg result:(FlutterResult)result{
    NSMutableArray* arr = [arg objectForKey:@"objects"];
    for(NSMutableDictionary* item in arr ){
        NSString* name = [item objectForKey:@"id"];
        NSString* layer = [item objectForKey:@"layer"];
        FmOverlayManager* mg = [_overlays objectForKey:layer];
        [mg remove:name];
        [self createOptions:item];
    }
    result(@(true));
}

-(void)setOverlaysVisible:(NSMutableDictionary *)arg result:(FlutterResult)result{
    NSString* name = [arg objectForKey:@"id"];
    NSString* layer = [arg objectForKey:@"layer"];
    BOOL visible = [[arg objectForKey:@"visible"] boolValue];
    if ( layer ){
       FmOverlayManager* mg = [_overlays objectForKey:layer];
        if ( mg ){
            if ( name ){
                [mg setVisible:name visible:visible];
            }else{
                [mg setVisibleAll:visible];
            }
        }
    }else if (name){
        for (NSString*key  in  _overlays) {
            if ( [[_overlays objectForKey:key] setVisible:name visible:visible] ){
                break;
            }
        }
    }
    result(@(true));
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view.annotation conformsToProtocol:@protocol(FmOverlayItemBase)]) {
        NSObject<FmOverlayItemBase>* obj = (NSObject<FmOverlayItemBase>*)view.annotation;
        [_invoker invokeMethod:@"click_overlay" arg:obj.config];
        NSLog(@"aaaaaaaaaa");
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView{
    if ([overlayView.overlay conformsToProtocol:@protocol(FmOverlayItemBase)]) {
        NSObject<FmOverlayItemBase>* obj = (NSObject<FmOverlayItemBase>*)overlayView.overlay;
        [_invoker invokeMethod:@"click_overlay" arg:obj.config];
        NSLog(@"bbbbbbbbbbbbb");
    }
}

-(NSObject*)dispose{
    [_invoker dispose];
    return nil;
}
@end
