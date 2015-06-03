//
//  QualityDetailController.m
//  ZDWater
//  *********详细水质信息************
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QualityDetailController.h"
#import "QualityCell.h"

@interface QualityDetailController ()

@end

@implementation QualityDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"水质详情";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"QalityCell";
    QualityCell *cell = (QualityCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[QualityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //禁止选中
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.row];
    cell.keyLabel.text = [dic objectForKey:@"type"];
    cell.valueLabel.text = [[dic objectForKey:@"value"] isEqual:@""] ? @"--" : [dic objectForKey:@"value"];
    
    return cell;
}

@end
