//
//  MapViewObject.h
//  Runner
//
//  Created by 李运洋 on 2019/12/10.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface MapViewObject : NSObject<FlutterPlatformView>
- (id)initWithFrame:(CGRect)frame
             viewId:(int64_t)viewId
               args:(id)args
           messager:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
