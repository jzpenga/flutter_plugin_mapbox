//
//  MapViewLineModel.h
//  flutter_mapbox_gray
//
//  Created by 李运洋 on 2019/12/11.
//

#import <Foundation/Foundation.h>
#include "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewLineModel : NSObject

/** 线的颜色*/
@property (nonatomic, copy)  NSString  *lineColor;
/** 线的宽度*/
@property (nonatomic, assign) CGFloat lineWidth;
/** 线的透明度*/
@property (nonatomic, assign) CGFloat lineOpacity;

/** 坐标列表*/
@property (nonatomic, strong)  NSArray  *geometry;
@end

NS_ASSUME_NONNULL_END
