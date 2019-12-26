//
//  MapViewObject.m
//  Runner
//
//  Created by 李运洋 on 2019/12/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "MapViewObject.h"
#import <Mapbox/Mapbox.h>
#import "MapViewLineModel.h"
#import "MapBoxAnnotationView.h"
#import "MapSymbolModel.h"
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"
static NSString *const MapBoxAnnotationViewCellId = @"MapBoxAnnotationViewCellId";
@interface MapViewObject ()<MGLMapViewDelegate>
/** channel*/
@property (nonatomic, strong)  FlutterMethodChannel  *channel;
/** 地图*/
@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MGLPolyline *blueLine;//蓝色线段
/** 大头针数组*/
@property (nonatomic, copy) NSMutableArray *annotationsArray;
/** <#注释#>*/
@property (nonatomic, strong)  NSMutableArray  *symbolPointsArr;

///////数据相关
/** 缩放比例*/
@property (nonatomic, assign) int  zoomLevel;
/** 线的颜色*/
@property (nonatomic, strong)  UIColor  *lineColor;
/** 显得宽度*/
@property (nonatomic, assign) CGFloat  lineWidth;
/** 线的透明度*/
@property (nonatomic, assign) CGFloat  lineOpacity;

/** <#注释#>*/
@property (nonatomic, copy)  FlutterResult resultCallBack;

/** 是否显示 大头针编号*/
@property (nonatomic, assign) bool  isShowSymbolIndex;
/** 是否显示 用户信息*/
@property (nonatomic, assign) bool  isShowUserLocation;
/** <#注释#>*/
@property (nonatomic, strong)  NSArray  *customLocaArr;

@end

@implementation MapViewObject
{
    CGRect _frame;
    int64_t _viewId;
    id _args;
   
}

- (id)initWithFrame:(CGRect)frame
  viewId:(int64_t)viewId
    args:(id)args
