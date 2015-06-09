//
//  QiXiangObject.m
//  ZDWater2
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QiXiangObject.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


@implementation QiXiangObject


+ (BOOL)fetchWithType:(NSString *)type
{
    __block BOOL ret = NO;
    
    NSURL *url = [NSURL URLWithString:URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"GetHtmlSource" forKey:@"t"];
    [request setPostValue:type forKey:@"results"];
    
//    NSString *str = [NSString stringWithFormat:@"%@t=GetHtmlSource&results=%@",URL,type];
//    NSURL *url = [NSURL URLWithString:str];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        if (request .responseStatusCode == 200) {
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
    
    return YES;
}

static NSArray *datas = nil;
+ (NSArray *)requestDatas
{
    return datas;
}

@end
