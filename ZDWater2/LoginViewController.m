//
//  LoginViewController.m
//  ZDWater2
//
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()
- (IBAction)loginAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆";
    self.view.backgroundColor = BG_COLOR;
    
    
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

- (IBAction)loginAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MenuViewController *menu = (MenuViewController *)[story instantiateViewControllerWithIdentifier:@"menu"];
    [self.navigationController pushViewController:menu animated:YES];
}
@end
