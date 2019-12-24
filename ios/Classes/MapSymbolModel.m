//
//  MapSymbolModel.m
//  mapbox_flutter_plugin
//
//  Created by 李运洋 on 2019/12/15.
//

#import "MapSymbolModel.h"

@implementation MapSymbolModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"poiId":@"id"};
}

@end
