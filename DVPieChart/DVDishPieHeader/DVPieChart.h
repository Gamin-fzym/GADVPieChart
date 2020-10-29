//
//  DVPieChart.h
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/26.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVPieChart : UIView

/// 展示出文本区域边框
@property (assign, nonatomic) BOOL showTextBorder;
/// 是否使用上方区域 展示标签，默认不使用此区域
@property (assign, nonatomic) BOOL useTopZone;
/// 是否使用下方区域 展示标签，默认不使用此区域
@property (assign, nonatomic) BOOL useBottomZone;
/// 文本区域的大小。 默认CGSizeMake(80, 30)
@property (assign, nonatomic) CGSize useTextSize;
/// 左右指引线的横线宽度. 默认20
@property (assign, nonatomic) float horizontalLineWidth;
/// 上下指引线的竖线高度. 默认20
@property (assign, nonatomic) float verticalLineHeight;


/// 数据数组
@property (strong, nonatomic) NSArray * COLOR_ARRAY;
/// 数据数组
@property (strong, nonatomic) NSArray *dataArray;
/// 标题
@property (copy, nonatomic) NSString *title;

/// 绘制方法
- (void)draw;

@end
