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
#import "SVProgressHUD.h"
#import "CustomDateActionSheet.h"

@interface RainViewController ()<UITableViewDataSource,UITableViewDelegate,SelectItemsDelegate,UIActionSheetDelegate>
{
    NSArray *listData; //tableVIew的数据源
    NSMutableArray *sourceDatas;//所有的数据
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
    self.title = @"实时雨情";
    
    self.myTableView.rowHeight = 44;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    NSDate *now = [NSDate date];
    NSString *date_str = [self requestDate:now];
    
    BOOL ret = [RainObject fetchWithType:@"GetYqInfo" withArea:@"33" withDate:date_str withstart:@"0" withEnd:@"10000"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRect){0,0,50,20}];
    UIButton *filter_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    filter_btn.frame = (CGRect){0,0,20,20};
    [filter_btn setCorners:5.0];
    [filter_btn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [filter_btn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:filter_btn];
    
    UIButton *selct_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    selct_btn.frame = (CGRect){30,0,20,20};
    [selct_btn setCorners:5.0];
    [selct_btn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [selct_btn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:selct_btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
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
- (void)filterAction:(UIButton *)button
{
    SelectViewController *select = [[SelectViewController alloc] init];
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

- (void)selectTimeAction:(UIButton *)btn
{
    CustomDateActionSheet *sheet = [[CustomDateActionSheet alloc] initWithTitle:@"时间选择" delegate:self];
    [sheet showInView:self.view];
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
    sourceDatas = [NSMutableArray arrayWithArray:array];
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    //将获取到得数据传递给tableView的数据源
    listData = [NSArray arrayWithArray:sourceDatas];
    [self.myTableView reloadData];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CustomDateActionSheet *sheet = (CustomDateActionSheet *)actionSheet;
       [RainObject fetchWithType:@"GetYqInfo" withArea:@"33" withDate:sheet.selectedTime withstart:@"0" withEnd:@"10000"];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCompleteAction:) name:kLoadCompleteNotification object:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RainCell *cell = (RainCell *)[[[NSBundle mainBundle] loadNibNamed:@"Rain" owner:self options:nil] lastObject];
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
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
    if ([area isEqualToString:@"全部"]) {
        //不做筛选
        listData = (NSArray *)sourceDatas;
    }else{
        NSMutableArray *countArr = [NSMutableArray array]; //重新复制一个可变数组，保证数组内部每个元素都可以循环到
        for (int i=0; i<sourceDatas.count; i++) {
            NSDictionary *dic = [sourceDatas objectAtIndex:i];
            NSString *str = [dic objectForKey:@"Adnm"];
            if ([str isEqualToString:area]) {
                [countArr addObject:dic];
            }
        }
        //将筛选好的数据赋值给tableView的数据源
        listData = (NSArray *)countArr;
    }
    
    [self.myTableView reloadData];
}


@end
