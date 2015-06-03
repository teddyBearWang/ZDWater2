//
//  NotificationViewController.m
//  ZDWater2
//  *************通知公告***************
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知公告";
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
