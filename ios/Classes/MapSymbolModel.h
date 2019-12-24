//
//  MapSymbolModel.h
//  mapbox_flutter_plugin
//
//  Created by 李运洋 on 2019/12/15.
//

#import <Foundation/Foundation.h>

#include "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface MapSymbolModel : NSObject
/** 景点名称*/
@property (nonatomic, copy)  NSString  *poiId;
/** 景点名称*/
@property (nonatomic, copy)  NSString  *title;
/** 描述*/
@property (nonatomic, copy)  NSString  *desc;
/** 景点照片*/
@property (nonatomic, copy)  NSString  *poiImage;
/** 坐标*/
@property (nonatomic, strong)  NSArray  *geometry;
@end

NS_ASSUME_NONNULL_END
