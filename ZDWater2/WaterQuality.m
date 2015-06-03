//
//  WaterQuality.m
//  ZDWater
//
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterQuality.h"

//#define URL @"http://115.236.2.245:38027/Data.ashx?t=GetSzInfo&results=2015-04-25$2015-04-26"

@implementation WaterQuality


//是否获取数据成功
+ (BOOL)FetchWithType:(NSString *)type withStrat:(NSString *)start withEnd:(NSString *)end;
{
    __block BOOL ret = NO;
    NSString *url_str = [NSString stringWithFormat:@"%@t=%@&results=%@$%@",URL,type,start,end];
    
    NSURL *url = [NSURL URLWithString:url_str];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        //成功
        if (request.responseStatusCode == 200) {
            ret = YES;
            NSData *json = (NSData *)request.responseData;
            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
            _waterData = jsonArr;

        }
        
    }];
    
    [request setFailedBlock:^{
        //失败
    }];
    
    [request startSynchronous];
    
    
    return ret;
}


static NSArray *_waterData = nil;
+ (NSArray *)RequestData
{
    return _waterData;
}

@end
