//
//  WaterYield.m
//  ZDWater
//
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterYield.h"
#import "ASIHTTPRequest.h"

@implementation WaterYield


+ (BOOL)fetchWithType:(NSString *)type date:(NSString *)date
{
    __block BOOL ret = NO;
    
    NSString *str = [NSString stringWithFormat:@"%@t=%@&results=%@",URL,type,date];
    NSURL *url = [NSURL URLWithString:str];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        //成功
        if (request.responseStatusCode == 200) {
            ret = YES;
            NSData *data = request.responseData;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            datas = arr;
        }
    }];
    
    [request setFailedBlock:^{
        //失败
    }];
    [request startSynchronous];
    
    
    return ret;
    
}

static NSArray *datas = nil;
+ (NSArray *)requestWithDatas
{
    return datas;
}

@end
