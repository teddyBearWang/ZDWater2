//
//  GateObject.h
//  ZDWater
//  **********闸门开度****************
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GateObject : NSObject
/*
 *type: 请求类型
 */

+ (BOOL)fetchWithType:(NSString *)type;

+ (NSArray *)requestGateDatas;

@end
