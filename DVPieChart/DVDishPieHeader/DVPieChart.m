//
//  DVPieChart.m
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/26.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "DVPieCenterView.h"
#import "DVPieLocationModel.h"

@interface DVPieChart ()

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *allLocationArray;

@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableArray *centerArray;

@end

@implementation DVPieChart

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)draw {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
}

- (BOOL)judgeIsMinScreen {
    BOOL result = NO;
    if ([UIScreen mainScreen].bounds.size.width <= 375) {
        result = YES;
    }
    return result;
}

- (void)drawRect:(CGRect)rect {
    float CHART_MARGIN = 90;
    if ([self judgeIsMinScreen]) {
        CHART_MARGIN = 100;
    }
    
    /// 计算旋转角度
    float maxRate = 0;
    NSInteger kk = 0;
    for (NSInteger ll = 0 ; ll < self.dataArray.count ; ll ++) {
        DVFoodPieModel *hhmodel = [self.dataArray objectAtIndex:ll];
        if (hhmodel.rate > maxRate) {
            maxRate = hhmodel.rate;
            kk = ll;
        }
    }
    float totalRate = 0;
    for (NSInteger ll = 0 ; ll < kk ; ll ++) {
        DVFoodPieModel *hhmodel = [self.dataArray objectAtIndex:ll];
        totalRate += hhmodel.rate;
    }
    /// 1/2*M_PI = totalRate/x
    float totalJD = totalRate * 2*M_PI;
    /// 1/2*M_PI = halfMaxRate/x
    float halfMaxRate = maxRate/2.0;
    float halfJD = halfMaxRate * 2*M_PI;
    CGFloat useStart = 0;//-M_PI_2/2.0;
    if (totalJD + halfJD > M_PI) {
        useStart = -(totalJD + halfJD - M_PI);
    } else {
        useStart = M_PI - (totalJD + halfJD);
    }
    ///
    CGFloat min = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = min * 0.5 - CHART_MARGIN;
    CGFloat start = useStart;
    CGFloat angle = 0;
    CGFloat end = start;
        
    if (self.dataArray.count == 0) {
        end = start + M_PI * 2;
        UIColor *color = _COLOR_ARRAY.firstObject;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
        [color set];
        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
    } else {
        NSMutableArray *pointArray = [NSMutableArray array];
        NSMutableArray *centerArray = [NSMutableArray array];
        self.modelArray = [NSMutableArray array];
        self.colorArray = [NSMutableArray array];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            DVFoodPieModel *model = self.dataArray[i];
            CGFloat percent = model.rate;//NaN
            UIColor *color = _COLOR_ARRAY[i%_COLOR_ARRAY.count];
            start = end;
            angle = percent * M_PI * 2;
            end = start + angle;
            
            // 获取弧度的中心角度
            CGFloat radianCenter = (start + end) * 0.5;
            // 获取指引线的起点
            CGFloat lineStartX = self.frame.size.width * 0.5 + radius * cos(radianCenter);
            CGFloat lineStartY = self.frame.size.height * 0.5 + radius * sin(radianCenter);
            CGPoint point = CGPointMake(lineStartX, lineStartY);

            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            [centerArray addObject:[NSNumber numberWithFloat:radianCenter]];
            [self.modelArray addObject:model];
            [self.colorArray addObject:color];
        }
        // 处理数据顺序
        // 通过pointArray绘制指引线
        [self drawLineWithPointArray:pointArray centerArray:centerArray];
        
        start = useStart;
        angle = 0;
        end = start;
        for (int i = 0; i < self.dataArray.count; i++) {
            DVFoodPieModel *model = self.dataArray[i];
            CGFloat percent = model.rate;//NaN
            UIColor *color = _COLOR_ARRAY[i%_COLOR_ARRAY.count];
            start = end;
            angle = percent * M_PI * 2;
            end = start + angle;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
            [color set];
            //添加一根线到圆心
            [path addLineToPoint:center];
            [path fill];
        }
    }
    // 在中心添加label
    DVPieCenterView *centerView = [[DVPieCenterView alloc] init];
    centerView.frame = CGRectMake(0, 0, radius * 2 - 24, radius * 2 - 24);
    CGRect frame = centerView.frame;
    frame.origin = CGPointMake(self.frame.size.width * 0.5 - frame.size.width * 0.5, self.frame.size.height * 0.5 - frame.size.width * 0.5);
    centerView.frame = frame;
    [self addSubview:centerView];
}

