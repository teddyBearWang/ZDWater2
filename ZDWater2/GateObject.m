//
//  GateObject.m
//  ZDWater
//
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "GateObject.h"
#import "ASIFormDataRequest.h"

@implementation GateObject

+ (BOOL)fetchWithType:(NSString *)type
{
    __block BOOL ret = NO;
    NSURL *url = [NSURL URLWithString:URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:type forKey:@"t"];
    
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
+ (NSArray *)requestGateDatas
{
    return datas;
}

@end
