//
//  DoubleChartObject.h
//  ZDWater
// ***************两条线或者两条柱状图对象******************************
//  Created by teddy on 15/6/1.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

// http://115.236.2.245:38027/data.ashx?t=GetZmChart&results=821802$2015-05-29
#import <Foundation/Foundation.h>

@interface DoubleChartObject : NSObject

/*
 *type: 请求方式
 *stcd: 测站编号
 *date:查询时间
 */
+ (BOOL)fetchDOubleChartDataWithType:(NSString *)type stcd:(NSString *)stcd WithDate:(NSString *)date;

/*
 *获取X轴上的数据数组
 */
+ (NSMutableArray *)requestXLables;

/*
 *获取Y轴上的数据数组
 */
+ (NSMutableArray *)requestYValues;

@end