messager:(NSObject<FlutterBinaryMessenger>*)messenger
{
    if (self = [super init])
    {
        _frame = frame;
        _viewId = viewId;
        _args = args;
        
        self.customLocaArr = [[args objectForKey:@"initialCameraPosition"] valueForKey:@"target"];
        self.zoomLevel = [[[args objectForKey:@"initialCameraPosition"] valueForKey:@"zoom"] intValue];
        self.isShowSymbolIndex =  [[[args objectForKey:@"options"] valueForKey:@"symbolShowIndex"] intValue]==1;
        self.isShowUserLocation = [[[args objectForKey:@"options"] valueForKey:@"myLocationEnabled"] intValue]==1;
        
        //设置地图的 frame 和 地图个性化样式
       _mapView = [[MGLMapView alloc] initWithFrame:_frame styleURL:[NSURL URLWithString:@"mapbox://styles/mapbox/streets-v11"]];
       _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       //设置地图默认显示的地点和缩放等级
     //  [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.customLocaArr.firstObject doubleValue], [self.customLocaArr.lastObject doubleValue]) zoomLevel:self.zoomLevel animated:YES];
       //显示用户位置
       _mapView.showsUserLocation  = self.isShowUserLocation;
       //定位模式
        if (self.isShowUserLocation) {
            _mapView.userTrackingMode   = MGLUserTrackingModeFollow;
        }else{
            _mapView.userTrackingMode   = MGLUserTrackingModeNone;
        }
       
        _mapView.zoomLevel = self.zoomLevel;
       //是否倾斜地图
       _mapView.pitchEnabled       = YES;
       //是否旋转地图
       _mapView.rotateEnabled      = NO;
       //代理
       _mapView.delegate           = self;
        
         NSString* channelName = [NSString stringWithFormat:@"plugins.flutter.io/mapbox_maps_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        __weak __typeof__(self) weakSelf = self;

        [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

- (UIView *)view{
    
    return self.mapView;
     
}

#pragma mark -- Flutter 交互监听
-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
   
    
    //地图初始化完成
    if ([[call method] isEqualToString:@"map#waitForMap"]) {
        
        self.resultCallBack = result;
        
    }
    
    //添加单个大头针
    if ([[call method] isEqualToString:@"symbol#add"]) {
        
        MapSymbolModel *model = [MapSymbolModel mj_objectWithKeyValues:[call.arguments valueForKey:@"options"]];
        
        [self.symbolPointsArr addObject:model];
        
         [self setSymbolWithArr:self.symbolPointsArr.copy];
        
        
    }
    //选中
       if ([[call method] isEqualToString:@"symbol#select"]) {
           
           MapSymbolModel *model = [MapSymbolModel mj_objectWithKeyValues:[call.arguments valueForKey:@"options"]];
           
           for (int i = 0; i<self.symbolPointsArr.count; i++) {
               MapSymbolModel *selectModel = self.symbolPointsArr[i];
               
               if ([model.poiId isEqualToString:selectModel.poiId]) {
                    [self.mapView setSelectedAnnotations:@[[self.annotationsArray objectAtIndex:i]]];
               }
               
           }
               
       }
    //添加大头针数组
       if ([[call method] isEqualToString:@"symbol#addList"]) {
           
           [self setSymbolWithArr:[MapSymbolModel mj_objectArrayWithKeyValuesArray:[call.arguments valueForKey:@"optionsList"]]];
           
       }
    //划线
      if ([[call method] isEqualToString:@"line#add"]) {
          
         MapViewLineModel *model = [MapViewLineModel mj_objectWithKeyValues:[call.arguments valueForKey:@"options"]];
          
          [self drwnLineActionWithModel:model];
          
      }
       
    
}


/// 画线
/// @param model 坐标model
- (void)drwnLineActionWithModel:(MapViewLineModel *)model{
    
       //添加要划线的点
       CLLocationCoordinate2D coords[model.geometry.count];
       for (int i = 0; i<model.geometry.count; i++) {
         
           NSArray *point = model.geometry[i];
           
            coords[i] = CLLocationCoordinate2DMake([point.firstObject doubleValue], [point.lastObject doubleValue]);
       }
       ///地图加载完成后绘制 线段
       if ([_mapView.overlays containsObject:self.blueLine]) {//如果已经添加了该条线 那么删除重新添加
           [_mapView removeOverlay:self.blueLine];
       }
       //初始化线
       _blueLine = [MGLPolyline polylineWithCoordinates:coords count:model.geometry.count];
       
       //将线添加到地图上
         [_mapView addOverlay:self.blueLine];
       //设置可见的区域
    
        [_mapView setVisibleCoordinateBounds:self.blueLine.overlayBounds edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES completionHandler:nil];

    
}

- (void)setSymbolWithArr:(NSArray *)arr{
    
    //添加前先移除之前添加的大头针
    if (self.annotationsArray.count) {
         [_mapView removeAnnotations:_annotationsArray];
        [self.annotationsArray removeAllObjects];
        [self.symbolPointsArr removeAllObjects];
       
    }
   
    [self.symbolPointsArr addObjectsFromArray:arr];
    
       // 添加大头针
    CLLocationCoordinate2D coords[arr.count];
    NSMutableArray *pointsArray = [NSMutableArray array];
    
      for (int i = 0; i<arr.count; i++) {
          
          MapSymbolModel *model = arr[i];
         coords[i] = CLLocationCoordinate2DMake([model.geometry.firstObject doubleValue], [model.geometry.lastObject doubleValue]);
          
          MGLPointAnnotation *pointAnnotation = [[MGLPointAnnotation alloc] init];
         pointAnnotation.coordinate  = coords[i];
         pointAnnotation.title       = model.title;
         pointAnnotation.subtitle    = model.desc;

         [pointsArray addObject:pointAnnotation];
          
      }

     [_annotationsArray addObjectsFromArray:pointsArray];
     [_mapView addAnnotations:_annotationsArray];
   
    
}





#pragma mark -- mapboxDelegate
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView{
    
   
    __weak typeof(self)  weakSelf = self;
    
    if (self.isShowUserLocation) {
       
        [weakSelf.mapView setZoomLevel:self.zoomLevel animated:YES];
        
        
    }else{
        
        if (!self.customLocaArr.count) {
            return;
        }
       
        [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.customLocaArr.firstObject doubleValue], [self.customLocaArr.lastObject doubleValue]) zoomLevel:self.zoomLevel animated:YES];
        
        
    }
    
    
    
    self.resultCallBack(@"");
       
    NSLog(@"地图加载完成");

    
      
}
#pragma mark -- 画线相关 ↓
- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    ///MGLPolyline 和 MGLPolygon 都执行这个方法
    return 0.98;
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    ///MGLPolyline 执行这个方法, MGLPolygon 不执行
    return 3.f;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    
    return [self colorWithHexString:@"#D75459"];
}

