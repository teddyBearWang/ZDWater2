//
//  WeatherObject.m
//  ZDWater2
//  ***********天气预报***************
//  Created by teddy on 15/6/5.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WeatherObject.h"
#import "ASIHTTPRequest.h"

@implementation WeatherObject

+ (BOOL)fetchWithArea:(NSString *)area
{
    __block BOOL ret = NO;
    
    NSString *str = [NSString stringWithFormat:@"%@t=GetSWeather&results=%@",URL,area];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    [request startSynchronous];
    
    
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}
@end
