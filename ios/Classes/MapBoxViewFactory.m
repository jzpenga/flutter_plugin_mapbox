//
//  MapBoxViewFactory.m
//  flutter_mapbox_gray
//
//  Created by 李运洋 on 2019/12/11.
//

#import "MapBoxViewFactory.h"
#import "MapViewObject.h"
@interface MapBoxViewFactory ()
@property(nonatomic)NSObject<FlutterBinaryMessenger>* messenger;
@end

@implementation MapBoxViewFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        self.messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    
    MapViewObject *mapviewObject = [[MapViewObject alloc] initWithFrame:frame viewId:viewId args:args messager:self.messenger];
    return mapviewObject;
    
}




@end
