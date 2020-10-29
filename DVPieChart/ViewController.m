//
//  ViewController.m
//  DVPieChart
//
//  Created by Fire on 2018/3/22.
//  Copyright © 2018年 Fire. All rights reserved.
//

#import "ViewController.h"
#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "UIColor+HexColor.h"

#define HexColor(hexString) [UIColor colorWithHexString:(hexString)]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 图1
    DVPieChart *chart1 = [[DVPieChart alloc] initWithFrame:CGRectMake(20, 44, [UIScreen mainScreen].bounds.size.width-40, 320)];
    chart1.useTopZone = YES;
    chart1.useBottomZone = YES;
    chart1.useTextSize = CGSizeMake(60, 30);
    chart1.showTextBorder = YES;
    chart1.verticalLineHeight = 0;
    [self.view addSubview:chart1];
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0 ; i < 20 ; i ++) {
        [tempArray addObject:@{@"title":[NSString stringWithFormat:@"数据%d",i], @"value":[NSString stringWithFormat:@"%d",200+600*(i%7)]}];
    }
    [self setupChartView:chart1 ringsArray:tempArray];
    
    // 图2
    DVPieChart *chart2 = [[DVPieChart alloc] initWithFrame:CGRectMake(20, 380, [UIScreen mainScreen].bounds.size.width-40, 320)];
    [self.view addSubview:chart2];
    NSMutableArray *tempArray2 = [NSMutableArray new];
    for (int i = 0 ; i < 20 ; i ++) {
        [tempArray2 addObject:@{@"title":[NSString stringWithFormat:@"数据%d",i], @"value":[NSString stringWithFormat:@"%d",200+600*(i%7)]}];
    }
    [self setupChartView:chart2 ringsArray:tempArray2];
}

- (void)setupChartView:(DVPieChart *)chartView ringsArray:(NSMutableArray *)ringsArray {
    DVPieChart *tempChartView = chartView;
    NSMutableArray * dataArr = [NSMutableArray array];
    NSMutableArray * values = [NSMutableArray array];
    for (NSDictionary * dict in ringsArray) {
         [values addObject:[NSNumber numberWithDouble:[dict[@"value"] doubleValue]]];
    }
    NSNumber *sum = [values valueForKeyPath:@"@sum.self"];
    for (NSDictionary * dict in ringsArray) {
        DVFoodPieModel * newModel = [[DVFoodPieModel alloc] init];
        newModel.value = [dict[@"value"] doubleValue];
        newModel.name = dict[@"title"];
        CGFloat value = 0;
        if ([sum doubleValue] != 0) {
            value = [dict[@"value"] doubleValue]/[sum doubleValue];
        }
        newModel.rate = value;
        [values addObject:[NSNumber numberWithDouble:[dict[@"value"] doubleValue]]];
        [dataArr addObject:newModel];
    }

    tempChartView.dataArray = dataArr;
    if ([sum doubleValue] > 0) {//有数据才绘制
        tempChartView.hidden = NO;
        [tempChartView draw];
    } else {
        tempChartView.hidden = YES;
    }
    NSArray * clArr = @[HexColor(@"#E76344"),
                        HexColor(@"#55A3F4"),
                        HexColor(@"#F6BA57"),
                        HexColor(@"#71D6FF"),
                        HexColor(@"#E371FF"),
                        HexColor(@"#8365E2"),
                        HexColor(@"#46D295"),
                        HexColor(@"#A8E12A"),
                        
                        HexColor(@"#5B48A7"),
                        HexColor(@"#FF0099"),
                        HexColor(@"#F79709"),
                        HexColor(@"#3DEE11"),
                        HexColor(@"#0938F7"),
                        HexColor(@"#9709F7"),
                        HexColor(@"#EE113D"),
                        HexColor(@"#CC5233"),
                        
                        HexColor(@"#A25E87"),
                        HexColor(@"#B39E4D"),
                        HexColor(@"#666699"),
                        HexColor(@"#A9C43C"),
                        HexColor(@"#BE3085"),
                        HexColor(@"#7F796F"),
                        HexColor(@"#386AB7"),
                        HexColor(@"#08E78D")
                        ];
    tempChartView.COLOR_ARRAY = clArr;
}

@end
