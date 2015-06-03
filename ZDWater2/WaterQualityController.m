//
//  WaterQualityController.m
//  ZDWater2
//      ********水质***********
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterQualityController.h"
#import "CustomHeaderView.h"
#import "WaterQuality.h"
#import "WaterCell.h"
#import "QualityDetailController.h"
#import "QualityDetaiObject.h"
#import "CustomDateActionSheet.h"
#import "ChartViewController.h"

@interface WaterQualityController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WaterQualityController

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
    
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实时水质";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    NSDate *now = [NSDate date];
    NSArray *dates =(NSArray *)[self getRequestDates:now];
    
    BOOL ret = [WaterQuality FetchWithType:@"GetSzInfo" withStrat:[dates objectAtIndex:0] withEnd:[dates objectAtIndex:1]];
    if (ret) {
        listData = [WaterQuality RequestData];
    }
    
    UIButton *selectTime_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectTime_btn.frame = (CGRect){0,0,60,40};
    selectTime_btn.backgroundColor = [UIColor clearColor];
    selectTime_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectTime_btn setTitle:@"时间选择" forState:UIControlStateNormal];
    [selectTime_btn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:selectTime_btn];
    self.navigationItem.rightBarButtonItem = item;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)getRequestDates:(NSDate *)nowDate
{
    NSMutableArray *dates = [NSMutableArray array];
    NSTimeInterval seconds = 24 * 60 *60;
    //当前时间的前一天
    NSDate *torrow = [nowDate dateByAddingTimeInterval:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //时间字符串
    NSString *now = [formatter stringFromDate:nowDate];
    NSString *torrTd = [formatter stringFromDate:torrow];
    [dates addObject:now];
    [dates addObject:torrTd];
    return dates;
}

- (NSDate *)getDateFromString:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:str];
    NSDate *date1 = [date dateByAddingTimeInterval:24*60*60];//由于存在时间差，实际的日期应该加上1
    return date1;
}

//时间选择
- (void)selectTimeAction:(id)sender
{
    CustomDateActionSheet *sheet = [[CustomDateActionSheet alloc] initWithTitle:@"时间选择" delegate:self];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CustomDateActionSheet *sheet = (CustomDateActionSheet *)actionSheet;
        
        NSDate *time = [self getDateFromString:sheet.selectedTime];
        NSArray *dates =(NSArray *)[self getRequestDates:time];
        BOOL ret = [WaterQuality FetchWithType:@"GetSzInfo" withStrat:[dates objectAtIndex:0] withEnd:[dates objectAtIndex:1]];
        if (ret) {
            listData = [WaterQuality RequestData];
        }
        [self.myTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
    if (cell == nil) {
        cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    cell.stationName.text = [[dic objectForKey:@"CZMC"] isEqual:@""] ? @"--" : [dic objectForKey:@"CZMC"];
    cell.lastestLevel.text = [[dic objectForKey:@"SZDJ"] isEqual:@""] ? @"--" : [dic objectForKey:@"JD"];
    cell.warnWater.text = [[dic objectForKey:@"WD1"] isEqual:@""] ? @"--" : [dic objectForKey:@"WD"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"站名" withSecond:@"水质等级" withThree:@"温度"];
    view.backgroundColor = BG_COLOR;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *now = [NSDate date];
    NSArray *dates =(NSArray *)[self getRequestDates:now]; //时间数组
    
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    BOOL ret = [QualityDetaiObject fetchWithType:@"GetSzInfoView" start:[dates objectAtIndex:0] end:[dates objectAtIndex:1] stcd:[dic objectForKey:@"CZBH"]];
    if (ret) {
        QualityDetailController *quality = [[QualityDetailController alloc] init];
        //获取数据源
        quality.datas = [QualityDetaiObject requestDetailData];
        [self.navigationController pushViewController:quality animated:YES];
    }else{
        //获取数据失败
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
