//
//  DVPieLocationModel.h
//  甲丁
//
//  Created by Gamin on 9/16/20.
//  Copyright © 2020 langdaoTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DVPieLocationModel : NSObject

@property (assign, nonatomic) CGRect locationRect; // 内容区间
@property (assign, nonatomic) CGPoint inPoint; // 内容连线点
@property (assign, nonatomic) BOOL isUse; // 是否使用
@property (assign, nonatomic) NSInteger direction; // 0:右侧 1:下侧 2:左侧 3:上侧
@property (assign, nonatomic) CGPoint levelPoint; // 水平连接点

@end

NS_ASSUME_NONNULL_END
