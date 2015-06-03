//
//  RainObject.h
//  ZDWater
//  ***********雨情数据源****************
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RainObject : NSObject

/* type 请求类型 GetYqInfo
 * adcd 行政区域的编码
 * date 传入的时间
 * start 从那条数据开始
 * end 从那条数据结束
 */
//获取水情列表数据
+ (BOOL)fetchWithType:(NSString *)type withArea:(NSString *)adcd withDate:(NSString *)date withstart:(NSString *)start withEnd:(NSString *)end;

/*
+ (NSArray *)requestRainData;
 
 
*/

@end