// 计算和约定所有的内容位置
- (void)textAllLocation {
    if (!_allLocationArray) {
        _allLocationArray = [NSMutableArray new];
    }
    [_allLocationArray removeAllObjects];
    
    CGRect selfRect = self.frame;
    CGSize textSize = CGSizeMake(80, 30);
    float levelDistance = 30;
    if ([self judgeIsMinScreen]) {
        textSize = CGSizeMake(80, 30);
        levelDistance = 30;
    }
    float topLevelDistance = 8;
    
    float baseX = 0;//16;
    float changex = baseX;
    NSInteger p = (NSInteger)((selfRect.size.width - 2*textSize.width - 2*baseX) / textSize.width);
    changex = (selfRect.size.width - p*textSize.width)/2.0;
    
    float baseY = 10;
    float changeY = baseY;
    NSInteger s = (NSInteger)selfRect.size.height % (NSInteger)textSize.height;
    if (s < baseX*2) {
        s = s + textSize.height;
    }
    changeY = s/2.0;
    
    // 0:右侧
    NSMutableArray *tempRightArr = [NSMutableArray new];
    for (int i = 0 ; i < 100 ; i ++) {
        DVPieLocationModel *loc = [DVPieLocationModel new];
        CGRect newRect = CGRectMake(selfRect.size.width - baseX - textSize.width, changeY + i*textSize.height, textSize.width, textSize.height);
        loc.locationRect = newRect;
        loc.inPoint = CGPointMake(CGRectGetMinX(newRect), CGRectGetMinY(newRect)+textSize.height/2.0);
        loc.levelPoint = CGPointMake(loc.inPoint.x-levelDistance, loc.inPoint.y);
        loc.direction = 0;
        if (CGRectGetMaxY(newRect) > selfRect.size.height - baseY) {
            break;
        }
        [tempRightArr addObject:loc];
    }
    [_allLocationArray addObjectsFromArray:tempRightArr];
    // 1:下侧
    if (_useBottomZone) {
        NSMutableArray *tempBottomArr = [NSMutableArray new];
        for (int i = 0 ; i < 10 ; i ++) {
            DVPieLocationModel *loc = [DVPieLocationModel new];
            CGRect newRect = CGRectMake(changex + i*textSize.width, selfRect.size.height - baseY - textSize.height, textSize.width, textSize.height);
            loc.locationRect = newRect;
            loc.inPoint = CGPointMake(CGRectGetMinX(newRect) + textSize.width/2.0, CGRectGetMinY(newRect));
            loc.levelPoint = CGPointMake(loc.inPoint.x, loc.inPoint.y-topLevelDistance);
            loc.direction = 1;
            if (CGRectGetMaxX(newRect) > selfRect.size.width - changex) {
                break;
            }
            [tempBottomArr addObject:loc];
        }
        tempBottomArr = (NSMutableArray *)[[tempBottomArr reverseObjectEnumerator] allObjects];
        [_allLocationArray addObjectsFromArray:tempBottomArr];
    }
    // 2:左侧
    NSMutableArray *tempLeftArr = [NSMutableArray new];
    for (int i = 0 ; i < 100 ; i ++) {
        DVPieLocationModel *loc = [DVPieLocationModel new];
        CGRect newRect = CGRectMake(baseX, changeY + i*textSize.height, textSize.width, textSize.height);
        loc.locationRect = newRect;
        loc.inPoint = CGPointMake(CGRectGetMaxX(newRect), CGRectGetMinY(newRect)+textSize.height/2.0);
        loc.levelPoint = CGPointMake(loc.inPoint.x+levelDistance, loc.inPoint.y);
        loc.direction = 2;
        if (CGRectGetMaxY(newRect) > selfRect.size.height - baseY) {
            break;
        }
        [tempLeftArr addObject:loc];
    }
    tempLeftArr = (NSMutableArray *)[[tempLeftArr reverseObjectEnumerator] allObjects];
    [_allLocationArray addObjectsFromArray:tempLeftArr];
    // 3:上侧
    if (_useTopZone) {
        NSMutableArray *tempTopArr = [NSMutableArray new];
        for (int i = 0 ; i < 10 ; i ++) {
            DVPieLocationModel *loc = [DVPieLocationModel new];
            CGRect newRect = CGRectMake(changex + i*textSize.width, baseY, textSize.width, textSize.height);
            loc.locationRect = newRect;
            loc.inPoint = CGPointMake(CGRectGetMinX(newRect) + textSize.width/2.0, CGRectGetMaxY(newRect));
            loc.levelPoint = CGPointMake(loc.inPoint.x, loc.inPoint.y+topLevelDistance);
            loc.direction = 3;
            if (CGRectGetMaxX(newRect) > selfRect.size.width - changex) {
                break;
            }
            [tempTopArr addObject:loc];
        }
        [_allLocationArray addObjectsFromArray:tempTopArr];
    }
   
    /// 文本框提示
    for (DVPieLocationModel *loc in _allLocationArray) {
        UIView *theView = [UIView new];
        theView.frame = loc.locationRect;
        [theView.layer setBorderColor:[[UIColor blueColor] CGColor]];
        [theView.layer setBorderWidth:1];
        [self addSubview:theView];

        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        tempView.center = loc.inPoint;
        tempView.backgroundColor = [UIColor redColor];
        [self addSubview:tempView];
    }
}

