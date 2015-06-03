//
//  MenuViewController.m
//  ZDWater2
//
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MenuViewController.h"
#import "UIView+RootView.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *noticafionBtn; //通知公告
@property (weak, nonatomic) IBOutlet UIButton *rainBtn; //实时雨情
@property (weak, nonatomic) IBOutlet UIButton *waterLevelBtn; //实时水位
@property (weak, nonatomic) IBOutlet UIButton *waterQualitybtn;//实时水质
@property (weak, nonatomic) IBOutlet UIButton *waterYieldBtn; //实时水量
@property (weak, nonatomic) IBOutlet UIButton *gateBtn; //实时闸门开度
@property (weak, nonatomic) IBOutlet UIButton *contactBtn; //通讯录
@property (weak, nonatomic) IBOutlet UIButton *weatherBtn; //天气预报

@end

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

//按钮初始化
- (void)buttonSetting{
    NSArray *btns = @[_noticafionBtn,_rainBtn,_waterLevelBtn,_waterQualitybtn,_waterYieldBtn,_gateBtn,_waterLevelBtn,
                      _contactBtn];
    for (UIButton *btn in btns) {
        [btn setCorners:5.0];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buttonSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
