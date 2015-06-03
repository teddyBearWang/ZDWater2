//
//  WaterYield.h
//  ZDWater
//  *************水量*****************
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterYield : NSObject

/*
 * type:请求类型
 * date:请求时间
 */
+ (BOOL)fetchWithType:(NSString *)type date:(NSString *)date;

+ (NSArray *)requestWithDatas;

@end
