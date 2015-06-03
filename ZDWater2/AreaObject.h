//
//  AreaObject.h
//  ZDWater
// *******行政区划*************
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaObject : NSObject

+ (BOOL) fetch;

+ (NSArray *)requestDatas;

@end
