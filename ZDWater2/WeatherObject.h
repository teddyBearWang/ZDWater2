//
//  WeatherObject.h
//  ZDWater2
//
//  Created by teddy on 15/6/5.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject

+ (BOOL)fetchWithArea:(NSString *)area;

+ (NSArray *)requestData;
@end
