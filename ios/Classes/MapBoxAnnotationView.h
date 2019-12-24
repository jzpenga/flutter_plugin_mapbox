//
//  MapBoxAnnotationView.h
//  flutter_mapbox_gray
//
//  Created by 李运洋 on 2019/12/11.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapBoxAnnotationView : MGLAnnotationView

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                 isShowSymbolIndex:(BOOL)isShowSymbolIndex;

/** <#注释#>*/
@property (nonatomic, copy)  NSString  *titleStr;
/** 是否显示 大头针编号*/
@property (nonatomic, assign) bool  isShowSymbolIndex;
@end

NS_ASSUME_NONNULL_END
