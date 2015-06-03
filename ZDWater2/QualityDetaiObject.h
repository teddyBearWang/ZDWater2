//
//  QualityDetaiObject.h
//  ZDWater
//   **********水质信息详情***********
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QualityDetaiObject : NSObject

/*
 * type: 请求数据的类型 GetSzInfoView
 * start: 开始时间
 * end: 结束时间
 * stcd: 测站编号s
 */
+ (BOOL)fetchWithType:(NSString *)type start:(NSString *)start end:(NSString *)end stcd:(NSString *)stcd;

+ (NSArray *)requestDetailData;

@end
