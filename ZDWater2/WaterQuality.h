//
//  WaterQuality.h
//  ZDWater
//  *********水质数据源***************
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface WaterQuality : NSObject

//是否获取数据成功
+ (BOOL)FetchWithType:(NSString *)type withStrat:(NSString *)start withEnd:(NSString *)end;

//获取详细的数据
+ (NSArray *)RequestData;

@end
