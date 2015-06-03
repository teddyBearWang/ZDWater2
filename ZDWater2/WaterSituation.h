//
//  WaterSituation.h
//  ZDWater
// ***********水情数据源****************
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterSituation : NSObject

/* type 请求类型 GetSqInfo
 * adcd 行政区域的编码
 * date 传入的时间
 * start 从那条数据开始
 * end 从那条数据结束
 */

+ (BOOL)fetchWithType:(NSString *)type area:(NSString *)adcd date:(NSString *)date start:(NSString *)start end:(NSString *)end;

+ (NSArray *)requestWaterData;

@end