#pragma mark -- 画线相关 ↑
#pragma mark -- 大头针相关 ↓
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    MapBoxAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:MapBoxAnnotationViewCellId];
    if (annotationView == nil) {
        annotationView = [[MapBoxAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MapBoxAnnotationViewCellId isShowSymbolIndex:self.isShowSymbolIndex];
        annotationView.isShowSymbolIndex = self.isShowSymbolIndex;
        if (self.isShowSymbolIndex) {
            for (int i = 0; i<self.annotationsArray.count; i++) {
                MGLPointAnnotation *model = self.annotationsArray[i];
               if (model.coordinate.longitude == annotation.coordinate.longitude&&model.coordinate.latitude==annotation.coordinate.latitude) {
                   annotationView.titleStr = [NSString stringWithFormat:@"%d",i+1];
               }
            }
        }
        
    }
    return annotationView;
}

///是否显示气泡
-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}
///完成加载大头针
- (void)mapView:(MGLMapView *)mapView didAddAnnotationViews:(NSArray<MGLAnnotationView *> *)annotationViews {
    [mapView showAnnotations:self.annotationsArray edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES completionHandler:nil];
}
///气泡布局
- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation{
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftImageView.layer.cornerRadius = 3.f;
    leftImageView.clipsToBounds = YES;
    
    for (int i = 0; i<self.annotationsArray.count; i++) {
         MapSymbolModel *model = self.symbolPointsArr[i];
         NSString *latitude = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
        
        if ([latitude hasPrefix:[NSString stringWithFormat:@"%@",model.geometry.firstObject]]&&[longitude hasPrefix:[NSString stringWithFormat:@"%@",model.geometry.lastObject]]) {
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:model.poiImage] placeholderImage:[self imageWithColor:[self colorWithHexString:@"#999999"]]];
        }
     }
   return leftImageView;
}
- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation{
     UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
     NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"mapbox_flutter_plugin_assets" withExtension:@"bundle"];
     NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.png", @"navigating_ic",scale];
    NSString *path = [bundle pathForResource:imgName ofType:nil];
    
    rightImageView.image = [UIImage imageWithContentsOfFile:path];
      return rightImageView;
}
///气泡点击
- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id <MGLAnnotation>)annotation{
    //跳转原生导航
    CLLocationCoordinate2D desCoordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
       
       MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
       currentLocation.name = @"我的位置";
       MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
       toLocation.name = [NSString stringWithFormat:@"%@",annotation.title];
       
       [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                      launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
   
    
}


- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation{
    for (int i = 0; i<self.annotationsArray.count; i++) {
          MapSymbolModel *model = self.symbolPointsArr[i];
          NSString *latitude = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
         NSString *longitude = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
         
         if ([latitude hasPrefix:[NSString stringWithFormat:@"%@",model.geometry.firstObject]]&&[longitude hasPrefix:[NSString stringWithFormat:@"%@",model.geometry.lastObject]]) {
             [self.channel invokeMethod:@"symbol#onTap" arguments:@{@"symbol":model.poiId.length?model.poiId:@"id"}];
         }
      }
}

#pragma mark -- 大头针相关 ↑
#pragma mark -- lazy


- (NSMutableArray *)annotationsArray{
    if (!_annotationsArray) {
        _annotationsArray = [NSMutableArray array];
    }
    return _annotationsArray;
}

- (NSMutableArray *)symbolPointsArr{
    if (!_symbolPointsArr) {
        _symbolPointsArr = [NSMutableArray array];
    }
    return _symbolPointsArr;
}


- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r                       截取的range = (0,2)
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;//     截取的range = (2,2)
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;//     截取的range = (4,2)
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;//将字符串十六进制两位数字转为十进制整数
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
//默认alpha值为1
- (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}


- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
       UIGraphicsBeginImageContext(rect.size);
       CGContextRef context =UIGraphicsGetCurrentContext();
       CGContextSetFillColorWithColor(context, [color CGColor]);
       CGContextFillRect(context, rect);
       UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       return image;
}

@end
