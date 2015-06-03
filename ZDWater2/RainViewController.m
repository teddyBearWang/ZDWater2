//
//  RainViewController.m
//  ZDWater2
//
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainViewController.h"
#import "ChartViewController.h"
#import "SelectViewController.h"
#import "RainCell.h"
#import "RainObject.h"
#import "UIView+RootView.h"

@interface RainViewController ()<UITableViewDataSource,UITableViewDelegate,SelectItemsDelegate>
{
    NSMutableArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RainViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实时水情";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    NSDate *now = [NSDate date];
    NSString *date_str = [self requestDate:now];
    
    BOOL ret = [RainObject fetchWithType:@"GetYqInfo" withArea:@"33" withDate:date_str withstart:@"0" withEnd:@"10000"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){0,0,60,40};
    [btn setCorners:5.0];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectAreaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCompleteAction:) name:kLoadCompleteNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//页面消失的时候
- (void)viewWillDisappear:(BOOL)animated
{
    //移除详细对象
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoadCompleteNotification object:nil];
}

#pragma  mark - Private Method
//筛选按钮
- (void)selectAreaAction:(UIButton *)button
{
    SelectViewController *select = [[SelectViewController alloc] init];
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

//返回时间字符串
- (NSString *)requestDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
    
}

- (void)loadCompleteAction:(NSNotification *)notification
{
    NSArray *array = (NSArray *)notification.object;
    listData = [NSMutableArray arrayWithArray:array];
    [self.myTableView reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:@"RainCell" forIndexPath:indexPath];
    
    RainCell *cell = (RainCell *)[[[NSBundle mainBundle] loadNibNamed:@"Rain" owner:self options:nil] lastObject];
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    cell.area.text = [[dic objectForKey:@"Adnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"Adnm"];
    cell.stationName.text = [[dic objectForKey:@"Stnm"] isEqual:@""]?@"--" : [dic objectForKey:@"Stnm"];
    cell.oneHour.text = [[dic objectForKey:@"Last1Hours"] isEqual:@""] ? @"--" :[dic objectForKey:@"Last1Hours"];
    
    cell.threeHour.text = [[dic objectForKey:@"Last3Hours"] isEqual:@""] ? @"--" : [dic objectForKey:@"Last3Hours"];
    cell.today.text = [[dic objectForKey:@"Last6Hours"] isEqual:@""] ?@"--" : [dic objectForKey:@"Last6Hours"];
    return cell;
}

//这样的话，headView不随着cell滚动
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"RainHeaderView" owner:self options:nil] lastObject];
    
    headView.backgroundColor = BG_COLOR;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.title_name = dic[@"Stnm"];
    chart.stcd = dic[@"Stcd"];
    chart.requestType = @"GetStDayYL";
    chart.chartType = 2; //表示柱状图
    chart.functionType = FunctionSingleChart;
    [self.navigationController pushViewController:chart animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SelectItemsDelegate

- (void)selectItemAction:(NSString *)area
{
    NSMutableArray *countArr = [NSMutableArray arrayWithArray:listData]; //重新复制一个可变数组，保证数组内部每个元素都可以循环到
    for (int i=0; i<countArr.count; i++) {
        NSDictionary *dic = [countArr objectAtIndex:i];
        NSString *str = [dic objectForKey:@"Adnm"];
        if (![str isEqual:area]) {
            [listData removeObject:dic];
        }
    }
    
    [self.myTableView reloadData];
}


@end