// 根据一个点获取距离它最近的内容区
- (DVPieLocationModel *)getZonePointIndex:(NSInteger)index {
    CGPoint point = [self getTwistPointWithIndex:index];
    ///
    DVPieLocationModel *rModel;
    CGFloat minDistance = MAXFLOAT;
    for (DVPieLocationModel *loc in _allLocationArray) {
        if (self.dataArray.count < 5) { // 小于5条数据是不使用下部区域
            if (loc.direction == 1) {
                continue;
            }
        }
        if (!loc.isUse) {
            CGFloat distance;
            CGFloat distance1 = [self jsDistanceWithPointOne:point PointTwo:loc.levelPoint];
            CGFloat distance2 = [self jsDistanceWithPointOne:loc.levelPoint PointTwo:loc.inPoint];
            distance = distance1 + distance2;
            if (loc.direction == 1 || loc.direction == 3) {
                // 手动加长距离，让上、下为非首选
                distance = distance + 20;
            }
            if (distance < minDistance) {
                minDistance = distance;
                rModel = loc;
            }
        }
    }
    return rModel;
}

// 计算两点之间的距离
- (float)jsDistanceWithPointOne:(CGPoint)pointOne PointTwo:(CGPoint)pointTwo {
    CGFloat xDist = (pointOne.x - pointTwo.x);
    CGFloat yDist = (pointOne.y - pointTwo.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

- (void)drawLineWithPointArray:(NSMutableArray *)pointArray centerArray:(NSMutableArray *)centerArray {
    _pointArray = pointArray;
    _centerArray = centerArray;
    [self textAllLocation];

    for (int i = 0; i < pointArray.count; i++) {
        // 颜色（绘制数据时要用）
        UIColor *color = self.colorArray[i];
        // 模型数据（绘制数据时要用）
        DVFoodPieModel *model = self.modelArray[i];
        // 模型的数据
        //NSString *name = model.name;
        NSString *number = [NSString stringWithFormat:@"%.2f%%", model.rate * 100];
        NSString *name = [NSString stringWithFormat:@"%@",model.name];

        // 指引线终点的位置（x, y）
        CGPoint startPoint = [self getGuidePointWithIndex:i];
        CGFloat startX = startPoint.x;
        CGFloat startY = startPoint.y;
        // 指引线转折点的位置(x, y)
        CGPoint breakPoint = [self getTwistPointWithIndex:i];
        CGFloat breakPointX = breakPoint.x;
        CGFloat breakPointY = breakPoint.y;
        
        // 文本段落属性(绘制文字和数字时需要)
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
        // 文字靠右
        paragraph.alignment = NSTextAlignmentRight;
        
        // 指引线起点（x, y）
        DVPieLocationModel *loModel = [self getZonePointIndex:i];
        loModel.isUse = YES;
        CGFloat endX = loModel.inPoint.x;
        CGFloat endY = loModel.inPoint.y;
        
        // 绘制文字和数字时的起始位置（x, y）与上面的合并起来就是frame
        CGFloat numberX;// = breakPointX;
        CGFloat numberY = 0.0;// = breakPointY - numberHeight;
        // 绘制文字和数字时，所占的size（width和height）
        // width使用lineWidth更好，我这么写固定值是为了达到产品要求
        CGFloat numberWidth = 80.f;
        CGFloat numberHeight = 15.f;
        
        /// 方向
        if (loModel.direction == 0) { // 右侧
            paragraph.alignment = NSTextAlignmentLeft;
            numberX = endX;
            numberY = endY - numberHeight + 2;
        } else if (loModel.direction == 1) { // 下侧
            paragraph.alignment = NSTextAlignmentLeft;
            numberX = endX - numberWidth/4;
            // numberX = endX - 0;
            numberY = endY;
        } else if (loModel.direction == 2) { // 左侧
            paragraph.alignment = NSTextAlignmentRight;
            numberX = endX - numberWidth;
            numberY = endY - numberHeight;
        } else { // 上侧
            paragraph.alignment = NSTextAlignmentLeft;
            numberX = endX - numberWidth/4;
            // numberX = endX - 0;
            numberY = endY - numberHeight - 5;
        }
        
        //1.获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //2.绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(endX, endY)];
        [path addLineToPoint:CGPointMake(loModel.levelPoint.x, loModel.levelPoint.y)];
        [path addLineToPoint:CGPointMake(breakPointX, breakPointY)];
        [path addLineToPoint:CGPointMake(startX, startY)];
        CGContextSetLineWidth(ctx, 0.5);
        //设置颜色
        [color set];
        //3.把绘制的内容添加到上下文当中
        CGContextAddPath(ctx, path.CGPath);
        //4.把上下文的内容显示到View上(渲染到View的layer)(stroke fill)
        CGContextStrokePath(ctx);
        
        // 在终点处添加点(小圆点)
        // movePoint，让转折线指向小圆点中心
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        view.alpha = 0.9;
        [self addSubview:view];
        CGRect viewRect = view.frame;
        viewRect.size = CGSizeMake(4, 4);
        viewRect.origin = CGPointMake(breakPointX-2, breakPointY-2);
        view.frame = viewRect;
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = true;

        // 指引线上面的数字
        [name drawInRect:CGRectMake(numberX, numberY + 8, numberWidth, numberHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
        [number drawInRect:CGRectMake(numberX, numberY, numberWidth, numberHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    }
}

- (CGPoint)getGuidePointWithIndex:(NSInteger)index {
    // 每个圆弧中心店的位置
    CGPoint point = [_pointArray[index] CGPointValue];
    // 每个圆弧中心点的角度
    CGFloat radianCenter = [_centerArray[index] floatValue];
    // 指引线终点的位置（x, y）
    CGFloat startX = point.x + 5 * cos(radianCenter);
    CGFloat startY = point.y + 5 * sin(radianCenter);
    return CGPointMake(startX, startY);
}

- (CGPoint)getTwistPointWithIndex:(NSInteger)index {
    // 每个圆弧中心店的位置
    CGPoint point = [_pointArray[index] CGPointValue];
    // 每个圆弧中心点的角度
    CGFloat radianCenter = [_centerArray[index] floatValue];
    // 指引线转折点的位置(x, y)
    CGFloat breakPointX = point.x + 5 * cos(radianCenter);
    CGFloat breakPointY = point.y + 5 * sin(radianCenter);
    return CGPointMake(breakPointX, breakPointY);
}

@end

