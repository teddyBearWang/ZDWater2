//
//  ChartObject.h
//  ZDWater
// *************折线图或者柱状图对象*******************
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartObject : NSObject

/*
 *type: 请求方式
 *stcd: 测站编号
 *date:查询时间
 */
+ (BOOL)fetcChartDataWithType:(NSString *)type stcd:(NSString *)stcd WithDate:(NSString *)date;

/*
 *获取X轴上的数据数组
 */
+ (NSMutableArray *)requestXLables;

/*
 *获取Y轴上的数据数组
 */
+ (NSMutableArray *)requestYValues;

@end
