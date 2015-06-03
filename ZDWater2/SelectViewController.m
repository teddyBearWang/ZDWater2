//
//  SelectViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SelectViewController.h"
#import "AreaObject.h"
#import "UIView+RootView.h"

@interface SelectViewController ()
{
    NSArray *dataSource;
    NSString *_selectArea; //选择的区域
    NSUInteger  _selectedRow; //选择的cell行
}

@end

@implementation SelectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL ret = [AreaObject fetch];
    if (ret) {
        dataSource = [AreaObject requestDatas];
    }
    
    [self.navigationItem setHidesBackButton:YES]; //设置返回按钮为隐藏
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view
        .frame.size} style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //设置左右按钮
    UIButton *comfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirm.frame = (CGRect){0,0,50,40};
    [comfirm setCorners:4];
    [comfirm setTitle:@"确定" forState:UIControlStateNormal];
    [comfirm addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:comfirm];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = (CGRect){0,0,50,40};
    [cancel setCorners:4];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
//确定
- (void)comfirmAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    //代理传值
    [self.delegate selectItemAction:_selectArea];
}

//取消
- (void)cancelAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"Adnm"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     //多选
    if (_selectItems == nil) {
        _selectItems = [NSMutableArray arrayWithCapacity:dataSource.count];
    }
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [_selectItems removeObject:area];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //添加到数组
        [_selectItems addObject:area];
    }
     */
    //不是第一次选中
    if (_selectedRow >= 0) {
        
        //取消上一次选中
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndex];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedRow = indexPath.row;
    
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.row];
    _selectArea = [dic objectForKey:@"Adnm"]; //选择的区域
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
