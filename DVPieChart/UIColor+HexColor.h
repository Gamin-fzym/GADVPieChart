//
//  UIColor+HexColor.h
//  TunnelBridge
//
//  Created by YLJ on 15/10/29.
//  Copyright © 2015年 __ZhongTeng__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
