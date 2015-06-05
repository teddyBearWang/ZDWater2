//
//  WaterLevelController.m
//  ZDWater2
//  ************水位**************
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterLevelController.h"
#import "CustomHeaderView.h"
#import "WaterSituation.h"
#import "WaterCell.h"
#import "ChartViewController.h"
#import "SVProgressHUD.h"
#import "CustomDateActionSheet.h"

@interface WaterLevelController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSArray *waterLevels; //水情数据源
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WaterLevelController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制屏幕横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



static BOOL ret = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实时水位";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    UIButton *select_time = [UIButton buttonWithType:UIButtonTypeCustom];
    select_time.frame = (CGRect){0,0,20,20};
    select_time.backgroundColor = [UIColor clearColor];
    select_time.titleLabel.font = [UIFont systemFontOfSize:14];
    [select_time setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [select_time addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:select_time];
    self.navigationItem.rightBarButtonItem = item;

    NSDate *now = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:now];
//    NSDate *localDate = [now dateByAddingTimeInterval:interval];
    NSString *date_str = [self getStringWithDate:now];
    [self refresh:date_str];
}

- (void)selectTimeAction:(UIButton *)btn
{
    CustomDateActionSheet *sheet = [[CustomDateActionSheet alloc] initWithTitle:@"时间选择" delegate:self];
    [sheet showInView:self.view];
}

- (void)refresh:(NSString *)date
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    //创建一个队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([WaterSituation fetchWithType:@"GetSqInfo" area:@"33" date:date start:@"0" end:@"10000"]) {
            //请求网络成功之后，在主线程更新UI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //进入到主线程，更新UI
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

//主线程更新UI
- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        waterLevels = [WaterSituation requestWaterData];
        ret = YES;
        if (waterLevels.count == 0) {
            ret = NO;
            waterLevels = [NSArray arrayWithObject:@"当前暂无水情数据"];
        }
        [self.myTableView reloadData];
    });
}

//根据时间格式化时间字符串
- (NSString *)getStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
}

//格式化选择时间字符串
- (NSString *)getStringWithSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    NSString *date_str = [NSString stringWithFormat:@"%@ 23:59:59",str];
    return date_str;
}

//将时间字符串格式化为时间
- (NSDate *)dateFromDateString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CustomDateActionSheet *sheet = (CustomDateActionSheet *)actionSheet;
        NSDate *date = [self dateFromDateString:sheet.selectedTime];
        NSString *str_time = [self getStringWithSelectDate:date];
        [self refresh:str_time];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return waterLevels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ret)
    {
        //有数据的时候
        WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        if (cell == nil) {
            cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:self options:nil] lastObject];
        }
        NSDictionary *dic = [waterLevels objectAtIndex:indexPath.row];
        cell.stationName.text = [[dic objectForKey:@"Stnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"Stnm"];
        cell.lastestLevel.text = [[dic objectForKey:@"NowValue"] isEqual:@""] ? @"--" : [dic objectForKey:@"NowValue"];
        cell.warnWater.text = [[dic objectForKey:@"WarningLine"] isEqual:@""] ? @"--" : [dic objectForKey:@"WarningLine"];
        return cell;
    }else{
        //无数据
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [waterLevels objectAtIndex:0];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"测站" withSecond:@"最新(m)" withThree:@"超警(m)"];
    view.backgroundColor = BG_COLOR;
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [waterLevels objectAtIndex:indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.title_name = dic[@"Stnm"];
    chart.requestType = @"GetStDaySW";
    chart.stcd = dic[@"Stcd"];
    chart.chartType = 1;
    chart.functionType = FunctionSingleChart;
    [self.navigationController pushViewController:chart animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
