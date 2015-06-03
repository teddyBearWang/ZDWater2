
//
//  ChartObject.m
//  ZDWater
//
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChartObject.h"
#import "ASIFormDataRequest.h"

//http://115.236.2.245:38027/data.ashx?t=GetStDayYL&results=8217$2015-04-27%2016:35:25

@implementation ChartObject

/*
 *type: 请求方式
 *stcd: 测站编号
 *date:查询时间
 */
+ (BOOL)fetcChartDataWithType:(NSString *)type stcd:(NSString *)stcd WithDate:(NSString *)date
{
    __block BOOL ret = NO;
    
   // date = @"2015-04-27 16:35:25"; //雨情
    //date = @"2015-04-14"; //水位
    NSString *str = [NSString stringWithFormat:@"%@$%@",stcd,date];
    NSURL *url = [NSURL URLWithString:URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:type forKey:@"t"];
    [request setPostValue:str forKey:@"results"];
    
    [request setCompletionBlock:^{
        //成功
        if (request.responseStatusCode == 200) {
            ret = YES;
            NSData *data = request.responseData;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (x_Labels == nil) {
                x_Labels = [NSMutableArray array];
            }else if(x_Labels.count != 0){
                [x_Labels removeAllObjects];
            }
            
            if (y_values == nil) {
                y_values = [NSMutableArray array];
            }else if (y_values.count != 0){
                [y_values removeAllObjects];
            }
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = [arr objectAtIndex:i];
                [x_Labels addObject:[dic objectForKey:@"time"]];
                [y_values addObject:[dic objectForKey:@"value"]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        //失败
    }];
    
    [request startSynchronous];
    
    return ret;
}

/*
 *获取X轴上的数据数组
 */

static NSMutableArray *x_Labels = nil;
+ (NSMutableArray *)requestXLables
{
    return x_Labels;
}

/*
 *获取Y轴上的数据数组
 */

static NSMutableArray *y_values = nil;
+ (NSMutableArray *)requestYValues
{
    return y_values;
}

@end
