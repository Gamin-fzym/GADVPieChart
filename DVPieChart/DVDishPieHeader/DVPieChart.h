//
//  DVPieChart.h
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/26.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVPieChart : UIView

@property (assign, nonatomic) BOOL useTopZone;    /// 是否使用上方区域 展示标签
@property (assign, nonatomic) BOOL useBottomZone; /// 是否使用下方区域 展示标签

/**
 数据数组
 */
@property (strong, nonatomic) NSArray * COLOR_ARRAY;
/**
 数据数组
 */
@property (strong, nonatomic) NSArray *dataArray;

/**
 标题
 */
@property (copy, nonatomic) NSString *title;

/**
 绘制方法
 */
- (void)draw;

@end
