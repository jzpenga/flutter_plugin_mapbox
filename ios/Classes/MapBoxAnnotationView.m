//
//  MapBoxAnnotationView.m
//  flutter_mapbox_gray
//
//  Created by 李运洋 on 2019/12/11.
//

#import "MapBoxAnnotationView.h"
@interface MapBoxAnnotationView ()

/** 标题*/
@property (nonatomic, strong)  UILabel  *titleLbl;

@end


@implementation MapBoxAnnotationView

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                 isShowSymbolIndex:(BOOL)isShowSymbolIndex{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.isShowSymbolIndex = isShowSymbolIndex;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.isShowSymbolIndex) {
        if (selected) {
           self.alpha = 1.0;
          
        }else{
            self.alpha = 0.6;
        }
    }
    
}



- (void)setupSubviews{
    
    self.backgroundColor = [self colorWithHexString:@"#D75459"];
     [self addSubview:self.titleLbl];
}

- (void)setIsShowSymbolIndex:(bool)isShowSymbolIndex{
    _isShowSymbolIndex = isShowSymbolIndex;
    
    if (self.isShowSymbolIndex) {
           self.frame = CGRectMake(0, 0, 30, 30);
           self.layer.cornerRadius = 15.f;
           self.clipsToBounds = YES;
            
          }else{
           self.frame = CGRectMake(0, 0, 20, 20);
           self.layer.cornerRadius = 10.f;
           self.clipsToBounds = YES;
           self.layer.borderColor = [UIColor whiteColor].CGColor;
           self.layer.borderWidth = 2.0;
       }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
   
    
    
}


- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLbl.text = titleStr;
}


#pragma mark -- lazy

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:16];
        
    }
    return _titleLbl;
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


@end
